//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 11. 1..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
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
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
    }
    
    
// MARK: - Delegate Methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        
        let meme = memes[indexPath.row]
        cell.imageView?.image =  meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
// MARK: - IBAction method
    
    @IBAction func addMeme(sender: AnyObject) {
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        navigationController!.presentViewController(editController, animated: true, completion: nil)
    }
    
}

