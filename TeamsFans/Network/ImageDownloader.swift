//
//  ImageDownloader.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloading: AsyncOperation {
  
  var request: URLRequest?
  var handlerUrl: ((UIImage?, String?, String?) -> Void)?
  
  init(_ url: String, handlerUrl: @escaping (UIImage?, String?, String?) -> (Void)) {
    super.init()
    self.handlerUrl = handlerUrl
    guard let urlCheck = URL(string: url) else {
      handlerUrl(nil, "URL isn't correct", url)
      return
    }
    request = URLRequest(url: urlCheck)
    request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
  }
  
  override func main() {
    guard let request = self.request else {
      self.state = .Finished
      return
    }
    if let image = CacheImages.shared.imageCache?.object(forKey: request.url?.absoluteString as AnyObject) as? UIImage {
      self.handlerUrl?(image, nil, request.url?.absoluteString )
      self.state = .Finished
      return
    } else {
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        
        if error != nil {
          self?.handlerUrl?(nil, error?.localizedDescription, request.url?.absoluteString)
          self?.state = .Finished
          return
        }
        if let response = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= response, let data = data {
            if  let image = UIImage(data: data) {
              CacheImages.shared.imageCache?.setObject(image, forKey: request.url?.absoluteString as AnyObject)
              self?.handlerUrl?(image, nil, request.url?.absoluteString )
            }
          } else {
            self?.handlerUrl?(nil, "Status code \(response)", request.url?.absoluteString)
          }
        }
        self?.state = .Finished
        }.resume()
    }
  }
}
