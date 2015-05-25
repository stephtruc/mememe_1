//
//  EditViewController.swift
//  ImagePickerTestforMeMe
//
//  Created by Stephanie Truchan on 5/12/15.
//  Copyright (c) 2015 Stephanie Truchan. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
  
    var memedImage: UIImage!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let memeTextAttributes = [
            //font outline
            NSStrokeColorAttributeName : UIColor.blackColor(),
            //font fill
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //set font
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            //set outline width
            NSStrokeWidthAttributeName : -2.0,
        ]
        
        // set text fields default attributes to the memeTextAtttribute definition in the dictionary above  
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Set delegates  - enables actions like dismissing keyboard/resigning as first responder
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
      
        // set text fields to clear on editing
        topTextField.clearsOnBeginEditing = true
        bottomTextField.clearsOnBeginEditing = true
        
        
        // TODO: CURRENTLY ONLY RECOGNIZES TEXT CHANGES, NOT WHETHER IMAGE IS SELECTED - OK?
        // Disable the share button until the user does something
        shareButton.enabled = false
        
    }
    
    
     override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // call function to subscribe to keyboard notifications 
        self.subscribeToKeyboardNotifications()
        
        // enable camera button only if the device has a camera (simulator does not)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //call function to UNsubscribe to keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //  MARK: TEXT/KEYBOARD FUNCTIONS *******************************

    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // TODO: NEED TO SET THIS TO CLEAR OUT INITAL TEXT IF USER DOES NOT CLICK ON FIELD BEFORE SAVING MEME - NOT A STATED REQUIREMENT
        // if the user has begun editing, do not clear out text fields again
        textField.clearsOnBeginEditing = false
        
        //display and enable share button once the user has edited
        shareButton.enabled = true
        
    }

    
    // Code to edit text field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
        // Prevent undo crash
        if range.location + range.length > (textField.text as NSString).length {
            return false
        }
        
        // update the text variable with the new text
        let newText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            // Set characters to be all caps - in case of external keyboard
            textField.text = newText.uppercaseString
        
        return false
        
    }
    
       // Code to dismiss the keyboard when the user hits return
      func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    /* subscribe to notications when keyboard appears/disappears so that view frame can be shifted up and down for bottom text view to remain visible */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /* UNsubscribe to notications when keyboard appears/disappears so that view frame can be shifted up and down for bottom text view to remain visible */
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // shift the view frame up
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // shift the view frame down
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        
    }
    
    // get the keyboard size to know how much to shift the view frame
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        if bottomTextField.editing{
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
        
    }

    
 
    // MARK: IMAGE FUNCTIONS ****************************************
    
    // select image from camera roll
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
 
    // take a new image with the camera
    @IBAction func cameraButton(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    func imagePickerController(imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        // Give view controller access to the image chosen
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image}
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    // Generate a memed image
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar so they won't be part of the Meme
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar after Meme has been created
         navBar.hidden = false
         toolBar.hidden = false
        
        return memedImage
    }
  
  
   // Save the meme
    
    func save() {
        //Create the meme
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
       (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    
    // Share the meme

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // Create a meme and pass it to activity view controller
        self.memedImage = generateMemedImage()
        let activityVC =  UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        
        // Save the meme if the user completes action
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        // present the activity view controller
        self.presentViewController(activityVC, animated: true, completion: nil)
    
    }
    
    
    @IBAction func cancelMemeCreate(sender: UIBarButtonItem) {
        // Dismiss the view Controller
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
