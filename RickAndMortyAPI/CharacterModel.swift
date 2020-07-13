//
//  CharacterModel.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

struct CharacterModel: Codable {
    
    var id: Int
    var name: String
    var image: String

    var status: String
    var species: String
    var gender: String

    var location: Location
    
    struct Location: Codable {
        var name: String
        var url: String
        
        func about() -> [(String, String)] {
            return [
                ("name", name),
                ("url", url)
            ]
        }
    }
    
    func about() -> [(String, String)] {
        return [
            ("status", status),
            ("species", species),
            ("gender", gender)
        ]
    }
}
