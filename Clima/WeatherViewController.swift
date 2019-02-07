//
//  ViewController.swift
//  WeatherApp
//
//  Created by divyabharathi on 06/02/2019.
//  Copyright (c) divyabharathi. All rights reserved.
//

import UIKit
import CoreLocation // this is to determine current latitude and longitude of a device
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "efc7d97b1dedc4180f0f881eca8398ae"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager() // creating an object for CLLocationManager class

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the location manager here.
        
    locationManager.delegate = self   // set delegate property to self/current class(i.e., to have access to all capabilities of CLLocationManager class, WeatherViewController class has to come delegate of locationManager)
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // set location accuracy property
    locationManager.requestWhenInUseAuthorization()  //this method triggers authorization popup. To trigger a popup it is necessary to add description in propertylist(plist.info file)
    locationManager.startUpdatingLocation() // this will find location and send info to our delegate class WeatherviewController with cordinates
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherdata(url:String, parameters: [String:String]){
        Alamofire.request (url, method: .get, parameters: parameters).responseJSON {
             response in
            if response.result.isSuccess {
                print("got weather data")
            } else {
                print("error \(String(describing: response.result.error))")
                self.cityLabel.text = "connection issues"
        }
    }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    // after location is found, data is handled in this method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        // all locations are stored in array [CLLocation]
    {
        let location = locations[locations.count - 1] // in order to grab last value from array
        if location.horizontalAccuracy>0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude)")
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat": latitude , "lon": longitude , "appid" :APP_ID] // these param values are from api call to weather  website
            getWeatherdata(url: WEATHER_URL, parameters: params)
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        //if location is not found due to no internet etc then display location not available
    {
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    

}
