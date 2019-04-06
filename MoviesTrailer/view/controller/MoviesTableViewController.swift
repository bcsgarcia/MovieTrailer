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

    // MARK: - Properties
    var viewModel = MovieListViewModel()
    var indicator = UIActivityIndicatorView()
    
    let cellId = "movieCell"
    let identifier = "segueDetail"
    
    // MARK: - Main Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        attemptFetchData()
    }
    
    // MARK: - Functions
    func attemptFetchData() {
        self.activityIndicatorStart()
        viewModel.fetchData()
        viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print(error)
            }
        }
        
        viewModel.didFinishFetch = {
            //self.movieCellViewModels = self.viewModel.movieCellViewModels
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
    }
    
    private func activityIndicatorStop() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.movieCellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieCell
        let movieCellViewModel = viewModel.movieCellViewModels[indexPath.row]
        cell.movieCellViewModel = movieCellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: identifier, sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movieCellViewModels.count-1 {
            self.attemptFetchData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            let viewDestiny = segue.destination as! MovieDetailViewController
            if let indexPath = sender as? IndexPath {
                viewDestiny.movie = viewModel.movieCellViewModels[indexPath.row].movie
                print("Edit Movie")
            }
        }
    }
    

}
