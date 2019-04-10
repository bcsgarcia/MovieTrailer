//
//  MoviesTrailerTests.swift
//  MoviesTrailerTests
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import XCTest
@testable import MoviesTrailer

class MoviesTrailerTests: XCTestCase {

    var mostPopService: MostPopServiceMock?
    var sut: MovieListViewModel?
    
    
    override func setUp() {
        mostPopService = MostPopServiceMock()
        sut = MovieListViewModel(mostPopService: mostPopService!)
    }
 
    func test_generate_most_popular_response_mock(){
        let sutMostPopularResponse = TestHelper.shared.generateMostPopularResponseMock()
        XCTAssertEqual(sutMostPopularResponse.page, 1, "page is not 1 - Expected: 1 / Found: \(sutMostPopularResponse.page!)")
        XCTAssertEqual(sutMostPopularResponse.results.count, 20, "results most be 20 per page - Expected: 20 / Found: \(sutMostPopularResponse.results.count)")
    }
    
    func test_service_when_Api_result_is_ok(){
        
        guard let sut = sut else {
            XCTFail("sut not initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.didFinishFetch = { expectation.fulfill() }
        
        sut.fetchData()
        mostPopService!.fetchSuccess()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(sut.page, 1, "page is not 1 - Expected: 1 / Found: \(sut.page)")
        XCTAssertEqual(sut.movieCellViewModels.count, 20, "results most be 20 per page - Expected: 20 / Found: \(sut.movieCellViewModels.count)")
        
        if sut.movieCellViewModels.count > 0 {
            XCTAssertEqual(sut.movieCellViewModels[0].title , "How to Train Your Dragon: The Hidden World", "Expected: How to Train Your Dragon: The Hidden World / Found \(sut.movieCellViewModels[0].title)")
        } else {
            XCTFail("sut.movieCellViewModels must have object list")
        }
        
    }

    func test_when_service_fail(){
        
        guard let sut = sut else {
            XCTFail("sut not initialized")
            return
        }
        
        let expectation = self.expectation(description: "fetchngData")
        sut.showAlertClosure = { expectation.fulfill() }
        
        sut.fetchData()
        mostPopService!.fetchFail(error: .invalidJSON)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(sut.error, "sut error must have .invalidJSON value")
    }
    
    override func tearDown() {
        mostPopService = nil
        sut = nil
    }

}
