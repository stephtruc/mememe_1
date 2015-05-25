//
//  MemeTableViewController.swift
//  
//
//  Created by Stephanie Truchan on 5/21/15.
//
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource {

   
    var memes: [Meme]!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
    }
    
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(memes.count)
        return memes.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellForRowAtIndexPath")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath) as! UITableViewCell
        let memeElement = memes[indexPath.row]
        
        // Set the image
        cell.imageView?.image = memeElement.memedImage as? UIImage
        //cell.imageView?.image = UIImage(named: memeElement.memedImage)
        
        
        return cell
    }

}
