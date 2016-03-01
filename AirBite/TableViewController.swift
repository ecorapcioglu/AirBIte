//
//  TableViewController.swift
//  AirBite
//
//  Created by Jose Cordova on 2/1/16.
//  Copyright © 2016 Eren Corapcioglu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    var foodDescription: [String] = []
    var restaurantsName: [String] = []
    var restaurantsID: [String] = []
    var selectedRestaurantID = String()
    
    var menuItemType: [AnyObject!] = []
    var wholeMenuArray: [AnyObject!] = []
    var descriptionsArray: [AnyObject!] = []
    
    private var responseData:NSMutableData?     // Creates dynamic mutable data
    private var connection:NSURLConnection?     // Load the contents of a URL by providing a URL request object

    @IBOutlet weak var text: UITextView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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
        return restaurantsName
            .count
    }
    
    // This returns the title of the section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Restaurants"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("labelCell", forIndexPath: indexPath)

        // Configure the cell...
        // return a value for each cell (text value) based on the values in the restuarnts array.
        cell.textLabel?.text = restaurantsName[indexPath.row]
        
        return cell
    }
    
    private func restaurantAPI(){

        
        let urlString = "https://api.locu.com/v1_0/venue/" + selectedRestaurantID +   "/?has_menu=TRUE&locality=DFW&api_key=42c74053d1a1b2377c716af18da0b235d260be5b"
        
        //Connecting to the API
        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if url != nil{
            let urlRequest = NSURLRequest(URL: url!)
            self.connection = NSURLConnection(request: urlRequest, delegate: self)
        }
        
    }
    
    
    //API Connections
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    //API Connections
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    //API Response
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = responseData{
            do{
                //Extracting data from the "airports" array.
                if let result: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
                    
            
                    
                    //Same as above, extracting data from the objects array or dictionary.
                    let prediction = result["objects"] as! NSArray
                    
                    for dict in prediction {
                        
                        let predictions2 = dict["menus"] as! NSArray
                        
                        for dict2 in predictions2{
                            
                            let predictions3 = dict2["sections"] as! NSArray
                            
                            for dict3 in predictions3{
                                let predictions4 = dict3["subsections"] as! NSArray
                                let menuType = dict3["section_name"]
                                
                                menuItemType.append(menuType)
                                
                                wholeMenuArray.append(dict3)
                                
                                
                                /// this is used to pull just the appetizer section for now. This will be updated to filter per section but for now this is just for the appetizer arrays.
                                if let firstElem = menuItemType.first {
                                    for elem in predictions3 {
                                        if elem["section_name"] as! String == firstElem as! String {
                                        }
                                    }
                                }
                                
                                for dict4 in predictions4{
                                    let predictions5 = dict4["contents"] as! NSArray
                                    
                                    for dict5 in predictions5{
                                        let itemDescription = dict5["description"]
                                        descriptionsArray.append(itemDescription)
                                    }
                                }
                            }
                        }
                    } // this ends predictions
                    
                    let descriptionWithNoNilValues = descriptionsArray.flatMap { $0 }
                    
                    for app in descriptionWithNoNilValues {
                        foodDescription.append(app as! String)
                    }
                    
                    return
                }
            }
            catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Segues
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "restaurantSelectSegue" {
                if let menuTableViewController = segue.destinationViewController as?AccordionMenuTableViewController {
                    if let blogIndex = tableView.indexPathForSelectedRow?.row {
                        menuTableViewController.wholeMenuArray = wholeMenuArray
                        menuTableViewController.menuItemType = menuItemType
                        menuTableViewController.restaurantsID = restaurantsID[blogIndex]
                        selectedRestaurantID = restaurantsID[blogIndex]
                        restaurantAPI()
    
                    }
                }
            }
        }
}
