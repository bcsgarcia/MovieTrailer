//
//  MovieDetailViewController.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 05/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

class MovieDetailViewController: UIViewController {

    var viewModel = MovieDetailViewModel()
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnTrailer: UIButton!
    
    
    var checkInternetTimer: Timer!
    let checkInternetTimeInterval : TimeInterval = 3
    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFields()
        
        attemptFetchData()
        
        
        
    }
    
    func initInternetConnectionCheck(){
        if checkInternetTimer == nil {
            self.indicator.startAnimating()
            checkInternetTimer = Timer.scheduledTimer(timeInterval: checkInternetTimeInterval, target: self, selector: #selector(checkInernet), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkInernet(){
        if CheckInternet.Connection() {
            checkInternetTimer.invalidate()
            checkInternetTimer = nil
            self.indicator.stopAnimating()
            attemptFetchData()
        }
    }
    
    // MARK: - Functions
    func initializeFields() {
        self.lblTitle.text = movie.title
        self.lblGenres.text = " -- "
        self.lblOverview.text = " -- "
        self.lblDate.text = " -- "
    }
    
    func attemptFetchData() {
        
        guard let id = movie.id else {
            return
        }
        
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ?
                self.indicator.startAnimating() :
                self.indicator.stopAnimating()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                switch error {
                case .noResponse, .noData:
                    self.showAlert("Problem with response, please check your internet connection")
                case .noInternetConnection:
                    self.showAlert("No network connection available")
                    self.initInternetConnectionCheck()
                default:
                    print(error)
                }
            }
        }
        
        viewModel.didFinishFetch = {
            self.lblTitle.text = self.viewModel.title
            self.lblGenres.text = self.viewModel.genres
            self.lblDate.text = self.viewModel.releaseDate
            self.lblOverview.text = self.viewModel.overview
            
            guard let posterPath = self.viewModel.posterPath else {
                return
            }
            
            self.posterImg.loadImageUsingUrlString(urlString: posterPath)
        }
        
        viewModel.didFinishFetchVideoKey = {
            self.btnTrailer.isEnabled = true
            self.btnTrailer.backgroundColor = #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1)
            self.btnTrailer.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal )
        }
        
        viewModel.fetchData(withId: id)
    }
    
    //MARK: - UI Setup
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action) in
            //self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
   @IBAction func playTrailer(_ sender: Any) {
        playVideo(videoIdentifier: viewModel.youtubeKey)
    }
    
    // MARK: - Youtube Vide Player
    func playVideo(videoIdentifier: String?) {
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
                playerViewController?.player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
                
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(self.playerItemDidReachEnd),
                                                                 name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                                 object: playerViewController?.player?.currentItem)
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            topController.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
