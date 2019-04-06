//
//  MovieListViewModel.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 06/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation


class MovieListViewModel {
    
    // MARK: - Properties
    private var mostPopular: MostPopular? {
        didSet {
            guard let mp = mostPopular else { return }
            self.setupProperties(with: mp)
            self.didFinishFetch?()
        }
    }
    
    var page = 0
    var totalPages = 0
    var movieCellViewModels = [MovieCellViewModel]()
    
    var error: MovieRequestError? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?() }
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: - Network call
    func fetchData() {
        isLoading = true
        
        guard let page = plusOnePage() else {
            isLoading = false
            return
        }
        
        MostPopService.shared.fetchMostPopMovies(page: page) { (mostPopular, err) in
            if let err = err {
                self.error = err
                self.isLoading = false
                return
            }
            guard let mostPopular = mostPopular else {
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.mostPopular = mostPopular
        }
    }
    
    // MARK: - UI Logic
    
    private func plusOnePage() -> Int? {
        
        if page == 0 && totalPages == 0 {
            page = 1
            totalPages = 1
            return page
        }
        
        if page > totalPages {
            return nil
        }
        
        page += 1
        return page
    }
    
    private func setupProperties(with mostPopular: MostPopular) {
        self.totalPages = mostPopular.totalPages
        self.movieCellViewModels = self.movieCellViewModels + mostPopular.results.map({return MovieCellViewModel(movie: $0)})
        print(self.movieCellViewModels.count)
    }
    
    
    
}
