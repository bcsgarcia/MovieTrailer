//
//  MostPopular.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 05/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation

class MostPopular : Codable {
    
    var page : Int = 0
    var totalResults : Int = 0
    var totalPages : Int = 0
    var results : [Movie] = []
    
    enum CodingKeys:String,CodingKey
    {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
}
