//
//  Movie.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 05/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation

class Movie : Codable {
    
    var backdropPath : String? = ""
    var posterPath : String? = ""
    var genres : [Genre]? = []
    var id : Int? = 0
    var releaseDate : String? = ""
    var title : String? = ""
    var overview : String? = ""
    
    
    enum CodingKeys:String,CodingKey
    {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genres = "genres"
        case id = "id"
        case releaseDate = "release_date"
        case title = "title"
        case overview = "overview"
    }
    
}
