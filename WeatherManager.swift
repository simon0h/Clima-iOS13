//
//  WeatherManager.swift
//  Clima
//
//  Created by Simon Oh on 11/20/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let geocodingURL = "https://api.openweathermap.org/geo/1.0/direct?q="
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    let APIKey = "4fea262c55d0768ac502d29194a65e1f"
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        var urlString = geocodingURL + cityName + "&appid=" + APIKey
        getLatAndLon(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=imperial&"
        performRequest(with: urlString)
    }
    
    func getLatAndLon(with URLString: String) {
        if let URL = URL(string: URLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { (data, response, error) in //Closure
                if (error != nil) {
                    print("Error with getting latitude and longitude: ", error!)
                    return
                }
                if let safeData = data {
                    let latAndLon = self.parseLocJSON(safeData)
                    fetchWeather(latitude: latAndLon.0, longitude: latAndLon.1)
                    return
                }
            }
            task.resume()
        }
    }

    func performRequest(with URLString: String) {
        if let URL = URL(string: URLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { (data, response, error) in //Closure
                if (error != nil) {
                    print("Error with getting temperature: ", error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseWeatherJSON(safeData) {
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseLocJSON(_ weatherData: Data) -> (Double, Double) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([LatAndLon].self, from: weatherData)
            let lat = decodedData[0].lat
            let lon = decodedData[0].lon
            return (lat, lon)
        }
        catch {
            print("Error with parsing lat and lon JSON: ", error)
            return (0.0, 0.0)
        }
    }

    func parseWeatherJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temperature)
            return weather
        }
        catch {
            print("Error with parsing temp JSON: ", error)
            return nil
        }
    }
}
