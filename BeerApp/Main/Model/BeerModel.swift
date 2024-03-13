//
//  BeerCell.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

struct Beer: Codable {
    let id: Int
    let name: String
    let description: String
    let imageURL: String
    let abv: Double
    let firstBrewed: String
    let foodPairing: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
        case abv
        case foodPairing = "food_pairing"
        case firstBrewed = "first_brewed"
        
    }
}
