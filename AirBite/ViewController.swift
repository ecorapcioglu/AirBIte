//
//  ViewController.swift
//  AirBite
//
//  Created by Eren Corapcioglu on 11/9/15.
//  Copyright © 2015 Eren Corapcioglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var outputLabel: UITextView!                 // Textview used for testing purposes
    @IBOutlet weak var airportField: AutoCompleteTextField!     // Airport Text Field
    @IBOutlet weak var airlineField: UITextField!               // Airline Text Field
    @IBOutlet weak var flightField: UITextField!                // Flight Number Text Field
    
    var menuItem: [AnyObject!] = []
    var menuItemPrice: [AnyObject!] = []
    var menuItemType: [AnyObject!] = []
    
    var appetizers: [AnyObject!] = []
    var appetizersPrice: [AnyObject!] = []
    var descriptionsArray: [AnyObject!] = []
    
    var wholeMenuArray: [NSArray!] = []
    
    var foodDescription: [String] = []
    @IBOutlet var restaurantsName: [String] = []
    
    private var responseData:NSMutableData?     // Creates dynamic mutable data
    private var connection:NSURLConnection?     // Load the contents of a URL by providing a URL request object
    
    
    //Airport API Url & Keys
    private let airportCode = ""
    private let airportAppId = "b3bc8082"
    private let airportAppKey = "7f2044891f2c25f3fadd4b7af9505450"
    private let airportURLString = "https://api.flightstats.com/flex/airports/rest/v1/json/iata/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.airportField.delegate = self;
        self.airlineField.delegate = self;
        self.flightField.delegate = self;
        configureTextField()
        handleTextFieldInterfaces()
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    //Method for having the status bar on top with a light color, depending on our background color.
    /*
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    */
    
    
    //Dismisses the keyboard from all 3 textfields.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        airportField.resignFirstResponder()
        airlineField.resignFirstResponder()
        flightField.resignFirstResponder()
        return true
    }
    
    //Dismisses the keyboard from All 3 TextFields.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        airportField.resignFirstResponder()
        airlineField.resignFirstResponder()
        flightField.resignFirstResponder()
        return true
    }
    
    //Configuration of the Font from the AutoComplete list in Aiport Field.
    private func configureTextField(){
        airportField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        airportField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        airportField.autoCompleteCellHeight = 35.0
        airportField.maximumAutoCompleteCount = 20
        airportField.hidesWhenSelected = true
        airportField.hidesWhenEmpty = true
        airportField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        airportField.autoCompleteAttributes = attributes
    }
    
    //Action for the Button
    @IBAction func buttonPressed(sender: AnyObject) {
        
        //Saves airport textfield text into this variable.
        let userInput = airportField.text
        
        //Saves only the airport code of each line in airport textfield.
        let airportCode = userInput? .substringToIndex((userInput?.startIndex.advancedBy(3))!)
        
        let urlString = "https://api.locu.com/v1_0/venue/6e15db9473d02dda8ffe/?has_menu=TRUE&locality=" + airportCode! + "&api_key=42c74053d1a1b2377c716af18da0b235d260be5b"
  
        //Connecting to the API
        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if url != nil{
            let urlRequest = NSURLRequest(URL: url!)
            self.connection = NSURLConnection(request: urlRequest, delegate: self)
        }
        
    }
    
    private func handleTextFieldInterfaces(){
        airportField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                
                let urlString = self!.airportURLString + text + "?appId=" + self!.airportAppId + "&appKey=" + self!.airportAppKey
                
                
                //Connecting to the API
                let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
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
                    
                    if let predictions = result["airports"] as? NSArray{
                        
                        //Arrays for storing the data extracted.
                        var locations = [String]()
                        var locations2 = [String]()
                        var locations3 = [String]()
                        
                        for dict in predictions as! [NSDictionary]{
                            //Extracting iata code and name of the Airport from airports dictionary.
                            locations.append(dict["iata"] as! String)
                            locations2.append(dict["name"] as! String)
                        }
                        
                        //Formatting and appendng the iata code array and the name array into a new formatted one.
                        for var index = 0; index < locations.count; ++index {
                            locations3.append(locations[index] + "  " + locations2[index])
                        }
                        
                        //Returning the formatted array into the AutoCompleteStrings from the airport field.
                        self.airportField.autoCompleteStrings = locations3
                        return
                    }
                
                    //Same as above, extracting data from the objects array or dictionary.
                    let prediction = result["objects"] as! NSArray
                    //let predictions2 = predictions!["menus"] as? NSArray
                    var locations = [String]()
                    
                    for dict in prediction {
                        //Extracting the name of the restaurants
                        locations.append(dict["name"] as! String)
                        
                        let predictions2 = dict["menus"] as! NSArray
                        
                        for dict2 in predictions2{
                            
                            let predictions3 = dict2["sections"] as! NSArray
                            
                            for dict3 in predictions3{
                                let predictions4 = dict3["subsections"] as! NSArray
                                let menuType = dict3["section_name"]
                                
                                menuItemType.append(menuType)
                                
                                wholeMenuArray.append(predictions3)
                                
                                
                                /// this is used to pull just the appetizer section for now. This will be updated to filter per section but for now this is just for the appetizer arrays.
                                if let firstElem = menuItemType.first {
                                    for elem in predictions3 {
                                        if elem["section_name"] as! String == firstElem as! String {
                                            
                                            for subSection in elem["subsections"] as! NSArray {
                                                let subSec = subSection["contents"] as! NSArray
                                                for food in subSec {
                                                    let appItem = food["name"]
                                                    appetizers.append(appItem)
                                                    let appPrice = food["price"]
                                                    appetizersPrice.append(appPrice)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            for dict4 in predictions4{
                                let predictions5 = dict4["contents"] as! NSArray
                                    
                                for dict5 in predictions5{
                                    let group = dict5["name"]
                                    let group2 = dict5["price"]
                                    let itemDescription = dict5["description"]
                                    descriptionsArray.append(itemDescription)
                                        
                                    menuItem.append(group)
                                    menuItemPrice.append(group2)
                                }
                            }
                        }
                    }
                } // this ends predictions
                
                let descriptionWithNoNilValues = descriptionsArray.flatMap { $0 }
                
                for app in descriptionWithNoNilValues {
                    foodDescription.append(app as! String)
                }
                
                //Returning the result in a textview called outputLabel.
                for var index = 0; index < locations.count; ++index{
                    self.restaurantsName.append(locations[index])
                }
                
                // intialize submit button segue here.
                self.performSegueWithIdentifier("btnSubmitSegue", sender: self)
                
                return
                }
            }
            catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }


    //Dismiss the keyboard from Airport Field.
    func dismissKeyboard(){
        self.airportField.resignFirstResponder()
    }
    
    //Sending the data returned in the outputLabel textview to dataPassed which is a string variable in TableViewController.swift
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "btnSubmitSegue") {
            let svc = segue.destinationViewController as! TableViewController
            svc.restaurantsName = restaurantsName
            svc.menuItems = menuItem
            svc.menuItemPrices = menuItemPrice
            svc.menuItemType = menuItemType
            svc.appetizers = appetizers
            svc.appetizersPrice = appetizersPrice
            svc.foodDescription = foodDescription
            svc.wholeMenuArray = wholeMenuArray
        }
    }
}
