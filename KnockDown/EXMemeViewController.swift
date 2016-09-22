//
//  EXMemeViewController.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-20.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import Foundation
import UIKit


extension MemeViewController: UITextViewDelegate {
    
    
    
    func textViewEdit(_ theString: String) {
        
        let theTextView = UITextView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height/6))
            
        let labelAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: theFontWeWant, size: 40)!,
            NSStrokeWidthAttributeName : -2.0] as [String : Any]
        theTextView.attributedText = NSAttributedString(string: theString,attributes: labelAttributes)
        theTextView.textAlignment = .center
        theTextView.delegate = self
        theTextView.isEditable = true
        theTextView.backgroundColor = UIColor.clear
        theTextView.isUserInteractionEnabled = true
        itag += 1
        theTextView.tag = itag - 1
            
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(MemeViewController.handlePinch(_:)))
            theTextView.addGestureRecognizer(pinchGesture)
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MemeViewController.userDragged(_:)))
        theTextView.addGestureRecognizer(panGesture)
            
        view.addSubview(theTextView)
        textViews.append(theTextView)
    }
    
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    func userDragged(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y+translation.y)
            view.translatesAutoresizingMaskIntoConstraints = true
            
            view.updateConstraints()
        }
        
        gesture.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //        if text == "\n" {
        //            textView.resignFirstResponder()
        //            return false
        //        }
        
        textView.frame.size = textView.contentSize
        textView.textAlignment = .center
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.center.y > view.center.y {
            textView.center = view.center
        }
        textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        if textView.text == "Please Enter Here" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            print(textView.tag)
            textViews.remove(at: textView.tag)
            textView.removeFromSuperview()
        } else {
            textView.layer.borderWidth = 0
        }
        print(textViews.count)
    }

    func prepareTextField(textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName : -2.0
            ] as [String : Any]
        textField.borderStyle = UITextBorderStyle.none
        textField.backgroundColor = UIColor.clear
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func getImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if source == "library" {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker,animated: true, completion: nil)
            source = ""
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.modalPresentationStyle = .fullScreen
                present(imagePicker,animated: true,completion: nil)
            } else {
                noCamera()
            }
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
//        if bottomField.isEditing {
//            topField.isHidden = true
//            view.frame.origin.y = -(getKeyboardHeight(notification: notification))
//        }
    }
    
    func keyboardWillHide(notification: NSNotification){
//        if bottomField.isEditing {
//            view.frame.origin.y = 0.0
//            topField.isHidden = false
//        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey]
            as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    
    
    
    
    
    
    
    
}
