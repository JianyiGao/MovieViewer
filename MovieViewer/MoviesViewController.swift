//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Jianyi Gao 高健一 on 1/5/17.
//  Copyright © 2017 Jianyi Gao 高健一. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var movieSearchBar: UISearchBar!

    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var favoriteMovie = [String:String]()
    var endpoint: String!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        print (url)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let request = URLRequest(url:url!)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task:URLSessionDataTask = session.dataTask(with: request, completionHandler: {(dataOrNil, response, error) in
           
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    self.movies = responseDictionary["results"] as?[NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let filteredMovies  = filteredData {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        
        let title = movie["title"] as! String
        let rating = movie["vote_average"] as! Double
        let releasedDate = movie["release_date"] as! String
        
        if  let posterPath = movie["poster_path"] as? String {
            
            let baseURL = "http://image.tmdb.org/t/p/w500"
            
            let imageURL = URL(string: baseURL + posterPath)
            
            cell.posterView.setImageWith(imageURL!)
            cell.posterView.alpha = 0
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.transitionCurlUp, animations: { () -> Void in
                cell.posterView.alpha = 1
                }, completion: nil)
            
        } else {
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = title
        cell.ratingLabel.text = String(rating)
        cell.releasedDateLabel.text = releasedDate
        
        return cell
    }
    
    
   
    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        let myRequest = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        });
        
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            if let title = movie["title"] as? String {
                return title.range(of: searchText, options: .caseInsensitive) != nil
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.movieSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieSearchBar.showsCancelButton = false
        movieSearchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
         
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![indexPath!.row] as Dictionary
            let indexPathInfo = indexPath!.row
            let detailViewController = segue.destination as! DetailViewController
            
            favoriteMovie["title"]="posterPath"
            
            detailViewController.movie =  movie as NSDictionary!
            detailViewController.indexPathInfo = indexPathInfo
            detailViewController.favoriteMovie = favoriteMovie

        } else {
            let favoriteViewController = segue.destination as! FavoriteViewController
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

 
        
    
    
    

}
