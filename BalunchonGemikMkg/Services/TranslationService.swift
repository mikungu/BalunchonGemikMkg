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
            var task : URLSessionDataTask?
            
            task?.cancel()
            task = session.dataTask(with: request) { (data, response, err) in
                DispatchQueue.main.async{
                    // if no data or an error is present return callback(false,nil)
                    guard let data = data else { return callback(false,nil) }
                    // if the statuscode if 200 all is ok, else return callback(false,nil)
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return callback(false,nil)}
                    
                    do {
                        // here we have data, so we try to decode into a translation
                        let translation = try JSONDecoder().decode(Translation.self, from: data)
                        callback(true, translation)
                    } catch let jsonErr {
                        // if decode failed, return an error and callback(false,nil)
                        print("Oups! Erreur de décodage!", jsonErr)
                        callback(false,nil)
                    }
                    
                }
            }
            task?.resume()
        }
    }
    
    // create a request for the api "googleTranslate"
    public func createTranslateRequest(sentence : String) -> URLRequest {
        var request = URLRequest(url: URL(string : "https://translation.googleapis.com/language/translate/v2?key=AIzaSyB3NVU3O1EMszpcwD43pb0Mo0MIU7TSMj0&q="+"\(sentence)"+"&target=en&format=text")!)
        request.httpMethod = "POST"
        return request
    }
    
}
