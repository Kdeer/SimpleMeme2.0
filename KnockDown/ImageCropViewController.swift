//
//  ImageCropViewController.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-22.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit

protocol CroppedImage {
    func croppingFinished(_ controller: ImageCropViewController, img: UIImage)
}

class ImageCropViewController: UIViewController {

    var _image: UIImage!
    
    @IBOutlet weak var showHideBtn: UIButton!
    
    @IBOutlet weak var cropView: AKImageCropperView!
    
    var delegatesss: CroppedImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        _image = UIImage(named: "AAGirl")
        
        cropView.image = _image
        cropView.delegate = self
        
        showHideBtn.setTitle("ShowCropFrame", for: UIControlState())
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cropView.refresh()
    }
    
    @IBAction func showHideFrameBtn(_ sender: UIButton) {
        
        if cropView.overlayViewIsActive {
            showHideBtn.setTitle("ShowCropFrame", for: UIControlState())
            
            cropView.dismissOverlayViewAnimated(true) { () -> Void in
                
                print("Frame disabled")
            }
        }else {
            showHideBtn.setTitle("Hide Crop Frame", for: UIControlState())
            
            cropView.showOverlayViewAnimated(true, withCropFrame: nil, completion: { () -> Void in
                print("Frame active")
            })
        }
    }
    
    @IBAction func cropCancelled(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishedCropBtn(_ sender: AnyObject) {
        self.delegatesss?.croppingFinished(ImageCropViewController(), img: cropView.croppedImage())
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ImageCropViewController: AKImageCropperViewDelegate {
    
    func cropRectChanged(_ rect: CGRect) {
        
        //        print("New crop rectangle: \(rect)")
    }
}
