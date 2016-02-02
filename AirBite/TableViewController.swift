//
//  TableViewController.swift
//  AirBite
//
//  Created by Jose Cordova on 2/1/16.
//  Copyright © 2016 Eren Corapcioglu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var dataPassed:String!
    var secondDataPassed:String!
    var restaurants: [String] = []
    
    
   // var restaurants: Array[String] = dataPassed

    @IBOutlet weak var text: UITextView!

  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //text.text = dataPassed

        // this splits the restaurants list by comma and puts the list into an array.
        // this will then let us use this array to return the restaurants individually to the table cell in tableView.
         restaurants = dataPassed.componentsSeparatedByString(",")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /// This function returns the number of rows to be present in each table section (the number of sections
    /// is set in numberOfSectionInTableView function.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // we want to return the number of rows based on how many values are in the restaurants array.
        return restaurants.count
    }
    
    // This returns the title of the section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restaurants"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("labelCell", forIndexPath: indexPath)

        // Configure the cell...
        
        
        // return a value for each cell (text value) based on the values in the restuarnts array.
        cell.textLabel?.text = restaurants[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}