//
//  ApiManager.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

    //MARK: Protocol for api manager

protocol ApiManagerProtocol {
    func fetchUrl(page: Int?, nameBeer: String?) -> URL?}

class ApiManager: ApiManagerProtocol {
    
    //MARK: Properties
    
    private let defaultParPage = 20
    
    //MARK: Functions
    
    func fetchUrl(page: Int?, nameBeer: String?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.punkapi.com"
        urlComponents.path = "/v2/beers"
        if let nameBeer {
            guard var urlString = urlComponents.url?.absoluteString else { return nil }
            urlString.append("?beer_name=\(nameBeer)")
            return URL(string: urlString)
        }
        guard let page = page else {return nil}
        let pageQuery = URLQueryItem(name: "page", value: "\(page)")
        let parPage = URLQueryItem(name: "per_page", value: "\(defaultParPage)")
        urlComponents.queryItems = [pageQuery, parPage]
        return urlComponents.url
    }
}
