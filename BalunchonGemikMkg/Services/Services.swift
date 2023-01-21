//
//  Services.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 17/01/23.
//

import Foundation

class Services {
   
    //MARK: -Accessibles
    // create a request for the api "fixer"
    func getWeather(request: URLRequest, callback: @escaping (Bool, Weather?) -> Void) {
        let weatherSession = URLSession (configuration: .default)
        var task: URLSessionDataTask?
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
            guard let data = data, error == nil else {
                callback(false, nil)
                return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { callback (false, nil)
                return }
            
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
                            return callback (false,nil)
                        }
                        let currentWeather = Weather(city: place, id: codeWeather, degree: degree, skyImage: data2)
                        
                        return callback (true, currentWeather)
                    }
                    // let dollar = try JSONDecoder().decode(Dollar.self, from: data)
                    
                    self.getDollar { (data) in
                        guard let dataDollar = data else {
                            
                            return
                        }
                        let dollarRate = Dollar.self
                        print (dataDollar)
                        
                    }
                    
                    self.getTranslation(request: request) { (data) in
                        guard let dataTranslation = data else {
                            
                            return
                        }
                        let translation = Translation.self
                        print (dataTranslation)
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
        let iconSession = URLSession(configuration: .default)
        var task : URLSessionDataTask?
        
        //task?.cancel()
        task = iconSession.dataTask(with: request) { data, response, error in
            //DispatchQueue.main.async{
            
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
        // }
        task?.resume()
    }
    
    func getDollar(completionHandler : @escaping (Data?) -> Void) {
        
        
        // do {
        let sessionDollar = URLSession (configuration: .default)
        let request = createDollarRequest()
        var task : URLSessionDataTask?
        
        // task?.cancel()
        task = sessionDollar.dataTask(with: request) { (data, response, error) in
            //DispatchQueue.main.async{
            // if no data or an error is present return callback(false,nil)
            guard let data = data, error == nil else {
                completionHandler(nil)
                return  }
            
            // if the statuscode if 200 all is ok, else return callback(false,nil)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        // }
        task?.resume()
        //}
    }
    
    //we will create a (static) function, and inside which we will create a request for API of "googletranslate"
    func getTranslation(request: URLRequest, completionHandler: @escaping (Data?) -> Void) {
        
        // do {
        //We launch a task:
        //We have an instance of URLSession
        //let request = createTranslateRequest(sentence: sentence)
        let sessionTranslation = URLSession(configuration: .default)
        var task : URLSessionDataTask?
        
        //task?.cancel()
        //we create the task with an instance of URLSessionDataTask:
        //we use a URLSession' method dataTask which takes our URLRequest type request as a parameter; and admits a second parameter(a closure with three parameters)
        task = sessionTranslation.dataTask(with: request) { (data, response, error) in
            //DispatchQueue.main.async{
            //we manage the response by checking that it contains the data that interests us, and that we have no error:
            //if no data or an error is present return callback(false,nil)
            guard let data = data else {
                completionHandler(nil)
                return
            }
            //if the statuscode if 200 all is ok, else return callback(false,nil)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            
        }
        //}
        //we launch a task after being created
        task?.resume()
        //}
    }
    
    
    //MARK: -Publics
    public func createWeatherRequest(city: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=7559963d904acf8d9f2def0e3f053a79&units=metric")!)
        request.httpMethod = "POST"
        return request
    }
    
    public func createIconRequest (icone: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "http://openweathermap.org/img/wn/\(icone)@2x.png")!)
        request.httpMethod = "GET"
        return request
    }
    
    public func createTranslateRequest (sentence : String) -> URLRequest {
        //We initialize an instance of URLRequest by passing it our URL as a parameter
        //We create our request
        // We use the initialization of the URL class with a String. It returns an optional that we force unpack
        var request = URLRequest(url: URL(string : "https://translation.googleapis.com/language/translate/v2?key=AIzaSyB3NVU3O1EMszpcwD43pb0Mo0MIU7TSMj0&q="+"\(sentence)"+"&target=en&format=text")!)
        //We specify the chosen HTTP method (POST ) with the httpMethod property of URLRequest
        request.httpMethod = "POST"
        return request
    }
    //MARK: Private
    private func createDollarRequest () -> URLRequest {
        var request = URLRequest(url: URL(string: "http://data.fixer.io/api/latest?access_key=94566f6059ecbdc8361e202d0cebb6c4")!)
        request.httpMethod = "POST"
        return request
    }
}
