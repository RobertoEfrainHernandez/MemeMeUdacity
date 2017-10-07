//
//  MemeCollectionViewController.swift
//  MeMe_v2
//
//  Created by Roberto Hernandez on 10/4/17.
//  Copyright © 2017 Roberto Hernandez. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var meme: Meme!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Save Meme to Application Delegate
        collectionView?.delegate = self
        collectionView?.reloadData()
        
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        // Set the image
        cell.memesImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.meme = memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
}
