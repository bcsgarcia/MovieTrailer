//
//  MostPopularResponseMock.swift
//  MoviesTrailerTests
//
//  Created by Bruno Garcia on 09/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit
@testable import MoviesTrailer


class TestHelper: MostPopularResponse {
    
    static let shared : TestHelper = TestHelper()
    

    func generateMostPopularResponseMock() -> MostPopularResponse {
        do {
            guard let asset = NSDataAsset(name: "most_pop", bundle: Bundle.main) else { return MostPopularResponse() }
            let mostPopular = try JSONDecoder().decode(MostPopularResponse.self, from: asset.data)
            return mostPopular
            
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
            return MostPopularResponse()
        }
    }

    
}

