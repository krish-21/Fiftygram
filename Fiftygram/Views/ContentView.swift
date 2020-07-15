//
//  ContentView.swift
//  Fiftygram
//
//  Created by Krishna Nanduri on 14/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import SwiftUI

import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    // the image to display
    @State private var image: Image?
    
    // Boolean to show the sheet
    @State private var showingImagePicker = false
    
    // UIImage passed from ImagePicker
    //         to load Image in loadImage()
    @State private var inputImage: UIImage?
    
    // UIImage to save into the PhotoAlbum
    @State private var filteredUIImage: UIImage?
    
    @State private var imageSaved: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Display Image
                image?
                    .resizable()
                    .scaledToFit()
                
                // Space everything properly
                Spacer()
                
                // Sepia
                Button(action: {
                    self.applySepia()
                }) {
                    CustomButtonText(buttonText: "Sepia", buttonColor: Color.red)
                }
                
                // Noir
                Button(action: {
                    self.applyNoir()
                }) {
                    CustomButtonText(buttonText: "Noir", buttonColor: Color.green)
                }
                
                // Vintage
                Button(action: {
                    self.applyVintage()
                }) {
                    CustomButtonText(buttonText: "Vintage", buttonColor: Color.blue)
                }
                
                // Pixellate
                Button(action: {
                    self.applyCustom()
                }) {
                    CustomButtonText(buttonText: "Pixellate", buttonColor: Color.gray)
                }
                
                // Save Photo
                Button(action: {
                    self.saveImage()
                }) {
                    CustomButtonText(buttonText: "Save Photo", buttonColor: Color.yellow)
                }
            }
            .navigationBarTitle("Fiftygram")
            // Butto to pick the image
            .navigationBarItems(trailing:
                Button("Choose Photo") {
                    self.showingImagePicker = true
                }
            )
            .alert(isPresented: $imageSaved) {
                Alert(title: Text("Important"), message: Text("The filtered image has been saved to Photos"), dismissButton: .default(Text("Ok")))
            }
        }
        // a view stacker on top of the current view, pop-up-ish
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    // load the UIImage data into an image
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    // convert the UIImage picked by the use into a CIImage for filtering
    func getCGImage() -> CIImage {
        guard let inputImage = inputImage else {
            print("inputImage failure")
            fatalError("inputImage failure")
        }
        guard let startImage = CIImage(image: inputImage) else {
            print("startImage failure")
            fatalError("inputImage failure")
        }
        
        return startImage
    }
    
    // apply the filter & update the image
    func applyFilter(filter: CIFilter) {
        let context = CIContext()
        
        // check if filtered image is fine
        guard let filteredImage = filter.outputImage else {
            print("outputImage problem")
            return
        }
        
        // create a CGImage from the filtered image
        if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) {
            print("cgImage fine")
            // convert the CGImage to a UIImage
            filteredUIImage = UIImage(cgImage: cgImage)
            // diplay the UIImage
            image = Image(uiImage: filteredUIImage!)
        }
        print("cgImage problem")
    }
    
    // apply Sepia filter on image
    func applySepia() {
        let startImage = getCGImage()

        let currentFilter = CIFilter.sepiaTone()
        
        currentFilter.inputImage = startImage
        currentFilter.intensity = 1  // sepia intensity
        
        applyFilter(filter: currentFilter)
    }
    
    // apply Noir filter on image
    func applyNoir() {
        let startImage = getCGImage()

        let currentFilter = CIFilter.photoEffectNoir()
        
        currentFilter.inputImage = startImage

        applyFilter(filter: currentFilter)
    }
    
    // apply Vintage filter on image
    func applyVintage() {
        let startImage = getCGImage()

        let currentFilter = CIFilter.photoEffectProcess()
        
        currentFilter.inputImage = startImage
        
        applyFilter(filter: currentFilter)
    }
    
    // apply Custom filter on image
    func applyCustom() {
        let startImage = getCGImage()

        let currentFilter = CIFilter.pixellate()
        
        currentFilter.scale = 25  // pixellating scale
        currentFilter.inputImage = startImage
        
        applyFilter(filter: currentFilter)
    }
    
    // save Image to Photo Album
    func saveImage() {
        let imageSaver = ImageSaver()
        if let uiImage = filteredUIImage {
            imageSaver.writeToPhotoAlbum(image: uiImage)
            imageSaved = true
        }
    }
}

// Custom View for each button
struct CustomButtonText: View {
    
    @State var buttonText: String
    @State var buttonColor: Color
    
    var body: some View {
        Text(buttonText)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .font(.title)
            .foregroundColor(.white)
            .background(buttonColor)
            .cornerRadius(36)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
