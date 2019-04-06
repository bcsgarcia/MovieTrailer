//
//  MostPopService.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation
import Alamofire

class MostPopService {
    
    static let shared = MostPopService()
    
    func fetchMostPopMovies(page: Int, completion: @escaping (MostPopular?, MovieRequestError?) -> ()) {
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
                    let mostPopular = try JSONDecoder().decode(MostPopular.self, from: data)
                    DispatchQueue.main.async {
                        completion(mostPopular, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
        }
    }
}
