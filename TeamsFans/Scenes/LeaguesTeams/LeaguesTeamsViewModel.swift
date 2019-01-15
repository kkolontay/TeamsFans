//  
//  LeaguesTeamsViewModel.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class LeaguesTeamsViewModel {

  private let service: LeaguesTeamsServiceProtocol
  private var model: [LeaguesTeamsModel] = [LeaguesTeamsModel]()

  // update loading status
  var isLoaded: Bool = false {
      didSet {
          self.updateLoadedStatus?(model)
      }
  }

  // show alert message
  var alertMessage: String? {
      didSet {
          self.showAlertClosure?(alertMessage ?? "")
      }
  }

  // closure callback
  var showAlertClosure: ((String) -> ())?
  var updateLoadedStatus: (([LeaguesTeamsModel]) -> ())?

  init(withLeaguesTeams serviceProtocol: LeaguesTeamsServiceProtocol = LeaguesTeamsService() ) {
    self.service = serviceProtocol
  }
  
  func fetchTeams( slug: String) {
    service.fetchTeams(slug: slug, success: { [weak self](teams) in
      self?.model = teams
      self?.isLoaded = true
    }) { [weak self](error) in
      self?.model = []
      self?.isLoaded = false
      self?.alertMessage = error
    }
  }
  
  func fetchLogo(url: String, logo: @escaping( UIImage, String) -> Void) {
    service.fetchLogo(url: url, success: { (image, url) in
      logo(image, url)
    }) { (error) in
      print(error)
    }
  }

}


