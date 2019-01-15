//  
//  LeaguesViewModel.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

class LeaguesViewModel {

  private let service: LeaguesServiceProtocol
  private var model: [LeaguesModel] = [LeaguesModel]()

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
  var updateLoadedStatus: (([LeaguesModel]) -> ())?

  init(withLeagues serviceProtocol: LeaguesServiceProtocol = LeaguesService() ) {
    self.service = serviceProtocol
  }
  func fetchLeagues() {
    service.fetchLeagues(success: { [weak self](leagues) in
      self?.model = leagues.sorted(by: { (itemA, itemB) -> Bool in
        return itemA.full_name ?? "" < itemB.full_name ?? ""
      })
      self?.isLoaded = true
    }) { [weak self](error) in
      self?.model = []
      self?.isLoaded = false
      self?.alertMessage = error
    }
  }
}
