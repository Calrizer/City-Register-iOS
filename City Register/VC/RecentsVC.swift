//
//  RecentsVC.swift
//  City Register
//
//  Created by Callum Drain on 23/10/2018.
//  Copyright © 2018 Calrizer. All rights reserved.
//

import UIKit
import CoreData

class RecentsVC: UIViewController {

    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrButton.layer.cornerRadius = 25
        qrButton.clipsToBounds = true
        
        topView.addShadow(location: .bottom, color: UIColor.black, opacity: 0.02, radius: -2)
        
        bottomView.addShadow(location: .top, color: UIColor.black, opacity: 0.02, radius: -3)
        
//        let textLabel : UILabel = {
//            let label = UILabel()
//            label.text = "Recents"
//            label.font = FontManager.bold(size: 28)
//            label.lineBreakMode = .byWordWrapping
//            label.textColor = UIColor.black
//            label.textAlignment = .left
//            label.frame = CGRect(x: 20,
//                                 y: 70,
//                                 width: view.frame.width - 30,
//                                 height: 24)
//            return label
//        }()
//
//        mainScrollView.addSubview(textLabel)
  
    }
    
     override func viewDidAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recents")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let result = try context.fetch(request)
            
            var currentHeight = CGFloat(24)
            
            for data in result as! [NSManagedObject] {
                
                print()
                
                if let recent = Bundle.main.loadNibNamed("RecentView", owner: self, options: nil)?.first as? RecentView {
                    
                    recent.layer.cornerRadius = 5
                    recent.clipsToBounds = true
                    
                    recent.frame.size.width = self.view.bounds.width - 24
                    recent.frame.origin.y = CGFloat(currentHeight)
                    recent.frame.origin.x = 12
                    
                    recent.titleLabel.text = (data.value(forKey: "title") as! String)
                    recent.dateLabel.text = (data.value(forKey: "date") as! String)
                    recent.lecturerLabel.text = (data.value(forKey: "lecturer") as! String)
                    
                    mainScrollView.addSubview(recent)
                    
                    currentHeight = CGFloat(currentHeight) + (recent.frame.height + 12)
                    
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            
            topView.frame = CGRect(x:topView.frame.origin.x, y:topView.frame.origin.y + view.safeAreaInsets.top, width:topView.frame.size.width, height:topView.frame.size.height)
            
            mainScrollView.frame = CGRect(x:mainScrollView.frame.origin.x, y:mainScrollView.frame.origin.y + view.safeAreaInsets.top, width:mainScrollView.frame.size.width, height:mainScrollView.frame.size.height)
            
            bottomView.frame = CGRect(x:bottomView.frame.origin.x, y:bottomView.frame.origin.y - view.safeAreaInsets.bottom, width:bottomView.frame.size.width, height:bottomView.frame.size.height)
            
        }
        
    }
   
}
