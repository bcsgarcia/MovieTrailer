//
//  MovieDetailService.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import Alamofire

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(id: Int, completion: @escaping (Movie?, MovieRequestError?) -> ())
    func fetchVideo(id: Int, completion: @escaping ([Video]?, MovieRequestError?) -> ())
}


class MovieDetailService: MovieDetailServiceProtocol {
    
    func fetchMovieDetail(id: Int, completion: @escaping (Movie?, MovieRequestError?) -> ()) {
        Alamofire.request(UrlRouter.getDetail(id))
            .responseJSON { (response) in
                if response.result.value == nil {
                    completion(nil, .noResponse)
                    return
                }
                guard let data = response.data else {
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    DispatchQueue.main.async {
                        completion(movie, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
        }
    }
    
    func fetchVideo(id: Int, completion: @escaping ([Video]?, MovieRequestError?) -> ()) {
        Alamofire.request(UrlRouter.getVideos(id))
            .responseJSON { (response) in
                
                if response.result.value == nil {
                    completion(nil, .noResponse)
                    return
                }
                guard let data = response.data else {
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let videoResponse = try JSONDecoder().decode(VideoResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(videoResponse.results, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
        }
    }
    
    
}
