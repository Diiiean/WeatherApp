//
//  WeatherManager.swift
//  Weather
//
//  Created by Диана Нуансенгси on 16.07.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeatherLabels(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=370868cd7bc11e288e4a02f2fbc45cb9&units=metric"
    func fetchData(cityName:String) {
        let URLString = weatherURL + "&q=\(cityName)"
        performRequest(with: URLString)
    }
    func fetchData(longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let URLString = weatherURL + "&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: URLString)
    }
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default) //thing, that can perform the networking
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {     //passing the weatherData to VC
                        self.delegate?.didUpdateWeatherLabels(self,weather: weather) //WeatherManager = "self" this current object, which is the one that triggeredthe didUpdateWeather() and it's also the one that knows all about the current weather conditions and passes over this weather object.
                    }
                }
            } //give the session a task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) ->  WeatherModel? {
        let decoder = JSONDecoder()
        do {
         let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
        let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let feels_like = decodedData.main.feels_like
            let weather = WeatherModel(conditionId: id, cityName: name,feelsLikeTemp: feels_like, temperature: temp)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
}
