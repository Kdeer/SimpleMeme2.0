//
//  ManagePageViewController.swift
//  memetest
//
//  Created by Xiaochao Luo on 2016-09-07.
//  Copyright © 2016 Xiaochao Luo. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class ManagePageViewController: UIPageViewController, NSFetchedResultsControllerDelegate  {

      var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        fetchedResultsController.delegate = self

        
        do {
            try fetchedResultsController.performFetch()
            }
        catch {}

        dataSource = self
        
//        // 1
//        if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
//            let viewControllers = [viewController]
//            // 2
//            viewController.viewDidLayoutSubviews()
//            
//            setViewControllers(
//                viewControllers,
//                direction: .Forward,
//                animated: false,
//                completion: nil
//            )
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            // 2
            
            setViewControllers(
                viewControllers,
                direction: .forward,
                animated: false,
                completion: nil
            )
        }
    }
    

    
    
    func viewPhotoCommentController(_ index: Int) -> ImageViewController? {
        let memeList = fetchedResultsController.fetchedObjects! as! [Meme]
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ImageViewController")
                as? ImageViewController {
            page.memes = memeList[index]
            page.photoIndex = index
            return page
        }
        return nil
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    @available(iOS 10.0, *)
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nameTextField", ascending: true)]
        //        fetchRequest.predicate = NSPredicate(format: "pinData == %@", self.tappedPin!)
        //        print("This is the fetchedResultsController being created with the tappedPin.latitude: \(self.tappedPin.latitude!)")
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext,sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()


}


@available(iOS 10.0, *)
extension ManagePageViewController: UIPageViewControllerDataSource {
    // 1
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? ImageViewController {
            var index = viewController.photoIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            return viewPhotoCommentController(index!)
        }
        return nil
    }
    
    // 2
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let memeList = fetchedResultsController.fetchedObjects! as! [Meme]
        if let viewController = viewController as? ImageViewController {
            var index = viewController.photoIndex
            guard index != NSNotFound else {
                print("cannot find the index")
                return nil}
            index = index! + 1
            guard index != memeList.count else {return nil}
            return viewPhotoCommentController(index!)
        }
        return nil
    }
    
    // MARK: UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let memeList = fetchedResultsController.fetchedObjects! as! [Meme]
        return memeList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
    
}


