//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Jianyi Gao 高健一 on 1/9/17.
//  Copyright © 2017 Jianyi Gao 高健一. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if  let posterPath = movie["poster_path"] as? String {
            
            let baseURL = "http://image.tmdb.org/t/p/w500"
            
            let imageURL = NSURL(string: baseURL + posterPath)
            
            posterImageView.setImageWithURL(imageURL!)
            posterImageView.alpha = 0
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                self.posterImageView.alpha = 1
                }, completion: nil)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
