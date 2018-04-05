//
//  CompareCityController.swift
//  Isitraining
//
//  Created by Robin kamo on 2018-04-05.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit
import GraphKit

class CompareCityController: UIViewController, GKBarGraphDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    
    @IBOutlet weak var firstPicker: UIPickerView!
    @IBOutlet weak var graph: GKBarGraph!
    @IBOutlet weak var graph2: GKBarGraph!
    @IBOutlet weak var secondPicker: UIPickerView!
    let userDefaults = UserDefaults.standard
    var favCitys : [String] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        favCitys = userDefaults.stringArray(forKey: "cities") ?? [String]()
        print("\(favCitys)")
        firstPicker.dataSource = self
        firstPicker.delegate = self
        secondPicker.delegate = self
        secondPicker.dataSource = self
        graph.dataSource = self
        graph2.dataSource = self
        graph2.draw()
        graph.draw()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func comparePressed(_ sender: Any) {
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){
        let city1 = favCitys[firstPicker.selectedRow(inComponent: 0)]
        let city2 = favCitys[secondPicker.selectedRow(inComponent: 0)]
        print("your citys are \(city1), \(city2)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfBars() -> Int {
        return 3
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        return index * 10 as NSNumber
    }
    
    func titleForBar(at index: Int) -> String! {
        return "\(index)"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return favCitys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return favCitys[row]
    }

}
