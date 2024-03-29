//
//  NetworkManager.swift
//  GoContacts
//
//  Created by Nitin Joshi on 20/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

public typealias NetworkCompletionWithArray<T: Codable> = (_ ContactsList: [T]?,_ error: String?)->()
public typealias NetworkCompletion<T: Codable> = (_ Contact: T?,_ error: String?)->()

public class NetworkManager {
    
    public init () {
        
    }
    
    public func GetArrayData<T: Codable> (urlPath: String, decodingType: T.Type, completion: @escaping NetworkCompletionWithArray<T>) {
        self.GetData(urlPath: urlPath, completion: { (data, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }

            guard let responseData = data else {
                completion(nil, NetworkResponse.noData.rawValue)
                return
            }

            do {
                let jsonReponse = try JSONDecoder().decode([T].self, from: responseData)
                completion(jsonReponse, nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        })
    }

    public func GetData<T: Codable> (urlPath: String, decodingType: T.Type, completion: @escaping NetworkCompletion<T>) {
        self.GetData(urlPath: urlPath, completion: { (data, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                completion(nil, NetworkResponse.noData.rawValue)
                return
            }
            
            do {
                let jsonReponse = try JSONDecoder().decode(T.self, from: responseData)
                completion(jsonReponse, nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        })
    }
    
    private func GetData (urlPath: String, completion: @escaping (_ data: Data?,_ error: String?)->()) {
        let session = URLSession.shared
        let url = URL(string: urlPath)!
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connetion!")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, "Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                completion(nil, "Wrong MIME type!")
                return
            }
            
            let result = self.handleNetworkResponse(response)
            switch(result) {
            case .success :
                completion(data, nil)
            case .failure(let networkFailureError) :
                completion(nil, networkFailureError)
            }
        }
        
        task.resume()
    }
    
    func CreateData (urlPath: String, uploadData: Data) {
        let url = URL(string: urlPath)!
        
        //create request with url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        UploadData(request: request, data: uploadData)
    }
    
    func UpdateData (urlPath: String, uploadData: Data) {
        let url = URL(string: urlPath)!
        
        //create request with url
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        UploadData(request: request, data: uploadData)
    }

    private func UploadData (request: URLRequest, data: Data) {
        let session = URLSession.shared

        //upload json data
        let task = session.uploadTask(with: request, from: data) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                    print ("server error")
                    return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let result = self.handleNetworkResponse(response)
            switch(result) {
            case .success :
                if let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("data respone: \(dataString)")
                }
            case .failure(let networkFailureError) :
                print(networkFailureError+" : ")
                print("\(response.statusCode) : \(response.description)")
            }
        }
        task.resume()

    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
