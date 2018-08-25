//
//  CatFactViewController.swift
//  Cat Facts
//
//  Created by SwiftSYY on 25/8/18.
//  Copyright © 2018 Yiyang Song. All rights reserved.
//

import UIKit

class CatFactViewController: UIViewController {

    @IBOutlet var CatFactLabel: UILabel!
    @IBOutlet var catImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchOnlineCatFact(completion: @escaping (CatFact?) -> Void) {
        let url = URL(string: "https://cat-fact.herokuapp.com/facts/random")!
        // URLSession is like a public utility everyone can use.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let catFact = try? jsonDecoder.decode(CatFact.self, from: data){ // Creating another unwrapped variable of data and response
                completion(catFact) // Assume Xcode knows data is the unwrapped one.
            } else {
                completion(nil)
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task.resume()
        
        let url2 = URL(string: "https://api.thecatapi.com/v1/images/search?format=src&mime_types=image/gif")!
        let task2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let image = UIImage.gif(data: data) {
                DispatchQueue.main.async {
                    self.catImage.image = image
                }
            }
        }
        task2.resume()
    }

    @IBAction func gimmeCatFact(_ sender: Any) {
        fetchOnlineCatFact { (catFact) in
            DispatchQueue.main.async {
                self.CatFactLabel.text = catFact?.text
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}

