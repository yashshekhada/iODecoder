//
//  ClS.swift
//  iODecoder
//
//  Created by INFINITY INFOWAY PVT.LTD. on 10/10/19.
//  Copyright © 2019 JdeviO. All rights reserved.
//

import Foundation
class ClSApi {
   
  
    public static func GetJsonModelByString<T: Decodable>( completion: @escaping (T) -> (),BaseUrl: String,ApiName: String, Prams: String)
    {
        let url = URL(string: BaseUrl+ApiName)!
                     var request = URLRequest(url: url)
                     
                     request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                     request.httpMethod = "POST"
                     let Api_action:String=Prams
                     
                     let postString = Api_action;
//                       print("SendPanicCallMessage" +  ClS.baseUrl+ClS.SendPanicCallMessageTag+"?"+postString)
                     request.httpBody = postString.data(using: .utf8)
                     let task = URLSession.shared.dataTask(with: request) { data, response, error in

                         guard let data = data else {
                             print("Error: No data to decode")
                             return
                         }
                        
//                        let myStruct = try? decodableTypes.init(jsonData: data) {
//                        print(myStruct)
                       print("SendPanicCallMessage Responce string "+String(decoding: data, as: UTF8.self))
                        guard let blog = try? JSONDecoder().decode(T.self, from: data) else {
                             print("Errors: Couldn't decode data into Blog")
                             return
                         }
                        completion(blog)

                     }
                     task.resume()
 
    }
    
    public static func GetJsonModelByDictionary<T: Decodable>( completion: @escaping (T) -> (),BaseUrl: String,ApiName: String, Prams: [String: Any]) {

          

          let url = URL(string: BaseUrl+ApiName)!

          var request = URLRequest(url: url)

          var params = Prams

          

          request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")


          request.httpMethod = "POST"

     
          request.httpBody = params.percentEscaped().data(using: .utf8)

          //print("SendPanicCallMessage Url string  \(params.percentEscaped())")

          let task = URLSession.shared.dataTask(with: request) { data, response, error in

              

              guard let data = data else {

                  print("Error: No data to decode")

                  return

              }


              guard let blog = try? JSONDecoder().decode(T.self, from: data) else {

                  print("Errors: Couldn't decode data into Blog")

                  return

              }

              completion(blog)

          }

          task.resume()

      }
}

    
extension Dictionary {
        func percentEscaped() -> String {
            return map { (key, value) in
                let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
        }
    }

    
extension CharacterSet {
        static let urlQueryValueAllowed: CharacterSet = {
            let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
            let subDelimitersToEncode = "!$&'()*+,;="

            var allowed = CharacterSet.urlQueryAllowed
            allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
            return allowed
        }()
    }

