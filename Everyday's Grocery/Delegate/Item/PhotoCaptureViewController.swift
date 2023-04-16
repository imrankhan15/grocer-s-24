//
//  PhotoCaptureViewController.swift
//  Everyday's Grocery
//
//  Created by Muhammad Faisal Imran Khan on 14/7/19.
//  Copyright © 2019 MI Apps. All rights reserved.
//

import UIKit
import AVFoundation

protocol PhotoCaptureViewControllerDelegate
{
    func PhotoCaptureViewControllerResponse(url: String)
}
class PhotoCaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var button_accept: UIButton!
    @IBOutlet weak var button_retake: UIButton!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbl_text: UILabel!
   
    @IBOutlet weak var viewBackground: UIView!
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var delegate: PhotoCaptureViewControllerDelegate?
    var stillImageOutput = AVCapturePhotoOutput()
    
    var image = UIImage()
    var captureSession = AVCaptureSession()
    var savedImageUrl = String()

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        
        imageView.isHidden = true
        previewLayer = AVCaptureVideoPreviewLayer()
        stillImageOutput = AVCapturePhotoOutput()
        image = UIImage()
        captureSession = AVCaptureSession()
        savedImageUrl = String()
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        let inputDevice = AVCaptureDevice.default(for: AVMediaType.video)
        stillImageOutput = AVCapturePhotoOutput()
        
        if let input = try? AVCaptureDeviceInput(device: inputDevice!) {
            if (self.captureSession.canAddInput(input)) {
                self.captureSession.addInput(input)
                if (captureSession.canAddOutput(stillImageOutput)) {
                    captureSession.addOutput(stillImageOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = viewBackground.bounds
                    viewBackground.layer.insertSublayer(previewLayer, at: 0)
                    captureSession.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        button_accept.backgroundColor = UIColor.white
        button_accept.setTitleColor(UIColor.black, for: .normal)
        button_retake.backgroundColor = UIColor.white
        button_retake.setTitleColor(UIColor.black, for: .normal)
        button_accept.layer.cornerRadius = 2.0
        button_retake.layer.cornerRadius = 2.0
        button_accept.isHidden = true
        button_retake.isHidden = true
        imgTick.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(capturePhoto))
        tapGesture.delegate = self
        imgTick.addGestureRecognizer(tapGesture)
    }
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
   
    

    @IBAction func button_action(_ sender: UIButton) {
        
        if (!image.isEqual(nil)){
            let viewImage = image as UIImage
            let imageName = saveImageDataWithImage(viewImage)
            savedImageUrl = imageName
            self.delegate?.PhotoCaptureViewControllerResponse(url: savedImageUrl)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
   
   
    
    @IBAction func button_retake(_ sender: UIButton) {
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewBackground.bounds
        viewBackground.layer.insertSublayer(previewLayer, at: 0)
        captureSession.startRunning()
        button_accept.isHidden = true
        button_retake.isHidden = true
        imageView.isHidden = true
        imgTick.isHidden = false
        lbl_text.isHidden = false
    }
    
  
}

extension PhotoCaptureViewController {
    
    
    func setup() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
      
        button_accept.isHidden = true
        button_retake.isHidden = true
        imageView.isHidden = true
        imgTick.isHidden = false
        lbl_text.isHidden = false
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            imageView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: dataImage)
            image = UIImage(data: dataImage)!
            imageView.isHidden = false
            imgTick.isHidden = true
            previewLayer.removeFromSuperlayer()
            self.captureSession.stopRunning()
        }
        button_accept.layer.zPosition = 1.0
        button_retake.layer.zPosition = 1.0
        button_accept.isHidden = false
        button_retake.isHidden = false
        lbl_text.isHidden = true
    }

}
extension PhotoCaptureViewController {
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImageDataWithImage(_ sender: UIImage) -> String{
        
        let date = Int64(Date().timeIntervalSince1970 * 1000)
        let photoName = date.description + ".jpeg"
        if let data = sender.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(photoName)
            try? data.write(to: filename)
        }
        
        return photoName
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
