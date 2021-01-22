//
//  ImageCacheManager.swift
//  W4_GCD
//
//  Created by Beomcheol Kwon on 2021/01/21.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
