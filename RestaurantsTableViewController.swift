//
//  RestaurantsTableViewController.swift
//  AirBite
//
//  Created by Arinna Green on 1/30/16.
//  Copyright © 2016 Eren Corapcioglu. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UIViewController, UITableViewDataSource{
    
    //outlet for table
    
   // @IBOutlet weak var tableOutlet: UITableViewCell!
    
    // pulling data from JSON
    override func viewDidLoad() {
    super.viewDidLoad()
        let reposURL = NSURL(string: "https://api.locu.com/v1_0/venue/search/?has_menu=TRUE&locality=DFW&api_key=42c74053d1a1b2377c716af18da0b235d260be5b")
        if let JSONData = NSData(contentsOfURL: reposURL!){
            if let json: NSDictionary! = (try! NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary{
                if let reposArray = json["items"] as? [NSDictionary]{
                    for item in reposArray{
                        Data.append(tableData(json: item))
                    }
                }
            }
        }
    }
    
    
    var Data = [tableData]()

            // MARK: - Table view data source
            //how many sections in the table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //return the number of sections
    }

            //how many rows in the table,
            //since we dont know how many rows we will actually need untill runtime, we return with data.count
            //meaning we want the number of rows inthe table to match the number repositories in array
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.count
    }
    
            //content of each cell
 /*   override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "Section \(section)" - not sure if we need this
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = Data[indexPath.row].name
        cell.detailTextLabel?.text = Data[indexPath.row].description

        return cell
    }
}

    
  /*  func get_data_from_url(url: String){
        let httpMethod = "Get"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        let queue = NSOperationQueue(); NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
            if data.length > 0 && error == nil{
                self.extract_json(data!)
            }else if data.length == 0 && error == nil{
                print("No restaurants available at this time")
            }else if error != nil{
                print("Error happened = \(error)")
            }
            
            })
        
    }*/

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



