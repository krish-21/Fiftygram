//
//  ImagePicker.swift
//  Fiftygram
//
//  Created by Krishna Nanduri on 15/07/20.
//  ImagePicker absent in SwiftUI: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller
//

import SwiftUI

// builds on View
// can be used inside SwiftUI directly, doesn't need a body property as the view's body is the view controller itself - it just shows what UIKit returns
struct ImagePicker: UIViewControllerRepresentable {
    
    // to dismiss the view programmatically
    @Environment(\.presentationMode) var presentationMode
    
    // in React terms - lift state up
    @Binding var image: UIImage?
    
    // Coordinators are delegates for UIKit's View Controllers
    // NSObject - Parent class of almostt everything in UIKit
    // UIImaePickerControllerDelegate - detect when user selects an image
    // UINavigationControllerDelegate - detect when user moves between screens
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // function to actually pick the image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // dig through the dictionary to get the selected image
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    // automaticaly called by SwiftUI & creates an instance of the Coordinator class we defined & returns it as the Coordinator of the ImagePicker Struct
    // this object is automaticaly passed by SwiftUI under context to the below functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // create the initial View (UIImage Picker Controller)
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // picker object
        let picker = UIImagePickerController()
        // assign the coordinator to the picker's delegate
        picker.delegate = context.coordinator
        return picker
    }
    
    // update the view controller if state changes
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
