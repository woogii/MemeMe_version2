//
//  MeMeTableViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {

    let cellIdentifier = "memeTableCell"
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        if( memes.count == 0) {
            let     editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            navigationController!.presentViewController(editController, animated: true, completion: nil)
        }
        else {
                    super.viewDidLoad()
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        
        cell.customImage!.image = meme.memedImage
        cell.cellText!.text  = "\(meme.topText!) ... \(meme.bottomText!)"
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        detailController.selectedMeme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        navigationController!.presentViewController(editController, animated: true, completion: nil)
    }
    
}

