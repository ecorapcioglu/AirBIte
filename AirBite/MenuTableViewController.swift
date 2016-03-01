//
//  MenuTableViewController.swift
//  AirBite
//
//  Created by Eren Corapcioglu on 2/15/16.
//  Copyright © 2016 Eren Corapcioglu. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    var menuItem: [AnyObject!] = []
    var menuItemPrice: [AnyObject!] = []
    var menuItemType: [AnyObject!] = []
    var foodItem: [String] = []
    var priceItem: [String] = []
    var menuSectionName: [String] = []
    var appetizers: [AnyObject!] = []
    var appList: [String] = []
    var appetizersPrice: [AnyObject!] = []
    var appPriceList: [String] = []
    var foodDescription: [String] = []
    var wholeMenuArray: [NSArray!] = []

    /// Loads the page
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove the nil values from the arrays. Leaving nil values will break the for loops below.
        let menuWithNoNilValues = menuItem.flatMap { $0 }
        let priceWithNoNilValues = menuItemPrice.flatMap { $0}
        let menuSectionNameWithNoNilValues = menuItemType.flatMap { $0 }
        let appetizersWithNoNilValues = appetizers.flatMap { $0 }
        let appetizersPriceWithNoNilValues = appetizersPrice.flatMap { $0 }
        
        var menu: [String] = []
        // get just the food menu items from the array and convert to a string array.
         for item in menuWithNoNilValues{
            menu.append(item as! String)
        }
        
        var priceMenu: [String] = []
        for price in priceWithNoNilValues{
            // get just the food prices from the array and convert them to a string array.
            priceMenu.append(price as! String)
        }
        
        var menuSection: [String] = []
        for type in menuSectionNameWithNoNilValues {
            menuSection.append(type as! String)
        }
        
        var apps: [String] = []
        for app in appetizersWithNoNilValues {
            apps.append(app as! String)
        }
        
        var appsPrice: [String] = []
        for app in appetizersPriceWithNoNilValues {
            appsPrice.append(app as! String)
        }
        
       
        foodItem = removeDuplicates(menu)
        priceItem = removeDuplicates(priceMenu)
        menuSectionName = menuSection
        appList = removeDuplicates(apps)
        appPriceList = removeDuplicates(appsPrice)

        
        for _ in foodItem {
            if foodItem.count != priceItem.count {
                priceItem.append("N/A")
            }
        }
        
        for _ in appList {
            if appList.count != appPriceList.count {
                appPriceList.append("N/A")
            }
        }
    }
    

    
    /// alphabetizes the value in a string array.
    func before(value1: String, value2: String) -> Bool {
        // One string is alphabetically first.
        // ... True means value1 precedes value2.
        return value1 < value2;
    }
    
    /// Removed dupicate values from the array passed in.
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
            // Do not add a duplicate element.
            }
            else {
            // Add value to the set.
            encountered.insert(value)
            // ... Append the value.
            result.append(value)
            }
        }
            
        //result.sortInPlace(before)
            
        return result
    }
    
    /// returns a section per value in the foodItem array.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //menuSectionName.count//foodItem.count
    }

    /// returns the number of rows to be present on the table view. We currently only have one section with several rows. Currently we only want 1 row per section since each section is one menu item.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSectionName.count//appList.count
    }
    
    /// Set each section name to be a menu item.
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu Sections"//menuSectionName[section]//foodItem[section]
    }


    /// Passes each value from the priceItem array (which contains all the prices for the menu) and returns each item to its own table row.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        
        /// currently only populating the menu items with the app list.
        cell.textLabel?.text = menuSectionName[indexPath.row]//appList[indexPath.row] + " Price: " + appPriceList[indexPath.row]
        
        return cell
    }

    // MARK: - Segues
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "descriptionSegue" {
//            if let destination = segue.destinationViewController as? DescriptionViewController {
//                if let blogIndex = tableView.indexPathForSelectedRow?.row {
//                    destination.itemName = appList[blogIndex]
//                    destination.itemPrice = appPriceList[blogIndex]
//                    destination.descriptionString = foodDescription[blogIndex]
//                }
//            }
//        }
//    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "descriptionSegue" {
//            if let destination = segue.destinationViewController as? AccordionMenuTableViewController {
//                destination.menuSectionName = menuSectionName
//                destination.wholeMenuArray = wholeMenuArray
////                if let blogIndex = tableView.indexPathForSelectedRow?.row {
////                    destination.itemName = appList[blogIndex]
////                    destination.itemPrice = appPriceList[blogIndex]
////                    destination.descriptionString = foodDescription[blogIndex]
////                }
//            }
//        }
//    }



 }
