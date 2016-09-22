//
//  ImageViewController.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-21.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var memes: Meme!
    var photoIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        memeImageView.image = memes.memedImage1
        memeImageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateMinZoomScaleForSize(view.bounds.size)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
        
    }
    
//    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
        //        fit the imageView in scroll view.
    }
    
    @IBAction func dismissViewTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LongPressAction(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 0.8
        
        // set up activity view controller
        let objectsToShare: [AnyObject] = [ memeImageView.image! ]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    

    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        
        let widthScale = size.width / memeImageView.bounds.width
        let heightScale = size.height / memeImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = minScale*2
        scrollView.zoomScale = minScale
        print("We are zoomming")
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - memeImageView.frame.height) / 2)
        let xOffset = max(0, (size.width - memeImageView.frame.width) / 2)
        
        imageViewTopConstraint.constant = yOffset - 20
        imageViewBottomConstraint.constant = yOffset
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }

}


extension ImageViewController: UIScrollViewDelegate {
    
    //  Mark: This is the heart and soul of the scroll view’s zooming mechanism. You’re telling it which view should be made bigger and smaller when the scroll view is pinched. So, you tell it that it’s your imageView.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return memeImageView
    }
    
    
    
    //wake the function to put the image view in the center of scroll view
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    
}
