//
//  WeatherServices.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 10/01/23.
//

import Foundation

class WeatherService {
    private let weatherSession: URLSession
    private let iconSession: URLSession
    
    init(weatherSession: URLSession, iconSession: URLSession) {
        self.weatherSession = weatherSession
        self.iconSession = iconSession
    }
    
    func getWeather(request: URLRequest, callback: @escaping (Bool, Weather?) -> Void) {
        var task: URLSessionDataTask?
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, err) in
            DispatchQueue.main.async {
                guard let data = data, err == nil else { return callback(false, nil)}
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return callback(false, nil)}
                
                do {
                    let responseJSON: NSDictionary? = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                    if let jsonResult = responseJSON {
                        let array = jsonResult["weather"] as! NSArray
                        let weather = array [0] as! NSDictionary
                        let main = jsonResult["main"] as! NSDictionary
                        
                        let codeWeather: Int = weather["id"] as! Int
                        let place: String = jsonResult["name"] as! String
                        let degree = main ["temp"] as! Double
                        let icon: String = weather ["icon"] as! String
                        
                        self.getImage(icone: icon) { data2 in
                            guard let data2 = data2 else {
                                return callback(false, nil)
                            }
                            let currentWeather = Weather(place: place, codeWeather: codeWeather, degree: degree, skyImage: data2)
                            
                            return callback(true, currentWeather)
                        }
                    }
                } catch let jsonErr {
                    
                    print("Erreur de décodage", jsonErr)
                    return callback(false, nil)
                }
            }
        }
        task?.resume()
    }
    
    func getImage(icone : String, completionHandler: @escaping (Data?)-> Void){
       let request = createIconRequest(icone: icone)
       
       var task : URLSessionDataTask?
       
       task?.cancel()
       task = iconSession.dataTask(with: request) { data, response, error in
           DispatchQueue.main.async{
               
               guard let data = data , error == nil else {
                   completionHandler(nil)
                   return
               }
               
               guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                   completionHandler(nil)
                   return
               }

               completionHandler(data)
           }
       }
       task?.resume()
   }
    public func createRequestWeather(city : String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=7559963d904acf8d9f2def0e3f053a79&units=metric")!)
        request.httpMethod = "POST"
        return request
    }
    
    // create a request for GET the icone
    public func createIconRequest(icone : String) -> URLRequest{
        var request = URLRequest(url: URL(string: "http://openweathermap.org/img/wn/\(icone)@2x.png")!)
        request.httpMethod = "GET"
        return request
    }}
