//
//  ViewController.swift
//  MemeMe
//
//  Created by Hyun on 2015. 10. 19..
//  Copyright © 2015년 wook2. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate{
    
    @IBOutlet weak var lowerTextField: UITextField!
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage:UIImage!
    var topText:String!
    var bottomText:String!
  
// MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareEdit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated:Bool){
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func prepareEdit() {
        
        if let memedImage = memedImage {
            imagePickerView.image = memedImage
            lowerTextField.text = topText
            upperTextField.text = bottomText
            shareButton.enabled = true
        }
        else {
            shareButton.enabled = false
        }
        
        prepareTextField(lowerTextField)
        prepareTextField(upperTextField)
        
    }
    
    func prepareTextField(textField:UITextField) {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),              // describe outline color
            NSForegroundColorAttributeName : UIColor.whiteColor(),          // specify the color of the text
            NSBackgroundColorAttributeName: UIColor .clearColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0                              // specify negative values to stroke and fill the text
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }

// MARK: - Image processing methods
    
    func save() {
        //create the meme object
        let meme = Meme( bottomText: lowerTextField.text!,
            topText: upperTextField.text!,
            originalImage:imagePickerView.image!,
            memedImage: self.memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        // hide toolbar and navbar to avoid shown in the rendered image
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

// MARK: - IBAction Methods
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // check whether source is from camera or photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // check whether source is from camera or photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    @IBAction func shareMeme(sender: AnyObject) {
        memedImage = generateMemedImage()          // generate a memed image
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        // completionWithItemsHandler let application know the final result of the operation
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            
            if(success) {       // if activityviewcontroller perform successfully
                self.save()     // save a memed image
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

    }
    
// MARK: - UIImagePickerController delegate method
    
    // tells the delegate that the user picked a still image or movie
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        cancelButton.enabled = false
    }
    
    // tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

// MARK: - Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // share button can be enabled only if there is a modified image
        if imagePickerView.image != nil {
            shareButton.enabled = true
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // clear the text if it is not a default text, "TOP" or "BOTTOM"
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // set preset text if text field is empty
        if lowerTextField.text!.isEmpty  {
            textField.text = "TOP"
        } else if upperTextField.text!.isEmpty {
            textField.text = "BOTTOM"
        }
    
    }

// MARK: - Keyboard control
    
    func subscribeToKeyboardNotifications() {
        // notification posted immediately prior to the display of the keyboard
        NSNotificationCenter .defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        // notification posted immediately prior to the dismissal of the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // remove all observers from self
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        
        if( lowerTextField.isFirstResponder()){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        
        if ( lowerTextField.isFirstResponder()) {
            view.frame.origin.y = 0
        }
    }
    
    // calculate the height of the Keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

// MARK: Control the status bar
    override func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
}

