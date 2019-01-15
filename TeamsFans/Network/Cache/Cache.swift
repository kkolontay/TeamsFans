//
//  Cache.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

class CacheImages {
  static  let shared = CacheImages()
  var imageCache: NSCache<AnyObject, AnyObject>?
  private init() {
    imageCache = NSCache<AnyObject, AnyObject>()
  }
}
