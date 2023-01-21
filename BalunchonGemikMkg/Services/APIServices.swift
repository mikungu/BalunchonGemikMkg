//
//  APIServices.swift
//  BalunchonGemikMkg
//
//  Created by Mikungu Giresse on 20/01/23.
//

import Foundation




enum APIError: Error {
    case url
    case responseCode
    case invalidData
    case parsing
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

final class APIService {
    // MARK: - Property
    
    private let session: URLSession
    
    // MARK: - Lifecyle
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Accessible

    func makeCall<T: Decodable>(
        urlString: String,
        method: HTTPMethod,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.url))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = self.session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let response = response, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(APIError.responseCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            do {
                // Parsing
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(APIError.parsing))
            }
        })

        task.resume()
    }
}

final class WeatherModel {
    // MARK: - Property
    
    private let apiService = APIService()
    
    // MARK: - Accessible
    
    func getWeather(city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=7559963d904acf8d9f2def0e3f053a79&units=metric"
        let method: HTTPMethod = .post
        
        let callback: (Result<Weather, Error>) -> Void = { result in
            switch result {
            case .success(let model):
                print("\(model.city)")
            case .failure(let error):
                switch error as? APIError {
                case .url: break
                case .parsing: break
                case .responseCode: break
                default: break
                }
            }
        }

        self.apiService.makeCall(urlString: url, method: method, completion: callback)
    }
    
    func getImage(icon: String) {
        let url = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        let method: HTTPMethod = .get
        
        let callback: (Result<Weather, Error>) -> Void = { result in
            switch result {
            case .success(let model):
                print("\(model.skyImage)")
            case .failure(let error):
                switch error as? APIError {
                case .url: break
                case .parsing: break
                case .responseCode: break
                default: break
                }
            }
        }

        self.apiService.makeCall(urlString: url, method: method, completion: callback)
    }
}

// DollarModel
final class DollarModel {
    // MARK: - Property
    
    private let apiService = APIService()
    
    // MARK: - Accessible
    
    func getDollar() {
        let url = "http://data.fixer.io/api/latest?access_key=94566f6059ecbdc8361e202d0cebb6c4"
        let method: HTTPMethod = .post
        
        let callback: (Result<Dollar, Error>) -> Void = { result in
            
            switch result {
            case .success(let model):
                print ("\(model.rates)")
            case .failure(let error):
                switch error as? APIError {
                case .url: break
                case .parsing: break
                case .responseCode: break
                default: break
                }
            }
        }
        
        self.apiService.makeCall(urlString: url, method: method, completion: callback)
    }
}
    final class TranslationModel {
        
        private let apiService = APIService()
        
        
        func getTranslation(sentence: String) {
            let url = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyB3NVU3O1EMszpcwD43pb0Mo0MIU7TSMj0&q="+"\(sentence)"+"&target=en&format=text"
            let method: HTTPMethod = .post
            
            let callback: (Result<Translation, Error>) -> Void = { result in
                switch result {
                case .success(let model):
                    print ("\(model)")
                case .failure(let error):
                    switch error as? APIError {
                    case .url: break
                    case .parsing: break
                    case .responseCode: break
                    default: break
                    }
                }
            }
            
            self.apiService.makeCall(urlString: url, method: method, completion: callback)
        }
        
    }

