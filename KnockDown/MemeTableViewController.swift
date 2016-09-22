//
//  MemeTableViewController.swift
//  KnockDown
//
//  Created by Xiaochao Luo on 2016-09-20.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        tableView.reloadData()
        
        if globalNumber == 0 {
            globalNumber = 1
            strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
            strLabel.text = "Completed"
            strLabel.textColor = UIColor.white
            messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
            messageFrame.layer.cornerRadius = 15
            messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
            //        if indicator {
            //            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            //            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            //            activityIndicator.startAnimating()
            //            messageFrame.addSubview(activityIndicator)
            //        }
            messageFrame.addSubview(strLabel)
            view.addSubview(messageFrame)
            
            self.view.insertSubview(messageFrame, aboveSubview: self.view)
            UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {self.messageFrame.alpha = 0.0}, completion: nil)
            
        }
    }
    
    @IBAction func pickImageFromLibrary(_ sender: AnyObject) {
//        let controller = storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
//        controller.source = "library"
//        self.present(controller, animated: true, completion: nil)
        performSegue(withIdentifier: "CreateNew", sender: self)
    }
    
    @IBAction func shootAnImage(_ sender: AnyObject) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNew" {
            let DestinationVC: MemeViewController = segue.destination as! MemeViewController
            DestinationVC.source = "library"
//            segue.destination as! MemeViewController
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        default:
            return
        }
    }
    
    //
    // This is the most interesting method. Take particular note of way the that newIndexPath
    // parameter gets unwrapped and put into an array literal: [newIndexPath!]
    //
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
            //        case .Update:
            //            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ActorTableViewCell
            //            let actor = controller.objectAtIndexPath(indexPath!) as! Person
            //            self.configureCell(cell, withActor: actor)
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nameTextField", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext,sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func pathForIdentifier(_ identifier: String) -> String {
        let documentsDirectoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURL = documentsDirectoryURL.appendingPathComponent(identifier)
        return fullURL.path
    }
    


    
}

extension MemeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTable")!
        let myMeme = fetchedResultsController.object(at: indexPath) as! Meme
        //        let memes = self.memes[indexPath.row]
        cell.imageView?.image = myMeme.memedImage1
        cell.textLabel?.text = myMeme.nameTextField!
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "ManagePageViewController") as! ManagePageViewController
//        let myMeme = fetchedResultsController.object(at: indexPath) as! Meme
//        detailController.memes = myMeme
        detailController.currentIndex = (indexPath as NSIndexPath).row
        //        let memeList = fetchedResultsController.fetchedObjects! as! [Meme]
        //        print(memeList)
        
        self.present(detailController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let myMeme = self.fetchedResultsController.object(at: indexPath) as! Meme
            let path = pathForIdentifier(myMeme.nameTextField!)
            do{
                try FileManager.default.removeItem(atPath: path)
            }catch {
                return
            }
            sharedContext.delete(myMeme)
            saveContext()
        }
    }
    
    
    
    
    
    
    
    
}
