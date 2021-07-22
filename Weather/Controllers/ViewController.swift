//
//  ViewController.swift
//  Weather
//
//  Created by Диана Нуансенгси on 14.07.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager() //responsible for getting hold of the current GPS location of the phone.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation() //equests the one-time delivery of the user’s current location.
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type in something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchData(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateWeatherLabels(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.feelsLikeLabel.text = "Feels like " + weather.feelsLikeTempString
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: CLLocationManagerDelegate 
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchData(longitude: lon, latitude: lat)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
