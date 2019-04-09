//
//  MoviesTableViewController.swift
//  MoviesTrailer
//
//  Created by Bruno Garcia on 04/04/19.
//  Copyright © 2019 Bruno Garcia. All rights reserved.
//

import UIKit
import Alamofire

class MoviesTableViewController: UITableViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var visibleSearchBar = UISearchBar()
    
    // MARK: - Properties
    var viewModel = MovieListViewModel()
    var currentMoviesCellViewModel = [MovieCellViewModel]()
    var indicator = UIActivityIndicatorView()
    var checkInternetTimer: Timer!
    let checkInternetTimeInterval : TimeInterval = 3
    
    let cellId = "movieCell"
    let identifier = "segueDetail"
    
    // MARK: - Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        activityIndicator()
        attemptFetchData()
        alterLayout()
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    func alterLayout() {
        tableView.tableHeaderView = UIView()
        tableView.estimatedSectionHeaderHeight = 50
    }
    
    func initInternetConnectionCheck(){
        if checkInternetTimer == nil {
            activityIndicatorStart()
            checkInternetTimer = Timer.scheduledTimer(timeInterval: checkInternetTimeInterval, target: self, selector: #selector(checkInernet), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checkInernet(){
        if CheckInternet.Connection() {
            checkInternetTimer.invalidate()
            checkInternetTimer = nil
            activityIndicatorStop()
            attemptFetchData()
        }
    }
    
    // MARK: - Fetch Data Function
    func attemptFetchData() {
        self.activityIndicatorStart()
        
        viewModel.updateLoadingStatus = { let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop() }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                switch error {
                case .noResponse, .noData:
                    self.showAlert("Problem with response, please check your internet connection")
                case .noInternetConnection:
                    self.initInternetConnectionCheck()
                    self.showAlert("No network connection available")
                default:
                    print(error)
                }
            }
        }
        
        viewModel.didFinishFetch = {
            self.currentMoviesCellViewModel = self.viewModel.movieCellViewModels
            self.tableView.reloadData()
        }
        
        viewModel.fetchData()
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    private func activityIndicatorStop() {
        indicator.stopAnimating()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        
        //indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let viewDestiny = segue.destination as! MovieDetailViewController
            if let indexPath = sender as? IndexPath {
                viewDestiny.movie = currentMoviesCellViewModel[indexPath.row].movie
            }
        }
    }
    
}

extension MoviesTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            currentMoviesCellViewModel = viewModel.movieCellViewModels
        }
        else {
            currentMoviesCellViewModel = viewModel.movieCellViewModels.filter({ movie -> Bool in
                return movie.title.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func hideKeyboard(){
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

//TableViewDataSource extension func
extension MoviesTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMoviesCellViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
    
        let movieCellViewModel = currentMoviesCellViewModel[indexPath.row]
        cell.movieCellViewModel = movieCellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideKeyboard()
        performSegue(withIdentifier: identifier, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movieCellViewModels.count-1 {
            self.attemptFetchData()
        }
    }
    
    // This two functions can be used if you want to show the search bar in the section header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }

    // search bar in section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}

