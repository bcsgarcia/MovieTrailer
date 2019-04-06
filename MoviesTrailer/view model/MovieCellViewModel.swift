//
//  MovieViewModel.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 05/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import UIKit

struct MovieCellViewModel {
    
    let movie : Movie
    let title : String
    let posterPath : String
    
    init(movie: Movie) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.movie = movie
    }
    
}
