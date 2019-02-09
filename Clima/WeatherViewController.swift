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

class WeatherViewController: UIViewController,CLLocationManagerDelegate,CanReceive {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "efc7d97b1dedc4180f0f881eca8398ae"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager() // creating an object for CLLocationManager class which is inbuilt class
    var weatherdata = WeatherDataModel() //this variable to accesss data from weatherdatamodel.swift

    
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
    locationManager.startUpdatingLocation() // this will find location and send info to our delegate class WeatherviewController with cordinates. This is asynchronous method-work in background. in order to receive data, implemented method didUpdateLocations()
        
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherdata(url:String, parameters: [String:String]){
        Alamofire.request (url, method: .get, parameters: parameters).responseJSON {
             response in //closures in swift
            if response.result.isSuccess {
                print("got weather data") //printing to console when success and it will send data
                // formatting data received to use it on our app
                let weatherJSON : JSON = JSON(response.result.value!) // data received is optional we can force unwrap this since we are checking isSuccess
                self.updateWeatherdata(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "connection issues"
            }
        }
    }

    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherdata(json: JSON) {
        if let tempResult = json["main"]["temp"].double
        {
        weatherdata.temperature = Int(tempResult - 273.15) // if we give wrong app id, data will not fetch in this case, here instead of force unwrap tempResult make it to optional binding so remove "!" for tempResult and use if condition
        weatherdata.city = json["name"].stringValue
        weatherdata.condition = json["weather"][0]["id"].intValue
        weatherdata.weatherIconName = weatherdata.updateWeatherIcon(condition: weatherdata.condition)
        updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "weather unavailable"
            temperatureLabel.text = "-"
            weatherIcon.image = UIImage(named:"dunno")
        
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherdata.city
        temperatureLabel.text = "\(weatherdata.temperature)°"
        weatherIcon.image = UIImage(named: weatherdata.weatherIconName)
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here:
    // after location is found, data is handled in this method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])   // all locations are stored in array [CLLocation]
    {
        let location = locations[locations.count - 1] // in order to grab last value from array
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation() // stop updating location once found a location for user
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            // now turn these lat and long data in to parameters to send data to weather app website
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params : [String : String] = ["lat": latitude , "lon": longitude , "appid" :APP_ID] // use dictionary. these 3 param values are from api call to weather app  website
            getWeatherdata(url: WEATHER_URL, parameters: params)
        }
    }
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //if location is not found due to no internet etc then display location not available
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the dataReceived Delegate method here:
        func dataReceived(city: String) {
//            print(city) --> no need to print to console instaed display weather info on app UI. below is code for it
            let params : [String : String] = ["q" : city , "appid" : APP_ID]
            getWeatherdata(url: WEATHER_URL, parameters: params)
            }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let secondVC = segue.destination as! ChangeCityViewController
            secondVC.delegate = self
            
        }
    }
    

}
