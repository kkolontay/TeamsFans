//
//  LoaderTests.swift
//  TeamsFansTests
//
//  Created by kkolontay on 1/15/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import XCTest
@testable import TeamsFans

class LoaderTests: XCTestCase {
  var opertion: OperationQueue?
  
  override func setUp() {
    opertion = OperationQueue()
  }
  
  func testImageLoader() {
    let url = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
    let connection = NetworkRequests(url) {
      image, error in
      XCTAssertNil(error)
      XCTAssertNotNil(image)
    }
    opertion?.addOperation(connection)
    
  }
  
  func testLeaguesLoader() {
    let url = StringURLRequest.fetchAllLeauges()
    let connection = NetworkRequests(url) {
      data, error in
      XCTAssertNil(error)
      XCTAssertNotNil(data)
      if data != nil {
        let decoder = JSONDecoder()
        do {
          let object = try decoder.decode([LeaguesModel].self, from: data!)
          XCTAssertNotNil(object)
        } catch {
          XCTAssert(false)
        }
      }
    }
    opertion?.addOperation(connection)
    
  }
  
  func testLeagueTeamsLoader() {
    let url = StringURLRequest.fetchTeamsOfLeague(league: "nhl")
    let connection = NetworkRequests(url) {
      data, error in
      XCTAssertNil(error)
      XCTAssertNotNil(data)
      if data != nil {
        let decoder = JSONDecoder()
        do {
          let object = try decoder.decode([LeaguesTeamsModel].self, from: data!)
          XCTAssertNotNil(object)
        } catch {
          XCTAssert(false)
        }
      }
    }
    opertion?.addOperation(connection)
    
  }
  
}
