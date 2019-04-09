//
//  VideoResponse.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 06/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation


class VideoResponse: Codable {
    
    var id: Int?
    var results: [Video]?
    
}
