//
//  MostPopService.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import Alamofire

protocol MostPopServiceProtocol {
    func fetchMostPopMovies(page: Int, completion: @escaping (MostPopularResponse?, MovieRequestError?) -> ())
}


class MostPopService: MostPopServiceProtocol {
    
    //static let shared = MostPopService()
    func fetchMostPopMovies(page: Int, completion: @escaping (MostPopularResponse?, MovieRequestError?) -> ()) {
        
       
        
        Alamofire.request(UrlRouter.getPopular(page))
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
                    let mostPopular = try JSONDecoder().decode(MostPopularResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(mostPopular, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
        }
    }
}
