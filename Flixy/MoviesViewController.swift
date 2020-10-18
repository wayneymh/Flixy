//
//  MoviesViewController.swift
//  Flixy
//
//  Created by Minghe Yang on 10/16/20.
//

import UIKit
import AlamofireImage


// 4. add UITableViewDataSource, UITableViewDelegate
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // properties: available for the lifetime of this screen (this swift file is associated with movie view controller specified by the identity inspector of the view
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 7. set the dataSource and delegate of the tableView element to self.
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        // 1. aquire data using API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            // 2. store the data into an array of dictionaries
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            // 8. reload data to ensure the data has been correctly loaded and make the stub functions automatically called
            // if not doing this step, the table view cells will be blank since they are not completely load up at at the beginning
            self.tableView.reloadData() // call the tableView stub functions again
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
    // 5. click fix to add the stub function
    // they are called right when the view controller starts up, which at the time the json data hasn't been loaded
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 6. modify the stub functions to do the correct thing
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        // adding posters to the cell
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
