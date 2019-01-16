//
//  LeagueTeamsTests.swift
//  TeamsFansTests
//
//  Created by kkolontay on 1/15/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import XCTest
@testable import TeamsFans

class LeagueTeamsTests: XCTestCase {

  var mockProtocol: LeaguesTeamsMock?
  var viewModel: LeaguesTeamsViewModel?
  var controller: LeaguesTeamsView?
  var mockProtocolError: LeaguesTeamsMockError?
  
  override func setUp() {
    mockProtocol = LeaguesTeamsMock()
    mockProtocolError = LeaguesTeamsMockError()
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    controller = storyboard.instantiateViewController(withIdentifier: "LeaguesTeamsView") as? LeaguesTeamsView
    controller?.viewModel = viewModel
    _ = controller?.view
  }
  
  override func tearDown() {
    mockProtocol = nil
    mockProtocolError = nil
    viewModel = nil
    controller = nil
  }
  
  func testAlertMessageViewModel() {
    viewModel = LeaguesTeamsViewModel(withLeaguesTeams: mockProtocolError!)
    viewModel?.fetchTeams(slug: "hnl")
    if viewModel?.alertMessage == "someError" {
      XCTAssert(true)
    } else {
      XCTAssert(false)
    }
  }
  
  func testObjectReceivedViewModel() {
    viewModel = LeaguesTeamsViewModel(withLeaguesTeams: mockProtocol!)
    viewModel?.fetchTeams(slug: "hnl")
    if viewModel?.isLoaded ?? false {
      XCTAssert(true)
    } else {
      XCTAssert(false)
    }
  }
  
  func testViewControllerFetchObject() {
    viewModel = LeaguesTeamsViewModel(withLeaguesTeams: mockProtocol!)
    controller?.viewModel = viewModel
    controller?.viewModel?.updateLoadedStatus = { leagues in
      if leagues.first?.full_name == "Team" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    }
    controller?.viewModel?.fetchTeams(slug: "hnl")
  }
  func testViewControllerFetchImage() {
    viewModel = LeaguesTeamsViewModel(withLeaguesTeams: mockProtocol!)
    viewModel?.fetchLogo(url: "anyURL", logo: { (image, url) in
      XCTAssertNotNil(image)
      if url == "url" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    })
   
  }
  
  func testViewControllerFetchError() {
    viewModel = LeaguesTeamsViewModel(withLeaguesTeams: mockProtocolError!)
    controller?.viewModel = viewModel
    controller?.viewModel?.showAlertClosure = { error in
      if error == "someError" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    }
    controller?.viewModel?.fetchTeams(slug: "hnl")
  }
}


class LeaguesTeamsMock: LeaguesTeamsServiceProtocol {
  
  let mockModel = LeaguesTeamsModel(full_name: "Team", name: "team", location: "Toronto", logo: "", colour_1: "", colour_2: "")
  
  func fetchTeams(slug: String, success: @escaping([LeaguesTeamsModel]) -> Void, errorMessage: @escaping(String) -> Void) {
    success([mockModel])
  }
  
  func fetchLogo(url: String, success: @escaping (UIImage, String) -> Void, errorMessage: @escaping(String) ->Void) {
    success(UIImage(), "url")
  }
}

class LeaguesTeamsMockError: LeaguesTeamsServiceProtocol {
  
  let errorMessageString = "someError"
  
  func fetchTeams(slug: String, success: @escaping([LeaguesTeamsModel]) -> Void, errorMessage: @escaping(String) -> Void) {
    errorMessage(errorMessageString)
  }
  
  func fetchLogo(url: String, success: @escaping (UIImage, String) -> Void, errorMessage: @escaping(String) ->Void) {
    errorMessage(errorMessageString)
  }
}

