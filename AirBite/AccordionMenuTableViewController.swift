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
    var menuSectionName: [String] = []
    var wholeMenuArray: [NSArray!] = []
    var appetizers: [AnyObject!] = []
    var appList: [String] = []
    var appetizersPrice: [AnyObject!] = []
    var appPriceList: [String] = []
    
    var topItems = [String]()
    var subItems = [[String]]()
    
    var currentItemsExpanded = [Int]()
    var actualPositions = [Int]()
    var total = 0
    
    var parentCellIdentifier = "ParentCell"
    var childCellIdentifier = "ChildCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatArrays()
        
        for (var i = 0; i < menuSectionName.count; i++) {
            topItems.append(menuSectionName[i])
            actualPositions.append(-1)
            
            
            var items = [String]()
            for (var i = 0; i < appList.count; i++) {
                items.append(appList[i])
            }
            
            self.subItems.append(items)
        }
        
        total = topItems.count
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
    
    /// Organize the parent and child cell. Set the values for the parent and child cell. The parent cell is the cell containg the resturant menu sections. The child cell contains the menu items that belong to the current section/parent.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        
        let isChild = idx != nil && indexPath.row != self.actualPositions[parent]
        
        var cell : UITableViewCell!
        
        if isChild {
            cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel!.text = self.subItems[parent][indexPath.row - self.actualPositions[parent] - 1]
            //cell.backgroundColor = UIColor.greenColor()
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            let topIndex = self.findParent(indexPath.row)
            
            cell.textLabel!.text = self.topItems[topIndex]
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    /// set up the features when a row is tapped - whether it's a parent row or child row.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        var isChild = idx != nil
        
        if indexPath.row == self.actualPositions[parent]{
            isChild = false
        }
        
//        if (isChild) {
//            NSLog("A child was tapped!!!");
//            return;
//        }
        
        // this is a built in table view featuer - allow multiple insert/delete of rows and sections to be animated simultaneously.
        self.tableView.beginUpdates()
        
        if let value = self.currentItemsExpanded.indexOf(self.findParent(indexPath.row)) {
            
            self.collapseSubItemsAtIndex(indexPath.row)
            self.actualPositions[parent] = -1
            self.currentItemsExpanded.removeAtIndex(value)
            
            for (var i = parent + 1; i < self.topItems.count; i++) {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] -= self.subItems[parent].count
                }
            }
        }
        else {
            let parent = self.findParent(indexPath.row)
            
            self.expandItemAtIndex(indexPath.row)
            self.actualPositions[parent] = indexPath.row
            
            for (var i = parent + 1; i < self.topItems.count; i++) {
                if self.actualPositions[i] != -1 {
                    self.actualPositions[i] += self.subItems[parent].count
                }
            }
            self.currentItemsExpanded.append(parent)
        }
        
        self.tableView.endUpdates()
    }
    
    /// expands the selected parent cell.
    private func expandItemAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let val = self.findParent(index)
        
        let currentSubItems = self.subItems[val]
        var insertPos = index + 1
        
        for (var i = 0; i < currentSubItems.count; i++) {
            indexPaths.append(NSIndexPath(forRow: insertPos++, inSection: 0))
        }
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total += self.subItems[val].count
    }
    
    /// collapses the selected (and currently expanded) parent cell.
    private func collapseSubItemsAtIndex(index : Int) {
        
        var indexPaths = [NSIndexPath]()
        let parent = self.findParent(index)
        
        for (var i = index + 1; i <= index + self.subItems[parent].count; i++ ){
            indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.total  -= self.subItems[parent].count
    }
    
    /// sets the height and width of the cells based on if child cells are showing.
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let parent = self.findParent(indexPath.row)
        let idx = self.currentItemsExpanded.indexOf(parent)
        
        let isChild = idx != nil && indexPath.row != self.actualPositions[parent]
        
        if (isChild) {
            return 44.0
        }
        return 64.0
    }
    
    /// finds the index at which the parent cell is located.
    private func findParent(index : Int) -> Int {
        
        var parent = 0
        var i = 0
        
        while (true) {
            
            if (i >= index) {
                break
            }
            
            // if is opened
            if let _ = self.currentItemsExpanded.indexOf(parent) {
                i += self.subItems[parent].count + 1
                
                if (i > index) {
                    break
                }
            }
            else {
                ++i
            }
            
            ++parent
        }
        
        return parent
    }
    
    /// prepare for the segue to the description page. Pass the necessary values to the description page.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "descriptionSegue" {
            if let destination = segue.destinationViewController as? DescriptionViewController {
                if let blogIndex = tableView.indexPathForSelectedRow?.row {
                    destination.itemName = appList[blogIndex]
                    destination.itemPrice = appPriceList[blogIndex]
                    destination.descriptionString = foodDescription[blogIndex]
                }
            }
        }
    }
}
