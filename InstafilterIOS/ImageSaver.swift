//
//  ImageSaver.swift
//  InstafilterIOS
//
//  Created by dremobaba on 2023/1/17.
//

import UIKit

class ImageSaver: NSObject {
    var onComplete: ((Error?) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) -> ImageSaver {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        return self
    }
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?,
                             contextInfo: UnsafeRawPointer){
        onComplete?(error)
    }
}
