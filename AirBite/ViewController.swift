//
//  ViewController.swift
//  AirBite
//
//  Created by Eren Corapcioglu on 11/9/15.
//  Copyright © 2015 Eren Corapcioglu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var airportField: UITextField!
    @IBOutlet weak var airlineField: UITextField!
    @IBOutlet weak var flightField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.airportField.delegate = self;
        self.airlineField.delegate = self;
        self.flightField.delegate = self;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }



}

