//
//  StoreAuthData.swift
//  Peth
//
//  Created by masbek mbp-m2 on 08/08/23.
//

import Foundation


enum AuthData {
    static var username = ""
    
    func setValue(_ newValue: String)
    {
        AuthData.username = newValue
    }
}

func storeAuth(authID: String, username: String) async
{
    let url = URL(string: "https://peth.masbek.my.id/api/pengguna")!
//    let interests = interests
    let authData = ["auth_id": authID, "username": username]
    let bodyData = try! JSONEncoder().encode(authData)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = bodyData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        print(response)
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//
//        guard let data = data else {
//            completion(.failure(NSError(domain: "Response Data Error", code: 0, userInfo: nil)))
//            return
//        }
        
//        do {
//            let decoder = JSONDecoder()
////            let response = try decoder.decode(PlaceListResponse.self, from: data)
//            completion(.success(response))
//
//        } catch {
//            completion(.failure(error))
//        }
    }.resume()

}


