//
//  NetworkManager.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

    //MARK: Typealias for error

enum NetworkError: Error {
    case isFailedUrl
    case noData
    case unknown(String)
}

    //MARK: Protocol for network manager

protocol NetworkManagerProtocol {
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    //MARK: Functions
    
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                return completion(.failure(.noData))
            }
            completion(.success(data))
            guard let error else { return }
            completion(.failure(.unknown(error.localizedDescription)))
        }.resume()
    }
}
