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
        tabBarController?.tabBar.hidden = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit")
        
        if let memedImage = selectedMeme.memedImage {
            detailImageView.image = memedImage
        }
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    func edit() {
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorController.memedImage = selectedMeme.originalImage
        editorController.upperTextField?.text = selectedMeme.topText
        editorController.lowerTextField?.text = selectedMeme.bottomText
        editorController.bottomText = selectedMeme.topText
        editorController.topText    = selectedMeme.bottomText
        presentViewController(editorController, animated: true, completion: {
            self.navigationController!.popViewControllerAnimated(true)

        })
        
    }
    
}
