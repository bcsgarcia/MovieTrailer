//
//  MovieDetailViewModel.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 06/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import Foundation

class MovieDetailViewModel {
    
    // MARK: - Properties
    private var movie: Movie? {
        didSet {
            guard let m = movie else { return }
            self.setupTexts(with: m)
            self.didFinishFetch?()
        }
    }
    
    private var videos: [Video]? {
        didSet {
            guard let vids = videos else { return }
            setupYoutubeKey(with: vids)
        }
    }
    
    let movieDetailService : MovieDetailServiceProtocol
    
    var posterPath: String?
    var title: String?
    var genres: String?
    var releaseDate: String?
    var overview: String?
    
    var youtubeKey: String? {
        didSet {
            didFinishFetchVideoKey?()
        }
    }
    
    var error: MovieRequestError? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    init(movieDetailService: MovieDetailServiceProtocol = MovieDetailService()){
        self.movieDetailService = movieDetailService
    }
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    var didFinishFetchVideoKey: (() -> ())?
    
    
    // MARK: - Network call
    func fetchData(withId id: Int) {
        isLoading = true
        
        if !CheckInternet.Connection() {
            isLoading = false
            error = .noInternetConnection
            return
        }
        
        movieDetailService.fetchMovieDetail(id: id) { (movie, err) in
            if let err = err {
                self.isLoading = false
                self.error = err
                return
            }
            guard let movie = movie else {
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.movie = movie
            
            self.fetchVideoData(withId: id)
        }
    }
    
    private func fetchVideoData(withId id: Int) {
        movieDetailService.fetchVideo(id: id) { (videos, err) in
            if let err = err {
                self.error = err
                return
            }
            guard let videos = videos else {
                return
            }
            self.error = nil
            self.videos = videos
        }
    }
    
    // MARK: - UI Logic
    private func setupTexts(with movie: Movie) {
        
        if let posterPath = movie.posterPath, let title = movie.title, let genres = movie.genres, let releaseDate = movie.releaseDate, let overview = movie.overview {
            self.posterPath = posterPath
            self.title = title
            self.genres = genres.reduce("", { $0 == "" ? $1.name : "\($0 ?? ""), \($1.name ?? "")" })
            self.releaseDate = releaseDate
            self.overview = overview
        }
    }
    
    private func setupYoutubeKey(with videos: [Video]) {
        let video = videos.filter({ $0.site == "YouTube" })
        if video.count >= 1 {
            youtubeKey = video[0].key
        }
    }
    
    
}
