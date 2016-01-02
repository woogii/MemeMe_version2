//
//  MeMeTableViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let cellIdentifier = "memeTableCell"
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    //var memes: [Meme] {
    //    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    //}
    
// MARK : - Convenience Method
    lazy var sharedContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultController: NSFetchedResultsController = {
       
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        
        // Add a sort descriptor
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"topText", ascending: false)]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }()

// MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        
        // Set this view controller as the fetched results controller's delegate
        fetchedResultController.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK : - NSFetchedResultsController Delegate 
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // This invocation prepares the table to receive a number of changes. It will 
        // store them up until it receives endUpdates(), and then perform tell all at once.
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }

    // When endUpdates() is invoked, the table makes the changes visible.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

// MARK: - Delegate Methods
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultController.sections![section]
        // return memes.count
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme = self.fetchedResultController.objectAtIndexPath(indexPath) as! Meme
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        
        //let meme = memes[indexPath.row]
        let memedImage = UIImage(data: meme.memedImage)
        // cell.customImage!.image = meme.memedImage
        
        cell.customImage!.image = memedImage
        cell.cellText!.text  = "\(meme.topText) ... \(meme.bottomText)"
       
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController

        let meme = self.fetchedResultController.objectAtIndexPath(indexPath) as! Meme 
        
        // detailController.selectedMeme = memes[indexPath.row]
        detailController.selectedMeme = meme
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
            
            let meme = self.fetchedResultController.objectAtIndexPath(indexPath) as! Meme
            sharedContext.deleteObject(meme)
            CoreDataStackManager.sharedInstance().saveContext()
            
//            tableView.beginUpdates()
//            
//            let object = UIApplication.sharedApplication().delegate
//            let appDelegate = object as! AppDelegate
//            appDelegate.memes.removeAtIndex(indexPath.row)   // Delete the element that corresponds to a selected cell
//            
//            // The indexPath is wrapped in an array:  [indexPath]
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            deletePlanetIndexPath = nil
//            
//            tableView.endUpdates()
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


