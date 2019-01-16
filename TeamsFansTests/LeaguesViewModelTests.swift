//
//  LeaguesViewModelTests.swift
//  TeamsFansTests
//
//  Created by kkolontay on 1/15/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import XCTest
@testable import TeamsFans

class LeaguesViewModelTests: XCTestCase {
  var mockProtocol: LeagueMock?
  var viewModel: LeaguesViewModel?
  var controller: LeaguesView?
  var mockProtocolError: LeagueMockError?
  
  override func setUp() {
    mockProtocol = LeagueMock()
    mockProtocolError = LeagueMockError()
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    controller = storyboard.instantiateViewController(withIdentifier: "LeaguesView") as? LeaguesView
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
    viewModel = LeaguesViewModel(withLeagues: mockProtocolError!)
    viewModel?.fetchLeagues()
    if viewModel?.alertMessage == "someError" {
      XCTAssert(true)
    } else {
      XCTAssert(false)
    }
  }
  
  func testObjectReceivedViewModel() {
    viewModel = LeaguesViewModel(withLeagues: mockProtocol!)
    viewModel?.fetchLeagues()
    if viewModel?.isLoaded ?? false {
      XCTAssert(true)
    } else {
      XCTAssert(false)
    }
  }
  
  func testViewControllerFetchObject() {
    viewModel = LeaguesViewModel(withLeagues: mockProtocol!)
    controller?.viewModel = viewModel
    controller?.viewModel?.updateLoadedStatus = { leagues in
      if leagues.first?.full_name == "Team" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    }
    controller?.viewModel?.fetchLeagues()
  }
  
  func testViewControllerFetchError() {
    viewModel = LeaguesViewModel(withLeagues: mockProtocolError!)
    controller?.viewModel = viewModel
    controller?.viewModel?.showAlertClosure = { error in
      if error == "someError" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    }
    controller?.viewModel?.fetchLeagues()
  }
}


class LeagueMock: LeaguesServiceProtocol {
  
  let mockModel = LeaguesModel(full_name: "Team", slug: "tm")
  
  func fetchLeagues(success: @escaping ([LeaguesModel]) -> Void, errorMessage: @escaping (String) -> Void) {
    success([mockModel])
  }
}

class LeagueMockError: LeaguesServiceProtocol {
  
  let errorMessageString = "someError"
  
  func fetchLeagues(success: @escaping ([LeaguesModel]) -> Void, errorMessage: @escaping (String) -> Void) {
    errorMessage(errorMessageString)
  }
}
