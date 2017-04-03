//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Namrata Mehta on 3/30/17.
//  Copyright © 2017 Namrata Mehta. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchViewButtonItem: UIBarButtonItem!
    @IBOutlet weak var nwErrorView: UIView!
    @IBOutlet weak var nwErrorImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]!
    var refreshControl: UIRefreshControl!
    var endpoint: String! = "now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the collectionView on load
        collectionView.isHidden = true
        switchViewButtonItem.image = UIImage(named: "grid")
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Loading the data from the API
        loadDataFromNetwork()
        
        self.tableView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)
        self.collectionView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)
        
        self.navigationItem.title = "Movies"
        if let navigationBar = navigationController?.navigationBar {
            //navigationBar.setBackgroundImage(UIImage(named: "top_rated"), for: .default)
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 2, height: 2);
            shadow.shadowBlurRadius = 1;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            
            return filteredMovies.count;
        }
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row];
        //let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        // If the poster_path returns nil then this block of code for setting image will be skipped
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl as! URL)
        }
        
        print("row \(indexPath.row)")
        return cell
    }
    
    
    func loadDataFromNetwork() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = NSURLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10);
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Loading movies"
        
        let task : URLSessionDataTask = session.dataTask(with: url!,
                                                         completionHandler: {
                                                            (dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try!
                                                                    JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                    NSLog("response: \(responseDictionary)")
                                                                    
                                                                    //MBProgressHUD.hide(for: self.view, animated: true)
                                                                    spinningActivity.hide(animated: true)
                                                                    
                                                                    if ((responseDictionary["results"] as? [NSDictionary]) != nil) {
                                                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                        
                                                                        self.filteredMovies = self.movies;
                                                                        
                                                                    } else {
                                                                        print("responseDictionary is nil.")
                                                                    }
                                                                    
                                                                    //self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                    self.nwErrorView.isHidden = true
                                                                    self.tableView.reloadData()
                                                                    self.collectionView.reloadData()
                                                                    
                                                                    self.tableView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)
                                                                    self.collectionView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)
                                                                    
                                                                }
                                                            } else {
                                                                //MBProgressHUD.hide(for: self.view, animated: true)
                                                                spinningActivity.hide(animated: true)
                                                                self.nwErrorView.isHidden = false
                                                                //self.nwErrorView.backgroundColor = UIColor.gray
                                                                
                                                                self.tableView.backgroundColor = UIColor(hue: 42/360, saturation: 29/100, brightness: 90/100, alpha: 1.0)
                                                                self.collectionView.backgroundColor = UIColor(hue: 42/360, saturation: 29/100, brightness: 90/100, alpha: 1.0)
                                                                
                                                                let image = UIImage(named: "network_error")
                                                                
                                                                if let e = error {
                                                                    NSLog("Error: \(e)")
                                                                }
                                                            }
        });
        
        task.resume();
    }

    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        print("refresh is called")
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = NSURLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10);
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Loading movies"
        
        let task : URLSessionDataTask = session.dataTask(with: url!,
                                                         completionHandler: {
                                                            (dataOrNil, response, error) in
                                                            if let data = dataOrNil {
                                                                if let responseDictionary = try!
                                                                    JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                    NSLog("response: \(responseDictionary)")
                                                                    
                                                                    //MBProgressHUD.hide(for: self.view, animated: true)
                                                                    spinningActivity.hide(animated: true)
                                                                    
                                                                    if ((responseDictionary["results"] as? [NSDictionary]) != nil) {
                                                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                        
                                                                        self.filteredMovies = self.movies;
                                                                        
                                                                    } else {
                                                                        print("responseDictionary is nil.")
                                                                    }
                                                                    
                                                                    //self.movies = responseDictionary["results"] as! [NSDictionary]
                                                                    self.nwErrorView.isHidden = true
                                                                    self.tableView.reloadData()
                                                                    self.collectionView.reloadData()
                                                                    
                                                                    self.tableView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)
                                                                    self.collectionView.backgroundColor = UIColor(hue: 40/360, saturation: 82/100, brightness: 94/100, alpha: 1.0)

                                                                    
                                                                }
                                                            } else {
                                                                //MBProgressHUD.hide(for: self.view, animated: true)
                                                                spinningActivity.hide(animated: true)
                                                                self.nwErrorView.isHidden = false
                                                                //self.nwErrorView.backgroundColor = UIColor.gray
                                                                
                                                                self.tableView.backgroundColor = UIColor(hue: 42/360, saturation: 29/100, brightness: 90/100, alpha: 1.0)
                                                                self.collectionView.backgroundColor = UIColor(hue: 42/360, saturation: 29/100, brightness: 90/100, alpha: 1.0)
                                                                
                                                                let image = UIImage(named: "network_error")
                                                                
                                                                if let e = error {
                                                                    NSLog("Error: \(e)")
                                                                }
                                                            }
                                                            
                                                            // Endging the spinning
                                                            refreshControl.endRefreshing()
        });
        
        task.resume();
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) -> Bool {
        
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movieDictionary: NSDictionary) -> Bool in
            
            return (movieDictionary["title"] as! String).lowercased().range(of: searchText.lowercased()) != nil
        })
        print (filteredMovies)
        
        self.tableView.reloadData()
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    @IBAction func onTap(_ sender: Any) {
        print("on tap function")
        view.endEditing(true)
        self.searchBar.endEditing(true)
    }
    
    
    
    @IBAction func switchView(_ sender: Any) {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
        
        if (tableView.isHidden) {
            //print("tableview is hidden")
            switchViewButtonItem.image = UIImage(named: "list_view")
        }
        else {
            //print("grid is hidden")
            switchViewButtonItem.image = UIImage(named: "grid")
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            print("onside collectionview count return method ",movies.count)
            return movies.count
        } else {
            print("onside collectionview count return method count is 0")
            return 0
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        print("onside collectionview main method")
        
        //let movie = filteredMovies[indexPath.row];
        let movie = movies![indexPath.row]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        // If the poster_path returns nil then this block of code for setting image will be skipped
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImage.setImageWith(imageUrl as! URL)
        }
        
        print("row collection \(indexPath.row)")
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let movie: NSDictionary
        
        if (tableView.isHidden) {
            // We are currently on Grid view
            print("We are currently on Grid view")
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            movie = movies![indexPath!.row]
        } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            //let movie = movies![indexPath!.row]
            movie = filteredMovies![indexPath!.row]
        }
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        self.searchBar.endEditing(true)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 180, height: 150);
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let cellWidthPadding = collectionView.frame.size.width / 30
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding,
                            bottom: cellHeightPadding,right: cellWidthPadding)
    }

}
