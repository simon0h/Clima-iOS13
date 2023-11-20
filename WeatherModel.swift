//
//  WeatherModel.swift
//  Clima
//
//  Created by Simon Oh on 11/20/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID : Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
       return String(format: "%.1f", temperature)
   }
    
    var conditionName: String { // Computed property
        switch conditionID {
        case 200...299:
            return "cloud.bolt.rain.fill"
        case 300...399:
            return "cloud.drizzle.fill"
        case 500...600:
            return "cloud.heavyrain.fill"
        default:
            return "sun.max.fill"
        }
    }
}
