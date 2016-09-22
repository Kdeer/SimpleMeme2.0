//
//  TestIndicatorViewController.swift
//  memetest
//
//  Created by Xiaochao Luo on 2016-09-16.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit

class TestIndicatorViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var theFontWeWant = "HelveticaNeue-CondensedBlack"
    var textViews = [UITextView]()
    var textSize : CGFloat!
    
    
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        //self.textView.delegate = self
        //textView.isHidden = true
        textField.delegate = self
        textViewEdit("We want all")
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(TestIndicatorViewController.handlePinch(_:)))
        textField.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(TestIndicatorViewController.userDragged(_:)))
        textField.addGestureRecognizer(panGesture)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
//        let contentSize = self.textViews.forEach{ $0.sizeThatFits(self.textViews[0].bounds.size)}
//        var frame = self.textViews[0].frame
//        frame.size.height = contentSize.height
//        self.textViews[0].frame = frame
//        
//        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.textViews[0], attribute: .height, relatedBy: .equal, toItem: self.textViews[0], attribute: .width, multiplier: textViews[0].bounds.height/textViews[0].bounds.width, constant: 1)
//        self.textViews[0].addConstraint(aspectRatioTextViewConstraint)
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSize = CGFloat(Int(textField.text!)!)
        textViews.forEach{$0.font = UIFont(name: theFontWeWant, size: textSize)}
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func ShowIndicator(_ sender: AnyObject) {
        
        progressBarDisplayer("Saving", true)
        
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
    
    func textViewEdit(_ theString: String) {
        
        let theTextView = UITextView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height/4))
        
        let labelAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: theFontWeWant, size: 40)!,
            NSStrokeWidthAttributeName : -2.0] as [String : Any]
        theTextView.attributedText = NSAttributedString(string: theString, attributes: labelAttributes)
        theTextView.textAlignment = .center
        theTextView.delegate = self
        theTextView.isEditable = true
        theTextView.backgroundColor = UIColor.yellow
        theTextView.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(TestIndicatorViewController.handlePinch(_:)))
        theTextView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(TestIndicatorViewController.userDragged(_:)))
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
    
    @IBAction func HideKeyboard(_ sender: UITapGestureRecognizer) {
        textViews.forEach{$0.resignFirstResponder()}
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.frame.size = textView.contentSize
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.textAlignment = .center
        return true
    }
    
    
    func progressBarDisplayer(_ msg: String, _ indicator: Bool) {
        
//        print(msg)
//        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
//        strLabel.text = msg
//        strLabel.textColor = UIColor.whiteColor()
//        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
//        messageFrame.layer.cornerRadius = 15
//        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
//        if indicator {
//            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            activityIndicator.startAnimating()
//            messageFrame.addSubview(activityIndicator)
//        }
//        messageFrame.addSubview(strLabel)
//        view.addSubview(messageFrame)
//        messageFrame.alpha = 1.0
//        view.insertSubview(messageFrame, aboveSubview: self.view)
//        UIView.animateWithDuration(3.0, delay: 3.0, options: .CurveEaseOut, animations: {self.messageFrame.alpha = 0.0}, completion: nil)
        
//        textView.editable = false

        
        
    }
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
