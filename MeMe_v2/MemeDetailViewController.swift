//
//  MemeDetailViewController.swift
//  MeMe_v2
//
//  Created by Roberto Hernandez on 10/4/17.
//  Copyright © 2017 Roberto Hernandez. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        memeImageView!.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
}
