//
//  API.swift
//  tu-dien
//
//  Created by BtoW on 1/26/19.
//

import Foundation

class TranslateServices {
    
    let baseURL = "http://sdict.herokuapp.com/en-vi-"
    var dataTask: URLSessionDataTask?
    
    static var shared = TranslateServices()
    
    private init() {}
    
    func translate(_ sentences: String, completionHandler: @escaping (TranslationObject?, String) -> ()) {
        if sentences.isEmpty {
            completionHandler(nil, "Error")
        }
        
        dataTask?.cancel()
        
        var finalURL = baseURL + sentences
        finalURL = finalURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: finalURL) else {
            completionHandler(nil, "Error")
            return
        }
        
        let request = URLRequest(url: url)
        
        dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                completionHandler(nil, "error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                completionHandler(nil, "statusCode should be 200, but is \(httpStatus.statusCode)")
                return
            }
            
            // parse
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
            
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(TranslationObject.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(model, "")
                }
            }
            catch let _ {
                completionHandler(nil, "Loi decode")
            }
            
        }
        dataTask?.resume()
    }
}
