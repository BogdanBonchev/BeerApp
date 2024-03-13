//
//  BeerPresenter.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

    //MARK: Protocol for presenter

protocol BeerPresenterProtocol{
    func fetchBeer(page: Int)
    func fetchBeerSearch(nameBeer: String)
}

    //MARK: Protocol delegate

protocol BeerPresenterDelegate: AnyObject {
    func takeTheBeers(beersArray: [Beer])
    func takeTheResponce(error: NetworkError)
    func takeBeersSearch(beersArray:[Beer])
}

class BeerPresenter: BeerPresenterProtocol {
    
    //MARK: Properties
    
    weak var delegate: BeerPresenterDelegate?
    private var apiManager: ApiManagerProtocol
    private var networkManager: NetworkManagerProtocol
    
    //MARK: Initianal
    
    init(apiManager: ApiManagerProtocol, networkManager: NetworkManagerProtocol) {
        self.apiManager = apiManager
        self.networkManager = networkManager
    }
    
    //MARK: Functions
    
    func fetchBeer(page: Int){
        guard let url = apiManager.fetchUrl(page: page, nameBeer: nil) else { return }
        print(url)
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                let beers = try? JSONDecoder().decode([Beer].self, from: data)
                guard var beersSorted = beers else { return }
//                DispatchQueue.main.async {
                    beersSorted = beers!.sorted{ $0.name < $1.name }
                    self.delegate?.takeTheBeers(beersArray: beersSorted)
//                }
            case .failure(let error):
                self.delegate?.takeTheResponce(error: .unknown(error.localizedDescription))
            }
        }
    }
    
    func fetchBeerSearch(nameBeer: String) {
        guard let url = apiManager.fetchUrl(page: nil, nameBeer: nameBeer) else { return }
        print(url)
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                let beers = try? JSONDecoder().decode([Beer].self, from: data)
                guard let beerSearch = beers else { return }
                DispatchQueue.main.async {
                    self.delegate?.takeBeersSearch(beersArray: beerSearch)
                }
            case .failure(let error):
                self.delegate?.takeTheResponce(error: .unknown(error.localizedDescription))
            }
        }
    }
}
