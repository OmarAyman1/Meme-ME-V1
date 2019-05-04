//
//  ViewController.swift
//  meme Me V1
//
//  Created by OMAR on 4/22/19.
//  Copyright © 2019 OMAR. All rights reserved.
//


import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var down: UIToolbar!
    @IBOutlet weak var up: UIToolbar!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagepicker: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    
    
    let TextDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottom.delegate = TextDelegate
        top.delegate = TextDelegate
        share.isEnabled = (imagepicker.image != nil)
    }
    
    @IBAction func pickimage(_ sender: Any) {
        pick(SourceType: .photoLibrary)
    }
    
    @IBAction func camera(_ sender: Any) {
        pick(SourceType: .camera)
    }
    
    func pick(SourceType: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = SourceType
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedimage = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagepicker.contentMode = .scaleAspectFit
            imagepicker.image = pickedimage
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        share.isEnabled = (imagepicker.image != nil)
        perpareTextField(textfield: top)
        perpareTextField(textfield: bottom)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func perpareTextField(textfield : UITextField){
        textfield.defaultTextAttributes = TextDelegate.memeTextAttributes
        textfield.textAlignment = .center
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification) }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func Cancel(_ sender: Any) {
        imagepicker.image = nil
        share.isEnabled = false
        top.text = "TOP"
        bottom.text = "BOTTOM"
    }
   
    func save() {
        let meme = Meme(topText: top.text!, bottomText: bottom.text!, originalImage: imagepicker.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbar(yes: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideToolbar(yes: false)
        return memedImage
    }
    
    func hideToolbar(yes: Bool){
        up.isHidden = yes
        down.isHidden = yes
    }
    
    @IBAction func Share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                let _ = self.save()
                print("done")
            }
            else {print("error")}
        }
        self.present(activityView, animated: true, completion: nil)
    }
    
}

