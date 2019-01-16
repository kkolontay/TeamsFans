//
//  CachTests.swift
//  TeamsFansTests
//
//  Created by kkolontay on 1/15/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import XCTest
@testable import TeamsFans

class CachTests: XCTestCase {
  
  let cache = CacheImages.shared
  
  
  override func tearDown() {
    cache.imageCache = NSCache()
  }
  
  func testAddItem() {
    cache.imageCache?.setObject(UIImage(), forKey: "key" as AnyObject)
    XCTAssertNotNil(cache.imageCache?.object(forKey: "key" as AnyObject))
  }
  
  func testObject() {
    XCTAssertNotNil(cache)
  }
  
}
