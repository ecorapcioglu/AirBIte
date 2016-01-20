//
//  ViewController.swift
//  AirBite
//
//  Created by Eren Corapcioglu on 11/9/15.
//  Copyright © 2015 Eren Corapcioglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDataDelegate {

    //@IBOutlet weak var airportField: AutoCompleteTextField!
    
    @IBOutlet weak var airportField: AutoCompleteTextField!
    
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightField: UITextField!
    
    
    private var responseData:NSMutableData?
    private var connection:NSURLConnection?
    
    var sampleList: [String] = ["Houston", "Shreveport", "Austin", "Dallas", "Miami", "New York", "Denver", "Tampa"]
    //private let googleMapsKey = "AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
    //private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    private let googleMapsKey = "0c91c28538c61cac27eed49a353e3e2d"
    private let baseURLString = "https://api.flightstats.com/flex/airports/rest/v1/json"
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    //override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //return UIStatusBarStyle.LightContent
    //}
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        airportField.resignFirstResponder()
        airlineField.resignFirstResponder()
        flightField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        airportField.resignFirstResponder()
        airlineField.resignFirstResponder()
        flightField.resignFirstResponder()
        return true
    }
    


    
    
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
    
    
    
    private func handleTextFieldInterfaces(){
        airportField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                //let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)"
                
                let urlString = "https://api.flightstats.com/flex/airports/rest/v1/json/iata/\(text)?appId=cbd2ebb0&appKey=0c91c28538c61cac27eed49a353e3e2d"
                
               // let urlString = "\(self?.baseURLString)/countryCode/US?appId=cbd2ebb0&appKey=0c91c28538c61cac27eed49a353e3e2d"
               
               // https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4&input=houston
                
               // https://api.flightstats.com/flex/airports/rest/v1/json/countryCode/US?appId=cbd2ebb0&appKey=0c91c28538c61cac27eed49a353e3e2d
                
               //  https://api.flightstats.com/flex/airports/rest/v1/json/cityCode/HOU?appId=cbd2ebb0&appKey=0c91c28538c61cac27eed49a353e3e2d
                
                
                let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }

    }
    
    
   
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = responseData{
            
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                //if let status = result["status"] as? String{
                   // if status == "OK"{
                        if let predictions = result["airports"] as? NSArray{
                            var locations = [String]()
                            //var locations2 = [String]()
                            //var locations3 = [String]()
                            var locations4 = [String]()
                            var locations5 = [String]()
                            for dict in predictions as! [NSDictionary]{
                                locations.append(dict["iata"] as! String)
                                //locations2.append(dict["city"] as! String)
                                //locations3.append(dict["stateCode"] as! String)
                                locations4.append(dict["name"] as! String)
                            }
                            
                            for var index = 0; index < locations.count; ++index {
                                locations5.append(locations[index] + "  " + locations4[index])
                                //print("index is \(index)")
                            }
                            
                            
                            
                            
                            self.airportField.autoCompleteStrings = locations5
                            return
                        }
                    //}
                //}
                //self.airportField.autoCompleteStrings = nil
            }
            catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    func dismissKeyboard(){
        self.airportField.resignFirstResponder()
    }
    




}

