//
//  MemeEditorViewController.swift
//  MeMe_v2
//
//  Created by Roberto Hernandez on 10/4/17.
//  Copyright © 2017 Roberto Hernandez. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    var newMeme: Meme!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureText(topTextfield, "TOP")
        configureText(bottomTextfield, "BOTTOM")
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        //Enabling and Disabling the Camera and Share Button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        if ((imagePickerView.image) == nil) {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
}
//Mark: - UITextFieldDelegate
extension MemeEditorViewController: UITextFieldDelegate {
    
    func configureText(_ textField: UITextField,_ withText: String) {
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -2.0]
        //Set Text Attributes
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = UIColor.clear
        textField.text = withText
        textField.delegate = self
        //Set Text Alignments
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.textAlignment = NSTextAlignment.center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
//Mark: - UIImagePickerControllerDelegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    //Pick an Image from Album or Camera
    func sourceOfImagePicker (_ sourceChoice: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceChoice
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        //Use method for picking an image from album source
        sourceOfImagePicker(.photoLibrary)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        //Use method for picking an image from camera source
        sourceOfImagePicker(.camera)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        // dismiss the imagePicker
        dismiss(animated: true, completion: nil)
        
    }
    
}
//Mark: UINavigationControllerDelegate
extension MemeEditorViewController: UINavigationControllerDelegate {
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        if bottomTextfield.isFirstResponder {
            
            view.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        if bottomTextfield.isFirstResponder {
            
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
        }
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func hideNavAndTool(_ hide: Bool){
        
        self.topNavBar?.isHidden = hide
        self.bottomToolBar?.isHidden = hide
        
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        //Add the saved Meme to AppDelegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    //Generate the Meme
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        hideNavAndTool(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        hideNavAndTool(false)
        
        return memedImage
    }
    
    
    
    @IBAction func shareMeme (_ sender: AnyObject) {
        
        //generate the memed image
        let memedImage = generateMemedImage()
        //define an instance of the ActivityViewController
        let newActivityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //Save the Meme
        newActivityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        //present ActivityViewController
        self.present(newActivityVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelMeme(_ sender: AnyObject) {
        //Reset UIImageView and UITextField to default Attributes
        configureText(topTextfield, "TOP")
        configureText(bottomTextfield, "BOTTOM")
        imagePickerView.image = nil
        
        //Reset Camera and Share button to disabled
        viewWillAppear(true)
        
        //Go back to Sent Memes Scene
        dismiss(animated: true, completion: nil)
        
    }
}

