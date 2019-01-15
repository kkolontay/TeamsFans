//  
//  LeaguesService.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation


protocol LeaguesServiceProtocol {
    func fetchLeagues(success: @escaping([LeaguesModel]) -> Void, errorMessage: @escaping(String) -> Void)
}

class LeaguesService: LeaguesServiceProtocol {
  let operation = OperationQueue()
  func fetchLeagues(success: @escaping([LeaguesModel]) -> Void, errorMessage: @escaping(String) -> Void) {
    let url = StringURLRequest.fetchAllLeauges()
    let connection = NetworkRequests(url) {
      data, error in
      if error != nil {
        errorMessage(error ?? "Error")
        return
      }
      if data != nil {
        let decoder = JSONDecoder()
        do {
          let leagues = try decoder.decode([LeaguesModel].self, from: data!)
          success(leagues)
          
        } catch let error as NSError {
          errorMessage(error.localizedDescription)
        }
      }
    }
    operation.addOperation(connection)
  }
}
