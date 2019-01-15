//
//  NetworkRequest.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

enum HttpMethod : String {
  case get
  func toString() -> String {
    switch self {
    case .get:
      return "GET"
    }
  }
}

enum StringURLRequest: String {
  case host = "https://raw.githubusercontent.com/scoremedia/league-navigator/master/"
  
  static func fetchAllLeauges() -> String {
    return StringURLRequest.host.rawValue + "leagues.json"
  }
  
  static func fetchTeamsOfLeague( league: String) -> String {
    return StringURLRequest.host.rawValue + "leagues/\(league).json"
  }
}

class NetworkRequests: AsyncOperation {
  
  var handler: ((Data?, String?) -> Void)?
  var url: String?
  var httpMethod: String?
  
  init(_ url: String, httpMethod: HttpMethod = .get, handler: @escaping (Data?, String?) -> Void) {
    super.init()
    self.handler = handler
    self.url = url
    self.httpMethod = httpMethod.toString()
  }
  
  override func main() {
    
    if let url = url, let request = createURLRequest(url, httpMethod: httpMethod ?? "GET") {
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        
        if error != nil {
          self?.handler?(nil, error?.localizedDescription)
          self?.state = .Finished
          return
        }
        if let responseCode = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= responseCode, let data = data {
            self?.handler?(data, nil)
          } else {
            self?.handler?(nil,"Error code \(responseCode)")
          }
        }
        self?.state = .Finished
        }.resume()
    }
  }
  
  func createURLRequest(_ url: String, httpMethod: String) -> URLRequest? {
    guard let url = URL(string: url) else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }
}



