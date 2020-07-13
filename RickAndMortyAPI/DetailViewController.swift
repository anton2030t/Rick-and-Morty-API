//
//  DetailViewController.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var publicImage: UIImage?

    var characterModel: CharacterModel? {
        didSet {
            aboutCharacter = characterModel?.about()
            characterLocationDetail = characterModel?.location.about()
            
            characterModel?.fetchImage { result in
                print("fetching image detail")
                switch result {
                case .success(let image): self.characterImage = image
                print("fetched image detail")
                default: print("failed to set detail image")
                }
            }
        }
    }
    
    var characterImage: UIImage?
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var characterNameLabel: UILabel!
    
    @IBOutlet weak var characterInfoTableView: UITableView! {
        didSet {
            characterInfoTableView.dataSource = self
            characterInfoTableView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterInfoTableView.register(UINib(nibName: DetailCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: DetailCell.identifier)
        updateViewFromModel()
        
        let oopsImage = UIImage(named: "oops")!

        characterImageView.image = publicImage ?? oopsImage
    }
    
    func updateViewFromModel() {
        if let name = characterModel?.name {
            characterNameLabel.text = name
            print("inside name label: name is \(name)")
        }
        publicImage = cachedImages.object(forKey: characterModel!.image as NSString) as? UIImage
    }
    
    var aboutCharacter: [(String, String)]?
    var characterLocationDetail: [(String, String)]?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName: String
        switch section {
        case 0: sectionName = "About"
        case 1: sectionName = "Location"
        default: sectionName = ""
        }
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 2
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = characterInfoTableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath)
        if let characterDetailCell = cell as? DetailCell {
            if indexPath.section == 0 {
                if let (title, value) = aboutCharacter?[indexPath.row] {
                    characterDetailCell.titleLabel.text = title
                    characterDetailCell.contentLabel.text = value
                }
                return cell
            } else if indexPath.section == 1 {
                if let (title, value) = characterLocationDetail?[indexPath.row] {
                    characterDetailCell.titleLabel.text = title
                    characterDetailCell.contentLabel.text = value
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
