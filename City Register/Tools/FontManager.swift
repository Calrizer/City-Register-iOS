//
//  FontManager.swift
//  City Register
//
//  Created by Callum Drain on 25/10/2018.
//  Copyright © 2018 Calrizer. All rights reserved.
//

import Foundation
import UIKit

public class FontManager {
    
    class func regular(size : Int) -> UIFont {
        
        return UIFont(name: "Raleway-Regular", size: CGFloat(size))!
        
    }
    
    class func light(size : Int) -> UIFont {
        
        return UIFont(name: "Raleway-Light", size: CGFloat(size))!
        
    }
    
    class func medium(size : Int) -> UIFont {
        
        return UIFont(name: "Raleway-Medium", size: CGFloat(size))!
        
    }
    
    class func semibold(size : Int) -> UIFont {
        
        return UIFont(name: "Raleway-SemiBold", size: CGFloat(size))!
        
    }
    class func bold(size : Int) -> UIFont {
        
        return UIFont(name: "Raleway-Bold", size: CGFloat(size))!
        
    }
    
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

