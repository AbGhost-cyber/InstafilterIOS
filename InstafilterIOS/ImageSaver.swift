//
//  ImageSaver.swift
//  InstafilterIOS
//
//  Created by dremobaba on 2023/1/17.
//

import UIKit

class ImageSaver: NSObject {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?,
                             contextInfo: UnsafeRawPointer){
    }
}
