//
//  Recent.swift
//  City Register
//
//  Created by Callum Drain on 29/10/2018.
//  Copyright © 2018 Calrizer. All rights reserved.
//

import Foundation

public class Recent {
    
    private var title : String
    private var date : String
    private var lecturer : String
    
    public init(title:String, date:String, lecturer:String) {
        
        self.title = title
        self.date = date
        self.lecturer = lecturer
    
    }
    
    public func getTitle() -> String{
        
        return self.title
        
    }
    
    public func getDate() -> String{
        
        return self.date
        
    }
    
    public func getLecturer() -> String{
        
        return self.lecturer
        
    }
    
}
