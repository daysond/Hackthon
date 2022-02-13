//
//  NetworkManager.swift
//  Hackthon
//
//  Created by Dayson Dong on 2022-02-12.
//

import Foundation
import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String : Any]?, media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let parameters = params {
          for (key, value) in parameters {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
             body.append("\(value as! String + lineBreak)")
          }
       }
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
             body.append(photo.data)
             body.append(lineBreak)
          }
       }
       body.append("--\(boundary)--\(lineBreak)")
       return body
    }
    
    func uploadImageToServer(_ image :UIImage, lat: String, long: String, callback: @escaping () -> Void) {
        let parameters = ["lat": lat,
                          "long": long]
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        guard let url = URL(string:"https://sustainability-2022-hacks.herokuapp.com/predict/")else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            callback()
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else{
                        return
                    }
                    
                    guard let prediction = json["prediction"] as? [String : Any], let category = json["category"] as? [String: Any] else {
                        print("error parsing data")
                        
                        return
                    }
                    
                    print("\(prediction["label"]) + \(prediction["prob"])")
                    
                    
//                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
