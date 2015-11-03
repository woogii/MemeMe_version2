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
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension1 = (self.view.frame.size.width - (2*space))/3.0

        let dimension2 = (self.view.frame.size.height - (100*space))/3.0

        flowLayout.minimumInteritemSpacing = space  // the minimum spacing to use between items in the same row
        flowLayout.minimumLineSpacing = space      //minimum spacing to use between lines of items in the grid.
        flowLayout.itemSize = CGSizeMake(dimension1
            , dimension2)        // the default size to use for cells
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
    }
    
    
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
        
        //let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        //detailController.villain = self.allVillains[indexPath.row]
        //self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    
    @IBAction func addMeme(sender: AnyObject) {
    }
    
}

