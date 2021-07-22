//
//  WeatherData.swift
//  Weather
//
//  Created by Диана Нуансенгси on 17.07.2021.
//

import Foundation
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}
struct Weather: Decodable {
    let id: Int
}
