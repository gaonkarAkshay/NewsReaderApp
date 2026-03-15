//
//  ApiHelper.swift
//  News Reader App
//
//  Created by Akshay  Ashok Gaonkar on 14/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}

struct Constants {
    struct API {
        static let baseURL = "https://newsapi.org/v2"
        static let apiKey = "81c9ca31ccab4aaa969c5c59ca253260"
    }
}

class ApiHelper {
    static let shared = ApiHelper()
    private init() {}
    
    func request<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
