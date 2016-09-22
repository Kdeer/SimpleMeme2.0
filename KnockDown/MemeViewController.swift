//
//  ViewController.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-20.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit
import CoreData
import Photos

var globalNumber = 1

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CroppedImage {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var source = String()
    var textViews = [UITextView]()
    var theFontWeWant = "HelveticaNeue-CondensedBlack"
    var itag = 0
    var updatedY = CGFloat()
    //TableView Properties
    var FontStyle = ["Size", "Style"]
    var fonts = UIFont.familyNames
    var tableString = "Font"
    var fontSize = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        tableView.isHidden = true
        tapGesture.cancelsTouchesInView = false
//        prepareTextField(textField: topField, defaultText: "TOP")
//        prepareTextField(textField: bottomField, defaultText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(fonts)
        updatedY = view.frame.origin.y - self.imageView.frame.origin.y
        //        getImage()
        print(source)
        print(updatedY)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func DoneBtnPressed(_ sender: AnyObject) {
        save()
        
    }
    
    @IBAction func FontBtnPressed(_ sender: AnyObject) {

//        if tableString == "Font" {
//            tableView.isHidden = true
//            tableString = "Else"
//        } else {
//        tableView.isHidden = false
//        tableString = "Font"
//        tableViewWidth.constant = 230
//        tableView.reloadData()
//        }
        if tableView.isHidden == true {
            tableView.isHidden = false
        }else {
            tableView.isHidden = true
        }
        tableString = "Font"
        tableViewWidth.constant = 130
        tableView.reloadData()
        
    }
    
    @IBAction func AddFeatureBtnPressed(_ sender: AnyObject) {
        textViewEdit("Please Enter Here")
    }
    
    @IBAction func QuitEditingText(_ sender: UITapGestureRecognizer) {
//        tableView.isHidden = true
        textViews.forEach{$0.resignFirstResponder()}
    }
    
    
    @IBAction func CropImageBtnPressed(_ sender: AnyObject) {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ImageCropViewController") as! ImageCropViewController
        controller._image = self.imageView.image
        controller.delegatesss = self
        tableView.isHidden = true
        self.present(controller, animated: true, completion: {() -> Void in
            print("Yes!!!!")
        })
    }

    
    
    
    func save(){
        
        let currentdateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let savingName = formatter.string(from: currentdateTime)
        
        let dictionary: [String : String] = [
            "nameTextField" :  savingName,
            ]
        
        let meme = Meme(dictionary: dictionary, context: self.sharedContext)
            meme.memedImage1 = self.generateMemedImage()
        self.saveContext()
        globalNumber = 0
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: meme.memedImage1!)
            }, completionHandler: {(success, error) -> Void in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    print("finished saving image")
                }
            })
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
//        navigationBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            imageView.frame.origin.y += updatedY / 2
            textViews.forEach { $0.frame.origin.y += updatedY/2}
            
        } else {
            
            imageView.frame.origin.y += updatedY
            textViews.forEach { $0.frame.origin.y += updatedY}
        }
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 1.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
//        navigationBar.isHidden = false
        toolBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = false
        
        return memedImage
    }
    
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.black
            dismiss(animated: true, completion: nil)
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Meme.fetchRequest()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nameTextField", ascending: true)]
        //        fetchRequest.predicate = NSPredicate(format: "pinData == %@", self.tappedPin!)
        //        print("This is the fetchedResultsController being created with the tappedPin.latitude: \(self.tappedPin.latitude!)")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext,sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController 
    }()
    
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func croppingFinished(_ controller: ImageCropViewController, img: UIImage) {
        print("We finished cropping")
        self.imageView.image = img
    }


}

extension MemeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableString == "FontStyle" {
            return fonts.count
        }else if tableString == "FontSize"{
            return 61
        }else if tableString == "Font" {
            return FontStyle.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if tableString == "FontStyle" {
            
            let labelAttributes = [
                NSStrokeColorAttributeName : UIColor.black,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: fonts[indexPath.row], size: 15)!,
                NSStrokeWidthAttributeName : -2.0] as [String : Any]
            cell.textLabel?.attributedText = NSAttributedString(string: UIFont.familyNames[indexPath.row], attributes: labelAttributes)
            
        }else if tableString == "FontSize"{
            cell.textLabel?.text = String(Array(15...75)[indexPath.row])
        }else {
            cell.textLabel?.text = FontStyle[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if  cell?.textLabel?.text == "Style" {
            tableString = "FontStyle"
            tableViewWidth.constant = 230
            tableView.reloadData()

        }else if cell?.textLabel?.text == "Size" {
            tableString = "FontSize"
            tableViewWidth.constant = 130
            tableView.reloadData()

        }else if tableString == "FontStyle" {
            theFontWeWant = fonts[indexPath.row]
            textViews.forEach{ $0.font = UIFont(name: theFontWeWant, size: CGFloat(fontSize))}
        }else if tableString == "FontSize" {
            let theNumber = Int((cell?.textLabel?.text)!)
            textViews.forEach{ $0.font = UIFont(name: theFontWeWant, size: CGFloat(theNumber!))}
        }
    }
    
    
}

