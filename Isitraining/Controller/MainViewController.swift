//
//  ViewController.swift
//  Isitraining
//
//  Created by Robin kamo on 2018-03-22.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, backToMain {
    
  
    
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "c45a258ddcdf0e30f74360bdbfdeccf2"
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var city = WeatherDataModel()
    var cityArray : [WeatherDataModel] = []
    var favCities : [String] = []
    var cityDidChange : (yesOrNo : Bool, atIndex : Int) = (false, 0)

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
 
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        //assyncroice method works in background
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
            loadSavedFavorites()
        
    }
    
    override func viewDidLayoutSubviews() {
        let jeremyGif = UIImage.gifImageWithName("lightning")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        super.view.insertSubview(imageView, at: 0)
    
    }
    
   
    
    
    func getWeatherData(url : String, parameters : [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print(response.result.description)
                
                let weatherJSON : JSON  = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                self.cityLabel.text = "Connections issues"
            }
        }
        
    }
 
    func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double{
            city.temperature = Int(tempResult - 273.15)
            city.city = json["name"].stringValue
            city.condition = json["weather"][0]["id"].intValue
            city.weatherIconName = city.updateWeatherIcon(condition: city.condition)
            updateUIWithWeatherData(city: city)
        } else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    func updateUIWithWeatherData(city : WeatherDataModel){
        
        cityLabel.text = city.city 
        tempretureLabel.text = "\(city.temperature) ℃"
        weatherIcon.image = UIImage(named: city.weatherIconName)

    }
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("Long = \(location.coordinate.longitude), lat = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url : WEATHER_URL, parameters : params)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location unavailable"
    }
    
    func userEnteredANewCityName(city: String) {
        print("yoo testing\(city)")
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }
    
    func updateUIWIthData(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityController
            destinationVC.delegate = self
            
        } else if segue.identifier == "changeView"{
            let destinationVC = segue.destination as! TableViewController
            destinationVC.listOfCitys = cityArray
            destinationVC.listOfCitysInString = favCities
            destinationVC.mainDelegate = self
        }
        
        
    }
    
    @IBAction func addToFavPressed(_ sender: Any) {
        cityArray.append(city)
        favCities.append(cityLabel.text!)
        defaults.set(favCities, forKey: "cities")
        
        
    }
    
    func loadSavedFavorites() {
        favCities = defaults.stringArray(forKey: "cities") ?? [String]()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

