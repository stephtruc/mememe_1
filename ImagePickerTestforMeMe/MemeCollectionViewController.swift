//
//  MemeCollectionViewController.swift
//  ImagePickerTestforMeMe
//
//  Created by Stephanie Truchan on 5/24/15.
//  Copyright (c) 2015 Stephanie Truchan. All rights reserved.
//

import UIKit



class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {

    
    // Set up variable to store Shared Data
    var memes: [Meme]!
    
    // Get data from AppDelegate
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // reload data to force image load into table and delegate calls
       collectionView?.reloadData()
        
    }
    
   

    // MARK: UICollectionViewDataSource

        
    // Determine number of Meme items
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
 
    
    // Define cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        // set the image
        cell.collectionViewMemedImage.image = meme.memedImage
        
        return cell
    }
    
    
    // Segue to Detail View when item is selected - CODE ONLY
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // Add a new Meme from the Collection View
    @IBAction func addNewMeme2(sender: UIBarButtonItem) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("EditViewController") as! EditViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    
    
}
