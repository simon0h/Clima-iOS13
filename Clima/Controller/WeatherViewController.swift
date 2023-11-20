//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    //UITextFieldDelegate is a protocol
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        print(1)
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        print(2)
        searchTextField.endEditing(true) //Text field is done editing
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //Method from UITextFieldDelegate (aka delegate method)
        print(3)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(4)
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Please enter a city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { //Method from UITextFieldDelegate (aka delegate method)
        print(5)
        //Called after endEditing function is called
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = " "
    }
    
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        print(6)
        print(weather)
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(format: "%.0f", weather.temp)
            self.conditionImageView.image = UIImage(systemName: weather.condition)
            self.cityLabel.text = weather.cityName
        }
    }
    
}
