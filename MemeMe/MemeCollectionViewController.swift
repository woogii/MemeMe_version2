//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties 
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    // Keep the changes. We will keep track of insertions, deletions, and updates
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    
    // var sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        
        // Fetch request contain at least one sort descriptor to order the results 
        fetchRequest.sortDescriptors = []
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil , cacheName: nil )
        
        return fetchedResultController
    }()
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        flowLayout.itemSize = CGSize(width: screenWidth/3-2, height: screenWidth/3)
        flowLayout.minimumInteritemSpacing = 1.0 // the minimum spacing to use between items in the same row
        flowLayout.minimumLineSpacing = 1.0 //minimum spacing to use between lines of items in the grid.
        
        fetchedResultController.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        do {
            try self.fetchedResultController.performFetch()
        } catch {
            print(error)
        }
        
        collectionView?.reloadData()
    }
    

    // MARK: - Delegate Methods
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // return self.fetchedResultController.sections?.count ?? 0
        return 1 
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultController.sections![section]
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        // return memes.count
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = self.fetchedResultController.objectAtIndexPath(indexPath) as! Meme
        
        // let meme = memes[indexPath.row]
        let image = UIImage(data:meme.memedImage)
        cell.imageView?.image = image
        
        // cell.imageView?.image =  meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let meme = self.fetchedResultController.objectAtIndexPath(indexPath) as! Meme
        
        // detailController.selectedMeme = memes[indexPath.row]
        detailController.selectedMeme = meme
        navigationController!.pushViewController(detailController, animated: true)
        
        
    }
    
    // MARK : - Fetched Results Controller Delegate 
    
    // Whenever changes are made to Core Data the following three methods are invoked. This first method is used to create
    // a fresh array to record the index paths that will be changed.
//    func controllerWillChangeContent(controller: NSFetchedResultsController) {
//        insertedIndexPaths = [NSIndexPath]()
//        deletedIndexPaths = [NSIndexPath]()
//        
//        print("in controllerWillChangeContent")
//    }
//    
//    // This method may be called multiple times, once for each meme object is added. 
//    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
//        
//        print(newIndexPath?.row)
//        
//        switch type {
//            
//        case .Insert:
//            insertedIndexPaths.append(newIndexPath!)
//            print("Insert an item")
//            break
//        case .Delete:
//            deletedIndexPaths.append(newIndexPath!)
//            print("delete an item")
//            break
//        default:
//            break
//        }
//    }
//    
//    // This method is invoked after all of the changed in the current batch have been collected into the index path array(insert).
//    // We need to loop through the array and perform changes. 
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        
//        print("in controllerDidChangeContent. changes.count : \(insertedIndexPaths.count)")
//        
//        collectionView?.performBatchUpdates({() -> Void in
//            
//            for indexPath in self.insertedIndexPaths{
//                self.collectionView?.insertItemsAtIndexPaths([indexPath])
//            }
//            
//            for indexPath in self.deletedIndexPaths{
//                self.collectionView?.deleteItemsAtIndexPaths([indexPath])
//            }
//        }, completion: nil)
//    }
    
    // MARK: - IBAction method
    
    @IBAction func addMeme(sender: AnyObject) {
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        navigationController!.presentViewController(editController, animated: true, completion: nil)
    }
    
}

