app name: grocers24

app details: Using the Grocer's24 App you now can easily make grocery lists, can check your expenses in grocery and store the grocery details for future reference

here is the demonstration video :  https://youtu.be/DVPQE5t7WL4 



Techstacks:

AVfoundation:

I have used AVfoundation in PhotoCaptureViewController.swift file. It creates an AVCaptureVideoPreviewLayer on top of BackgroundView. The image is captured and set to Background.

Storage:

I have used NSKeyedArchiever to store and retrieve data.

Testing:

1. Test if it can load the view.
2. Test if there is a necessary number of rows in the table view.




# commit bcea2f8

In this edit, I have added tests for the grocers 24 app. I have implemented horizontal architectures. And decoupled different portions of the view controller into different extensions and simplified the view controller.  

Here is the horizontal architecture of this app. Every module has model and controller. The storyboard is decoupled from these modules. All the modules depend on the same storeyboard for the view generation.


![Screenshot 2023-04-16 at 11 18 29 PM](https://user-images.githubusercontent.com/7940474/232329518-87b6c535-3eec-4329-9012-22862f2cf399.png)


** Testing and architecture tutorial from https://iosacademy.essentialdeveloper.com/


