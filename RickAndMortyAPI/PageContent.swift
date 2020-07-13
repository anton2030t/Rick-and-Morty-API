//
//  PageContent.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

struct PageContent: Codable {
    
    var info: Info
    
    var results: [CharacterModel]
    
    struct Info: Codable {
        var count: Int
        var next: String
    }
    
}
