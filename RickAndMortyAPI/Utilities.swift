//
//  Utilities.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

let characterURL = URL(string: "https://rickandmortyapi.com/api/character/")

var characterModelDict: [Int:CharacterModel] = [:]

let cachedImages = NSCache<AnyObject, AnyObject>()

extension CharacterModel {
    
    func fetchImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let image = cachedImages.object(forKey: self.image as NSString) as? UIImage {
            completion(.success(image))
            return
        } else {
            if let imageURL = URL(string: image) {
                DispatchQueue.global(qos: .default).async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        if let image = UIImage(data: imageData) {
                            cachedImages.setObject(image, forKey: self.image as NSString)
                            DispatchQueue.main.async {
                                completion(.success(image))
                                return
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension URL {
    
    func requestContent<Content: Codable>(forCodableType codableType: Content.Type, completion: @escaping (Result<Content, Error>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let jsonData = try? Data(contentsOf: self) {
                if let requestResults = try? JSONDecoder().decode(Content.self, from: jsonData) {
                    DispatchQueue.main.async {
                        completion(.success(requestResults))
                    }
                } else {
                    print("error: json decoder")
                }
            } else {
                print("error: fetch data")
            }
        }
    }
}
