//
//  WeatherManager.swift
//  Clima
//
//  Created by Simon Oh on 11/20/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4fea262c55d0768ac502d29194a65e1f&units=imperial&"
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let urlString = weatherURL + "q=" + cityName
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in //Closure
                if (error != nil) {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionID: 1, cityName: "Austin", temperature: 10.1)
            return weather
        }
        catch {
            print(error)
            return nil
        }
    }
}
