//
//  WeatherData.swift
//  Clima
//
//  Created by Simon Oh on 11/20/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable { //Codable is a typealias
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let desciption: String
    let id: Int
}
