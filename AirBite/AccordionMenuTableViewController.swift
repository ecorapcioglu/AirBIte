//
//  AccordionMenuTableViewController.swift
//  AccordionTableSwift
//
//  Created by Eren Corapcioglu on 2/29/16.
//

import UIKit

class AccordionMenuTableViewController: UITableViewController {
    
    var descriptionString = String()
    var foodDescription: [String] = []
    var itemName = String()
    var itemPrice = String()
    var restaurantsID = String()
    
    var menuSectionName: [String] = []
    var wholeMenuArray: [AnyObject!] = []
    var appetizers: [AnyObject!] = []
    var appList: [String] = []
    var appetizersPrice: [AnyObject!] = []
    var appPriceList: [String] = []
    
    var menuSectionItems = [String]()
    var menuItems = [[String]]()
    
    var menuDescriptionItems = [[String]]()
    
    var currentItemsExpanded = [Int]()
    var actualPositions = [Int]()
    var total = 0
    
    var menuSectionIdentifier = "MenuSection"
    var menuItemIdentifier = "MenuItem"
    
    var menuItemType: [AnyObject!] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuSectionNameWithNoNilValues = menuItemType.flatMap { $0 }
        
         var menuSection: [String] = []
         for type in menuSectionNameWithNoNilValues {
             menuSection.append(type as! String)
         }
        
        menuSectionName = menuSection
        //print(wholeMenuArray[0] as! String)
        
        formatArrays()
        
        for (var i = 0; i < menuSectionName.count; i++) {
            menuSectionItems.append(menuSectionName[i])
            actualPositions.append(-1)
            
            var foodItems: [AnyObject!] = []
            
            var desciprtionItems: [AnyObject!] = []
    
            for menu in wholeMenuArray {
                if menu["section_name"] as! String == menuSectionName[i]{
                    let subSections = menu["subsections"] as! NSArray
                    //print(subSections)
                    for subSection in subSections {
                        let foodContents = subSection["contents"] as! NSArray
                        for foodItem in foodContents {
                            if let food = foodItem["name"] {
                                let foodItemWithNoNils = food.flatMap { $0 }
                                foodItems.append(foodItemWithNoNils)
                            }
                            
                            if let description = foodItem["description"] {
                                let descriptionItemWithNoNils = description.flatMap { $0 }
                                desciprtionItems.append(descriptionItemWithNoNils)
                            }
                        }
                    }
                }
            }
            
            let foodItemNoNil = foodItems.flatMap { $0 }
            var items = [String]()
            for (var i = 0; i < foodItemNoNil.count; i++) {
                items.append(foodItemNoNil[i] as! String)
            }
            
            self.menuItems.append(items)
            
            let desciptionItemNoNil = desciprtionItems.flatMap { $0 }
            var descItems = [String]()
            for (var i = 0; i < desciptionItemNoNil.count; i++) {
                descItems.append(desciptionItemNoNil[i] as! String)
            }
            
            self.menuDescriptionItems.append(descItems)
        }
        
        total = menuSectionItems.count
    }
    
    /// Format the arrays when needed. Remove nil values, convert to strings, etc.
    func formatArrays()
    {
        let appetizersWithNoNilValues = appetizers.flatMap { $0 }
        var apps: [String] = []
        for app in appetizersWithNoNilValues {
            apps.append(app as! String)
        }
        appList = removeDuplicates(apps)
        
        
        let appetizersPriceWithNoNilValues = appetizersPrice.flatMap { $0 }
        var appsPrice: [String] = []
        for app in appetizersPriceWithNoNilValues {
            appsPrice.append(app as! String)
        }
        appPriceList = removeDuplicates(appsPrice)
        
        for _ in appList {
            if appList.count != appPriceList.count {
                appPriceList.append("N/A")
            }
        }
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
        
        return result
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// returns the number of sections in the table view.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// returns the number of rows to be present in each section on the table view.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    /// Organize the MenuSection and MenuItem cells.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let menuSection = self.findParentMenuSection(indexPath.row)
        let currentItemsExpanded = self.currentItemsExpanded.indexOf(menuSection)
        
        let isMenuItem = currentItemsExpanded != nil && indexPath.row != self.actualPositions[menuSection]
        
        var cell : UITableViewCell!
        
        if isMenuItem {
            cell = tableView.dequeueReusableCellWithIdentifier(menuItemIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = self.menuItems[menuSection][indexPath.row - self.actualPositions[menuSection] - 1]
            //cell.backgroundColor = UIColor.greenColor()
            
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(menuSectionIdentifier, forIndexPath: indexPath) as UITableViewCell
            let topIndex = self.findParentMenuSection(indexPath.row)
            
            cell.textLabel!.text = self.menuSectionItems[topIndex]
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    /// set up the features when a row is tapped - whether it's a parent row or child row.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let menuSections = self.findParentMenuSection(indexPath.row)
        let currentItemsExpanded = self.currentItemsExpanded.indexOf(menuSections)
        var isChild = currentItemsExpanded != nil
        
        if indexPath.row == self.actualPositions[menuSections]{
            isChild = false
        }
        
//        if (isChild) {
//            NSLog("A child was tapped!!!");
//            return;
//        }
        
        // this is a built in table view featuer - allow multiple insert/delete of rows and sections to be animated simultaneously.
        self.tableView.beginUpdates()
        
        if let removeIndexValue = self.currentItemsExpanded.indexOf(self.findParentMenuSection(indexPath.row)) {
            
            self.collapseSubItemsAtIndex(indexPath.row)
            self.actualPositions[menuSections] = -1
            self.currentItemsExpanded.removeAtIndex(removeIndexValue)
            
            for (var i = menuSections + 1; i < self.menuSectionItems.count; i++) {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] -= self.menuItems[menuSections].count
                }
            }
        }
        else {
            let menuSection = self.findParentMenuSection(indexPath.row)
            
            self.expandItemAtIndex(indexPath.row)
            self.actualPositions[menuSection] = indexPath.row
            
            for (var i = menuSection + 1; i < self.menuSectionItems.count; i++) {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] += self.menuItems[menuSection].count
                }
            }
            self.currentItemsExpanded.append(menuSection)
        }
        
        self.tableView.endUpdates()
    }
    
    /// expands the selected parent cell.
    private func expandItemAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let val = self.findParentMenuSection(index)
        
        let currentMenuItems = self.menuItems[val]
        var insertPos = index + 1
        
        for (var i = 0; i < currentMenuItems.count; i++) {
            indexPaths.append(NSIndexPath(forRow: insertPos++, inSection: 0))
        }
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total += self.menuItems[val].count
    }
    
    /// collapses the selected (and currently expanded) parent cell.
    private func collapseSubItemsAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        let menuSections = self.findParentMenuSection(index)
        
        for (var i = index + 1; i <= index + self.menuItems[menuSections].count; i++ ){
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total  -= self.menuItems[menuSections].count
    }
    
    /// sets the height and width of the cells based on if child cells are showing.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let menuSections = self.findParentMenuSection(indexPath.row)
        let currentItemsExpanded = self.currentItemsExpanded.indexOf(menuSections)
        
        let isMenuItem = currentItemsExpanded != nil && indexPath.row != self.actualPositions[menuSections]
        
        if (isMenuItem) {
            return 44.0
        }
        return 64.0
    }
    
    /// finds the index at which the parent menu section cell is located.
    private func findParentMenuSection(index : Int) -> Int {
        
        var menuSection = 0
        var i = 0
        
        while (true) {
            if (i >= index) {
                break
            }
            
            // if is opened
            if let _ = self.currentItemsExpanded.indexOf(menuSection) {
                i += self.menuItems[menuSection].count + 1
                
                if (i > index) {
                    break
                }
            }
            else {
                ++i
            }
            
            ++menuSection
        }
        
        return menuSection
    }
    
    /// prepare for the segue to the description page. Pass the necessary values to the description page.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "descriptionSegue" {
            if let destination = segue.destinationViewController as? DescriptionViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    
                    destination.blogIndex = blogIndex
                    destination.itemName = menuItems
                    destination.descriptionString = menuDescriptionItems//foodDescription[blogIndex]
                    
                }
            }
        }
    }
}
