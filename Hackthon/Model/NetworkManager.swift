//
//  NetworkManager.swift
//  Hackthon
//
//  Created by Dayson Dong on 2022-02-12.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func uploadImage(_ data: Data, longtitude: Double, latitude: Double, completion: @escaping ([String: Any]) -> Void) {
        print("uploading")
        print(data.description)
        
        
        let encodedImageData = data.base64EncodedString()
        
        let url = URL(string:"https://sustainability-2022-hacks.herokuapp.com/predict/")

        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["file" : encodedImageData,
                      "long": longtitude,
                      "lat" : latitude] as [String : Any]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        request.httpMethod = "POST"
        request.httpBody = bodyData

        
        let session = URLSession.shared
        
        _ = session.dataTask(with: request) { data, res, error in
            guard error == nil else {
                print("error " + error!.localizedDescription)
                completion(["": ""])
                return
            }
            
            guard let data = data else {
                print("no data found")
                completion(["": ""])
                return
            }
            let datastr = String(data: data, encoding: .utf8)
            
            print("got response and data is .... \(data.description) \(datastr)")
            
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    completion(["": ""])
                    return
                }
                
                guard let prediction = jsonObject["prediction"] as? [String : Any], let category = jsonObject["category"] as? [String: Any] else {
                    print("error parsing data")
                    completion(["": ""])
                    return
                }
                
                print("\(prediction["label"]) + \(prediction["prob"])")
   
            } catch {
                print("Error: Trying to convert JSON data to string")
                completion(["": ""])
                return
            }
            
            completion(["": ""])
 
        }.resume()

        
    }
    
    

    
}
