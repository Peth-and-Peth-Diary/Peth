//
//  PostController.swift
//  Peth
//
//  Created by masbek mbp-m2 on 08/08/23.
//

import Foundation
import SwiftUI

struct Posts: Codable {
    let id: Int
    let username: String
    let post: String
}

struct PostsResponse: Codable {
    let success: Bool
    let message: String
    let data: [Posts]
}

func getPosts(completion: @escaping (Result<[Posts], Error>) -> Void) {
    let url = URL(string: "http://192.168.18.58:8000/api/post")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "Response Data Error", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(PostsResponse.self, from: data)
            completion(.success(response.data))
            
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


func storePost(authID: String, post: NSAttributedString) async
{
    let url = URL(string: "http://192.168.18.58:8000/api/post")!
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Create the data to send
    let postData: [String: Any] = ["auth_id": authID, "post": post.string] // Convert NSAttributedString to plain string
    let jsonData = try! JSONSerialization.data(withJSONObject: postData)
    
    // Attach the data to the request
    request.httpBody = jsonData
    
    
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


