//
//  StorageManager.swift
//  BeerApp
//
//  Created by Богдан Бончев on 12.03.2024.
//

import UIKit

class StorageManager {
    
    static let shared = StorageManager()
    
    private let imageQueue = DispatchQueue(label: "imageQueue", attributes: .concurrent)
    var images: [String: UIImage?]{
        var images: [String: UIImage?] = [:]
        imageQueue.sync {
            images = _images
        }
        return images
    }
    
    
    private var _images: [String: UIImage?] = [:]
    
    private  init (){}
    
    func saveImage(_ image: UIImage?, forKey: String){
        imageQueue.async(flags: .barrier){
            self._images[forKey] = image
            
        }
    }
}

