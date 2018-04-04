//
//  ChangeCityController.swift
//  Isitraining
//
//  Created by Robin kamo on 2018-03-22.
//  Copyright © 2018 Robin kamo. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}

class ChangeCityController: UIViewController {
    
    
    var delegate : ChangeCityDelegate?
    
    
    @IBOutlet weak var changeCityField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        let jeremyGif = UIImage.gifImageWithName("rainygif")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        super.view.insertSubview(imageView, at: 0)
        
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
     
        
        let cityName = changeCityField.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
