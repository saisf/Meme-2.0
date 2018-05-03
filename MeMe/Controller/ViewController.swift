//
//  ViewController.swift
//  MeMe
//
//  Created by Sai Leung on 4/18/18.
//  Copyright © 2018 Sai Leung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var originalImage: UIImage?
    var topText: String?
    var bottomText: String?
    var num: Int?
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: Customerized textField delegate
    let customTextFieldDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: NavBar Title
        navBar.topItem?.title = "Meme"
        navBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!]
        
        buttonsEnabling(enabled: false)
        textFieldEnabling(enabled: false)
        
        // MARK: Disable camera button if device does not support camera
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
        
        textFieldSetup(textfield: topTextField, delegate: customTextFieldDelegate, text: "TOP", textAttributes: customTextFieldDelegate.memeTextAttributes)
        textFieldSetup(textfield: bottomTextField, delegate: customTextFieldDelegate, text: "BOTTOM", textAttributes: customTextFieldDelegate.memeTextAttributes)

    }
    
    // MARK: Subscribe keyboard notification before view show
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        if self.num == 1 {
            
        if let originalImage = originalImage {
            imageView.image = originalImage
            textFieldEnabling(enabled: true)
            buttonsEnabling(enabled: true)
        }
        
        if let topText = topText {
            topTextField.text = topText
        }
        
        if let bottomText = bottomText {
            bottomTextField.text = bottomText
        }
        num = 2
        }
    }
    
    // MARK: Unsubscribe keyboard notification before view disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Function to detect when keyboard show
    func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    // MARK: Function to unsubcribe keyboard notification
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Frame up equal to keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // MARK: Frame down equal to keyboard height
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    // MARK: Function to identify keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Save meme function
    func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Generate meme image
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: TextField delegate and textAttributes set up
    func textFieldSetup(textfield: UITextField, delegate: UITextFieldDelegate, text: String, textAttributes: [String:Any]) {
        textfield.borderStyle = .none
        textfield.text = text
        textfield.delegate = delegate
        textfield.defaultTextAttributes = textAttributes
        textfield.textAlignment = .center
    }
    
    func buttonsEnabling(enabled: Bool) {
        shareButton.isEnabled = enabled
    }
    
    func textFieldEnabling(enabled: Bool) {
        topTextField.isEnabled = enabled
        bottomTextField.isEnabled = enabled
    }
    
    // MARK: Image Picker controller source type
    func imagePickerSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        buttonsEnabling(enabled: true)
        textFieldEnabling(enabled: true)
    }

    // MARK: Album button action
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        imagePickerSourceType(sourceType: .photoLibrary)
    }
    
    // MARK: Camera button action
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        imagePickerSourceType(sourceType: .camera)
    }
    
    // MARK: Share button action
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
        activity.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save()

                // MARK: Instantiate saved memes tab bar controller
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemedViewController") as! MemedTabBarController
                self.present(controller, animated: true, completion: nil)

            } else {
                print(String(describing: error))
            }
        }
    }
    
    // MARK: Cancel button action
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

