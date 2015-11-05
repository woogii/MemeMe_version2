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
    
    
// MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true

        // Add 'edit' UIBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit")
        // Pass image from TableView or CollectionView to DetailView
        if let memedImage = selectedMeme.memedImage {
            detailImageView.image = memedImage
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
// MARK: - Action method
    
    func edit() {
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        // Pass memed image info from DetailView to EditorView
        editorController.memedImage = selectedMeme.originalImage
        editorController.bottomText = selectedMeme.topText
        editorController.topText    = selectedMeme.bottomText
        
        presentViewController(editorController, animated: true, completion: {
            // Pops the top view controller, DetailViewController, from the navigation stack.
            self.navigationController!.popViewControllerAnimated(true)

        })
        
    }
    
}
