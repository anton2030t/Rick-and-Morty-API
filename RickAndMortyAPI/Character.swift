//
//  Character.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import Foundation

struct Character: Codable {
        
    var characterModel: CharacterModel
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(characterModel: CharacterModel) {
        self.characterModel = characterModel
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Character.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
