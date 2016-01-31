//
//  tableData.swift
//  AirBite
//
//  Created by Arinna Green on 1/31/16.
//  Copyright © 2016 Eren Corapcioglu. All rights reserved.
//

import Foundation
import UIKit

        //deserializing JSON into model object
        //turning  out String-backed-table into  aModel-backed-table
class tableData{
    
    
        //declare the 3 properties
    var name: String?
    var description: String?
    var html_url: String?
  
        //designated initializer will take an NSDictionary, extract the relevant values and assign them to its properties
    init(json: NSDictionary){
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        self.html_url = json["html_url"] as? String
        
    }
}
