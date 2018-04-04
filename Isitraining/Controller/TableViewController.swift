//
//  TableViewController.swift
//  Isitraining
//
//  Created by Robin kamo on 2018-03-24.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol backToMain {
    func updateUIWIthData(city: WeatherDataModel)

}



class TableViewController: UITableViewController, ChangeCityDelegate, UISearchBarDelegate {
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "c45a258ddcdf0e30f74360bdbfdeccf2"
    var weatherJSON : JSON = JSON.null


    @IBOutlet var myTableView: UITableView!
    var listOfCitys : [WeatherDataModel] = []
    var delegate : ChangeCityDelegate?
    var mainDelegate : backToMain?
    var filtredCityList : [WeatherDataModel] = []
    let weatherModel = WeatherDataModel()
    var listOfCitysInString : [String] = [""]
    var isSearching = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        listOfCitysInString = UserDefaults.standard.stringArray(forKey: "cities") ?? [String]()
        
        for object in listOfCitysInString{
            print(object)
        }


         self.navigationItem.rightBarButtonItem = self.editButtonItem
        myTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureTableview()

    }
    
    override func viewDidLayoutSubviews() {
        let jeremyGif = UIImage.gifImageWithName("lightning")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        super.view.insertSubview(imageView, at: 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
      //  myTableView.reloadData()
    }
    



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filtredCityList.count
        }
        return listOfCitysInString.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        mainDelegate?.updateUIWIthData(city: listOfCitys[indexPath.row])
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func updateUIWIthData(city: WeatherDataModel, atIndex: Int) {
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        
        let params : [String : String] = ["q" : listOfCitysInString[indexPath.row], "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params, cell : cell)

        
        
        
//        if isSearching {
//            cell.cityLabel.text = filtredCityList[indexPath.row].city
//            cell.tempLabel.text = "\(filtredCityList[indexPath.row].temperature) ℃"
//            cell.iconView.image = UIImage(named: filtredCityList[indexPath.row].updateWeatherIcon(condition: filtredCityList[indexPath.row].condition))
//        } else {
//            cell.cityLabel.text = listOfCitys[indexPath.row].city
//            cell.tempLabel.text = "\(listOfCitys[indexPath.row].temperature) ℃"
//            cell.iconView.image = UIImage(named: listOfCitys[indexPath.row].updateWeatherIcon(condition: listOfCitys[indexPath.row].condition))
//        }
//
        return cell
    }
    
    func getWeatherData(url: String, parameters: [String : String], cell : TableViewCell) {
     
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success, got the weatherdata")
                
                self.weatherJSON = JSON(response.result.value!)
                // print(self.weatherJSON)
                self.updateWeatherData(json: self.weatherJSON, cell : cell)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateWeatherData(json : JSON, cell : TableViewCell) {
        
        if let tempResult = json["main"]["temp"].double {
            weatherModel.temperature = Int(tempResult - 273.15)
            weatherModel.city = json["name"].stringValue
            weatherModel.condition = json["weather"][0]["id"].intValue
            weatherModel.weatherIconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)

            
            cell.cityLabel.text = self.weatherModel.city
            cell.tempLabel.text = String("\(self.weatherModel.temperature)" + "℃")
            cell.iconView.image = UIImage(named: self.weatherModel.weatherIconName)
            
            
            print(weatherModel.city)
            print(weatherModel.temperature)
        } else {
            print("updateweather error broski")
        }
    }
    
    
    func configureTableview(){
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 120.0
    }
    

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }


    // MARK: - Navigation

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            myTableView.reloadData()
            
        } else {
            isSearching = true
            //filtredCityList = listOfCitys.filter({$0.city == searchBar.text!})
            filtredCityList = listOfCitys.filter{$0.city.contains(searchBar.text!)}
            myTableView.reloadData()
        }
    }
 

    
    
    func userEnteredANewCityName(city: String) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
