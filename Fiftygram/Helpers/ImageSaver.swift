//
//  ImageSaver.swift
//  Fiftygram
//
//  Created by Krishna Nanduri on 15/07/20.
//  Copyright © 2020 Krishna Nanduri. All rights reserved.
//

import Foundation
import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("save finished")
    }
}
