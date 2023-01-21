//
//  WeatherViewController.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var imageNYWeather: UIImageView!
    
    @IBOutlet weak var descriptionNYLabel: UILabel!
    
    @IBOutlet weak var temperatureNYLabel: UILabel!
    
    
    @IBOutlet weak var temperatureRoma: UILabel!
    
    @IBOutlet weak var descriptionRoma: UILabel!
    
    
    @IBOutlet weak var imageRMWeather: UIImageView!
    
    
    let weather = WeatherModel()
    //MARK: -Override
    override func viewDidLoad() {
        
        weather.getWeather (city: "New+York") { (succes, weather) in
            if succes, let weather = weather {
                self.descriptionNYLabel.text = weather.descriptionConditions(id: weather.id)
                self.temperatureNYLabel.text = "Il fait\(String(weather.degree))°C"
                self.imageNYWeather.image = UIImage(data: weather.skyImage)
            }
            else {
                self.presentAlert(with: "Oups! Echec de requête")
            }
        }
        
        weather.getWeather(city: "Roma") {
            succes, weather in
            if succes, let weather = weather {
                self.descriptionRoma.text = weather.descriptionConditions(id: weather.id)
                self.temperatureRoma.text = "Il fait \(String(weather.degree))°C"
                self.imageRMWeather.image = UIImage(data: weather.skyImage)
            }
            else {
                self.presentAlert(with: "Oups! Echec de requête")
            }
        }
    }
    
}
//MARK: -Extension 
extension WeatherViewController {
    
    private func presentAlert(with error: String){
        let alertVC = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
