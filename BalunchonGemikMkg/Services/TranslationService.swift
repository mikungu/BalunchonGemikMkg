//
//  TranslationService.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 13/01/23.
//

import Foundation

class TranslationService {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getTranslate(request : URLRequest, callback : @escaping (Bool, Translation?) -> Void){
        do {
            //We launch a task:
            //We have an instance of URLSession
            var task : URLSessionDataTask?
            
            task?.cancel()
            //we create the task with an instance of URLSessionDataTask:
            //we use a URLSession' method dataTask which takes our URLRequest type request as a parameter; and admits a second parameter(a closure with three parameters)
            task = session.dataTask(with: request) { (data, response, err) in
                DispatchQueue.main.async{
                    //we manage the response by checking that it contains the data that interests us, and that we have no error:
                    //if no data or an error is present return callback(false,nil)
                    guard let data = data else { return callback(false,nil) }
                    //if the statuscode if 200 all is ok, else return callback(false,nil)
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return callback(false,nil)}
                    
                    do {
                        //here we have data but in JSON format
                        //so we're going to decode it into a translation by using a classic Swift dictionary called JSONDecoder with decode as method (two parameters: Translation and data)
                        let translation = try JSONDecoder().decode(Translation.self, from: data)
                        callback(true, translation)
                    } catch let jsonErr {
                        // if decode failed, return an error and callback(false,nil)
                        print("Oups! Erreur de décodage!", jsonErr)
                        callback(false,nil)
                    }
                    
                }
            }
            //we launch a task after being created
            task?.resume()
        }
    }
    
    //we will create a (static) function, and inside which we will create a request for API of "googletranslate"
    public func createTranslateRequest(sentence : String) -> URLRequest {
        //We initialize an instance of URLRequest by passing it our URL as a parameter
            //We create our request
            // We use the initialization of the URL class with a String. It returns an optional that we force unpack
        var request = URLRequest(url: URL(string : "https://translation.googleapis.com/language/translate/v2?key=AIzaSyB3NVU3O1EMszpcwD43pb0Mo0MIU7TSMj0&q="+"\(sentence)"+"&target=en&format=text")!)
        //We specify the chosen HTTP method (POST ) with the httpMethod property of URLRequest
        request.httpMethod = "POST"
        return request
    }
    
}
