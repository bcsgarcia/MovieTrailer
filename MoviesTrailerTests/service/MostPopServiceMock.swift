//
//  MostPopServiceMock.swift
//  MoviesTrailerTests
//
//  Created by Bruno Garcia on 09/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit
@testable import MoviesTrailer

class MostPopServiceMock: MostPopServiceProtocol {
    
    var completeClosure: ((MostPopularResponse?, MovieRequestError?) -> ())!
    
    func fetchMostPopMovies(page: Int, completion: @escaping (MostPopularResponse?, MovieRequestError?) -> ()) {
        //completion(TestHelper.shared.generateMostPopularResponseMock(), nil)
        completeClosure = completion
        
    }
    
    func fetchSuccess() {
        completeClosure(TestHelper.shared.generateMostPopularResponseMock(), nil)
    }
    
    func fetchFail(error: MovieRequestError?) {
        completeClosure( nil, error )
    }
    
    
    
}
