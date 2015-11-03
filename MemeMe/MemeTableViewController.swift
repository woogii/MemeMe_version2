//
//  MeMeTableViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {

    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell", forIndexPath: indexPath)
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.bottomText + "..." + meme.topText
        cell.imageView!.image = meme.memedImage
        
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

