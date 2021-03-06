//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by divyabharathi on 06/02/2019.
//  Copyright (c) divyabharathi. All rights reserved.
//

import UIKit

//Write the protocol declaration here:
protocol CanReceive{
    func dataReceived(city:String) // this meth has no body since protocol doesn't know how to implement any methods so implement this method in receiving data VC
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : CanReceive?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method dataReceived
        delegate?.dataReceived(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        dismiss(animated: true, completion: nil)
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
