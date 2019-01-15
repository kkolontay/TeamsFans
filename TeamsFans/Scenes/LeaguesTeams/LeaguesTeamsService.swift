//  
//  LeaguesTeamsService.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit


protocol LeaguesTeamsServiceProtocol {
  func fetchTeams(slug: String, success: @escaping([LeaguesTeamsModel]) -> Void, errorMessage: @escaping(String) -> Void)
  func fetchLogo(url: String, success: @escaping (UIImage, String) -> Void, errorMessage: @escaping(String) ->Void)
}

class LeaguesTeamsService: LeaguesTeamsServiceProtocol {
  let operation = OperationQueue()
  
  func fetchTeams(slug: String, success: @escaping([LeaguesTeamsModel]) -> Void, errorMessage: @escaping(String) -> Void) {
    let url = StringURLRequest.fetchTeamsOfLeague(league: slug)
    let connection = NetworkRequests(url) {
      data, error in
      if error != nil {
        errorMessage(error ?? "Error")
        return
      }
      if data != nil {
        let decoder = JSONDecoder()
        do {
          let leagues = try decoder.decode([LeaguesTeamsModel].self, from: data!)
          success(leagues)
          
        } catch let error as NSError {
          errorMessage(error.localizedDescription)
        }
      }
    }
    operation.addOperation(connection)
  }
  
  func fetchLogo(url: String, success: @escaping (UIImage, String) -> Void, errorMessage: @escaping(String) ->Void) {
    let connection = ImageDownloading(url) {
      image,error, url in
      if error != nil {
        errorMessage(error ?? "Error")
        return
      }
      if image != nil {
        success(image ?? UIImage(), url ?? "")
      }
    }
    operation.addOperation(connection)
  }
}
