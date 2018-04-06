//
//  CompareCityController.swift
//  Isitraining
//
//  Created by Robin kamo on 2018-04-05.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import GraphKit
import Alamofire
import SwiftyJSON

class CompareCityController: UIViewController, GKBarGraphDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    
    @IBOutlet var myBtn: UIView!
    @IBOutlet weak var firstPicker: UIPickerView!
    @IBOutlet weak var graph: GKBarGraph!
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "c45a258ddcdf0e30f74360bdbfdeccf2"
    var weatherJSON : JSON = JSON.null
    var listOfCities : [WeatherDataModel] = []
    var animator:UIDynamicAnimator?

    
    
    let userDefaults = UserDefaults.standard
    var favCitys : [String] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        favCitys = userDefaults.stringArray(forKey: "cities") ?? [String]()
        print("\(favCitys)")
        firstPicker.dataSource = self
        firstPicker.delegate = self
        graph.dataSource = self
        
        
        let square = UIView()
        
        square.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        square.backgroundColor = UIColor.red
        
        self.view.addSubview(square)
        
        self.animator = UIDynamicAnimator(referenceView:self.view)
        var gravity = UIGravityBehavior(items: [square])
        
        animator!.addBehavior(gravity)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func comparePressed(_ sender: Any) {
        updateLabel()
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.myBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.myBtn.transform = CGAffineTransform.identity
                        }
        })

    }
    
    func updateLabel(){
        
        let city1 = favCitys[firstPicker.selectedRow(inComponent: 0)]
        let city2 = favCitys[firstPicker.selectedRow(inComponent: 1)]
        
    
        
        let params : [String : String] = ["q" : city1, "appid" : APP_ID]
        let params2 : [String : String] = ["q" : city2, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        getWeatherData(url: WEATHER_URL, parameters: params2)
        
        
        print("your citys are \(city1), \(city2)")
  
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfBars() -> Int {
        return 2
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        return listOfCities[index].temperature as NSNumber
    }
    
    func titleForBar(at index: Int) -> String! {
        return "Temp"
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return favCitys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return favCitys[row]
    }
    
    // HTTPREQUEST
    func getWeatherData(url : String, parameters : [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print(response.result.description)
                
                let weatherJSON : JSON  = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("error")
            }
        }
        
    }
    func updateUIWithWeatherData(city: WeatherDataModel){
        print("hej detta funkar bror \(listOfCities[0].city, listOfCities[1].city)")
        graph.barWidth = 100
        graph.draw()
        
        listOfCities = []
        
    }
    
    func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double{
            let city = WeatherDataModel()
            city.temperature = Int(tempResult - 273.15)
            city.city = json["name"].stringValue
            city.condition = json["weather"][0]["id"].intValue
            city.weatherIconName = city.updateWeatherIcon(condition: city.condition)
        
            listOfCities.append(city)
            
            if listOfCities.count > 1 {
                updateUIWithWeatherData(city: city)

            }
          
            
        } else {
           print("error")
        }
    }
    
    func updateUI (){
        
    }

}
