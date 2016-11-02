//
//  QuizletTests.swift
//  FlashcardHeroTests
//
//  Created by Jacob Foster Davis on 10/24/16.
//  Copyright © 2016 Zero Mu, LLC. All rights reserved.
//

import XCTest
@testable import FlashcardHero

class FlashcardHeroTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuizletTests() {
        testQuizletSearchTestNoCriteria()
        testQuizletSearchTestSimple()
        
    }
    
    func testQuizletSearchTestNoCriteria() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("Starting Test")
        
        //using nothing.  This should fail
        let testExpectation = expectation(description: "async request")
        QuizletClient.sharedInstance.getQuizletSearchSetsBy() { (results, error) in
            
            print("Reached CompletionHandler of getQuizletSearchSetsBy noCriteriaExpectation")
            print("results: \(results)")
            print("error: \(error)")
            
            if error != nil {
                testExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testQuizletSearchTestSimple() {
        //using a search term
        let testExpectation = expectation(description: "async request")
        QuizletClient.sharedInstance.getQuizletSearchSetsBy("birds") { (results, error) in
            
            print("Reached CompletionHandler of getQuizletSearchSetsBy")
            print("results: \(results)")
            print("error: \(error)")
            
            if error == nil {
                testExpectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testQuizletGetSet() {
        //using a search term
        let testExpectation = expectation(description: "async request")
        QuizletClient.sharedInstance.getQuizletSetBy(6009523, termsOnly: true) { (results, error) in
            
            print("Reached CompletionHandler of getQuizletSearchSetsBy")
            print("results: \(results)")
            print("error: \(error)")
            
            if error == nil {
                testExpectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
