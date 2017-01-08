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

let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
var url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let request = NSURLRequest(URL: url!)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(dataOrNil, response, error) in
           
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let filteredMovies  = filteredData {
            return filteredMovies.count
        } else {
            return 0
        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        
        if  let posterPath = movie["poster_path"] as? String {
            
            let baseURL = "http://image.tmdb.org/t/p/w500"
            
            let imageURL = NSURL(string: baseURL + posterPath)
            
            cell.posterView.setImageWithURL(imageURL!)
            cell.posterView.alpha = 0
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                cell.posterView.alpha = 1
                }, completion: nil)
            
        } else {
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        return cell
    }
   
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {

        let myRequest = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        });
        
        task.resume()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            if let title = movie["title"] as? String {
                return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.movieSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        movieSearchBar.showsCancelButton = false
        movieSearchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
         
    //override func pirepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}

 
        
    
    
    

}
