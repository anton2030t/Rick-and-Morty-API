//
//  ViewController.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var characterTableView: UITableView!
    
    var characterCount: Int? {
        didSet {
            DispatchQueue.main.async {
                self.characterTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterTableView.register(UINib(nibName: CharacterCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: CharacterCell.identifier)
        if characterCount == nil {
            fetchCharacterCount()
        }
    }
    
    private func fetchCharacterCount() {
        if let url = characterURL {
            DispatchQueue.global(qos: .default).async { [weak self] in
                if let jsonData = try? Data(contentsOf: url) {
                    if let pagination = try? JSONDecoder().decode(PageContent.self, from: jsonData) {
                        self?.characterCount = pagination.info.count
                    }
                }
            }
        }
    }
    
    func loadCharacterModel(fromURL url: URL, completion: @escaping () -> Void ) {
        url.requestContent(forCodableType: CharacterModel.self) { result in
            switch result {
            case .success(let pageContent): characterModelDict[pageContent.id] = pageContent
            completion()
            default: print("character info unavailable")
            }
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath)
        
        if let characterCell = cell as? CharacterCell {
            if characterModelDict[indexPath.row + 1] == nil {
                if let url = characterURL?.appendingPathComponent(String(indexPath.row + 1)) {
                    loadCharacterModel(fromURL: url) {
                        tableView.reloadData()
                    }
                }
            } else {
                if let characterModel = characterModelDict[indexPath.row + 1] {
                    characterCell.nameLabel.text = characterModel.name
                    if let image = cachedImages.object(forKey: characterModel.image as NSString) as? UIImage {
                        characterCell.characterImageView.image = image
                    }
                    else {
                        characterModel.fetchImage { result in
                            switch result {
                            case .success(_):
                                tableView.reloadData()
                            default:
                                print("error fetching image for row \(indexPath.row)")
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = sender as? IndexPath {
                if let dvc = segue.destination as? DetailViewController {
                    dvc.characterModel = characterModelDict[indexPath.item + 1]
                }
            }
        }
    }
    
}
