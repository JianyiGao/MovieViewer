//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Jianyi Gao 高健一 on 1/9/17.
//  Copyright © 2017 Jianyi Gao 高健一. All rights reserved.
//

import UIKit

/*
func += <KeyType, ValueType> (inout left: Dictionary <KeyType, ValueType>, right:  Dictionary <KeyType,ValueType>) {
    for (k, v) in right {
        left[k] = v
    }
}
 

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
*/


class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    var movie: NSDictionary!
    var indexPathInfo: Int!
    var favoriteMovie: Dictionary<String,String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if  let posterPath = movie["poster_path"] as? String {
            
            let smallImageBaseUrl = "http://image.tmdb.org/t/p/w45"
            let largeImageBaseUrl = "http://image.tmdb.org/t/p/original"
            
            let smallImageUrl = smallImageBaseUrl + posterPath
            let largeImageUrl = largeImageBaseUrl + posterPath
            
            let smallImageRequest = URLRequest(url: URL(string: smallImageUrl)!)
            let largeImageRequest = URLRequest(url: URL(string: largeImageUrl)!)
            
            posterImageView.setImageWith(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            self.posterImageView.setImageWith(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    self.posterImageView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
            
            /*
            let baseURL = "http://image.tmdb.org/t/p/w500"
            
            let imageURL = NSURL(string: baseURL + posterPath)
            
            posterImageView.setImageWithURL(imageURL!)
            posterImageView.alpha = 0
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                self.posterImageView.alpha = 1
                }, completion: nil)
            */
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

@IBAction func addToFavorite(_ sender: UIButton) {
        let title = movie["title"] as! String
        let posterPath = movie["poster_path"] as! String
    
        favoriteMovie[title] = posterPath
        print(favoriteMovie)
    
    
    
//    for(key,value) in favoriteMovie{
//        print("Key:\(key) Value:\(value)")
//    }
        /*
        var moviesDictionary = [String:AnyObject]()
        for (key, value) in movie {
            moviesDictionary[key as! String] = value
        }
        */
    
        /*

        var temp = Dictionary<String, Any>()
        temp["result"] = movie
    
        let dict = ["1" : "2"]
    
        if favoriteMovies == nil{
            favoriteMovies = NSMutableDictionary(dictionary: temp, copyItems: true)

            //global.favoriteMovies = NSMutableDictionary(dictionary: movie)
        } else {
            favoriteMovies!.addEntriesFromDictionary(temp)
            print ("******************")
            print (global.favoriteMovies)
            favoriteMovies!.addEntriesFromDictionary(dict)
            print ("-------------------")
            print (global.favoriteMovies)
        
        }
        */
        
        //global.favoriteMovies += moviesDictionary
 

    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}









