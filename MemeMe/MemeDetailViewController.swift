//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 3..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    var selectedMeme: Meme!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let memedImage = selectedMeme.memedImage {
            detailImageView.image = memedImage
        }
    }
    

    
}
