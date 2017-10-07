//
//  MemeTableViewController.swift
//  MeMe_v2
//
//  Created by Roberto Hernandez on 10/4/17.
//  Copyright © 2017 Roberto Hernandez. All rights reserved.
//

import UIKit

//Mark: - MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class MemeTableViewController: UITableViewController {
    
    @IBOutlet weak var memeTableView: UITableView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Save Meme to Application Delegate
        memeTableView.delegate = self
        memeTableView.reloadData()
        
    }
    
    //Mark: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  memeTableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(meme.topText)" + "" + "\(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.meme = memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
}
