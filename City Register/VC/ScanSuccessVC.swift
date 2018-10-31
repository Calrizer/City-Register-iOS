//
//  ScanSuccessVC.swift
//  City Register
//
//  Created by Callum Drain on 25/10/2018.
//  Copyright © 2018 Calrizer. All rights reserved.
//

import UIKit
import CoreData

class ScanSuccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let encoded = UserDefaults.standard.data(forKey: "recents"){
//
//            do {
//
//                var recents = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encoded) as! [Recent]
//                recents.append(Recent(title: "test", date: "test", lecturer: "test"))
//
//                do {
//
//                    let encoded = try NSKeyedArchiver.archivedData(withRootObject: recents, requiringSecureCoding: false)
//                    UserDefaults.standard.set(encoded, forKey: "recents")
//
//                } catch {
//                    print("Error storing.")
//                }
//
//            }catch{
//                print("Error reading.")
//            }
//
//        }else{
//
//            var recents = [Recent]()
//            recents.append(Recent(title: "test", date: "test", lecturer: "test"))
//
//            do {
//
//                let encoded = try NSKeyedArchiver.archivedData(withRootObject: recents, requiringSecureCoding: false)
//                UserDefaults.standard.set(encoded, forKey: "recents")
//
//            } catch {
//                print("Error storing.")
//            }
//
//        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    
    @IBAction func dismissButtonPressed(_ sender: Any) {
    
        self.navigationController?.popToRootViewController(animated: true)
    
    }
    
}
