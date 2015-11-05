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
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

// MARK: - View lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

// MARK: - Delegate Methods
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.customImage!.image = meme.memedImage
        cell.cellText!.text  = "\(meme.topText!) ... \(meme.bottomText!)"
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        detailController.selectedMeme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // The delegate method that causes the buttons to appear on swipe
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     
        if editingStyle == .Delete {
            deletePlanetIndexPath = indexPath
            confirmDelete(deletePlanetIndexPath!)
        }
    }

    
// MARK: - TableView delete
    
    // Confirms whether or not users want to delete the selected cell
    func confirmDelete(indexPath:NSIndexPath) {

        let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete Meme?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteMeme)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteMeme)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeleteMeme(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlanetIndexPath {
            tableView.beginUpdates()
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)   // Delete the element that corresponds to a selected cell
            
            // The indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            deletePlanetIndexPath = nil
            
            tableView.endUpdates()
        }
    }

    func cancelDeleteMeme(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
    }
    
// MARK: - IBAction method
    @IBAction func addMeme(sender: AnyObject) {
        
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        navigationController!.presentViewController(editController, animated: true, completion: nil)
    }
    
}


