//
//  CharacterCell.swift
//  RickAndMortyAPI
//
//  Created by Anton Larchenko on 13.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "CharacterCell"

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.backgroundColor = .systemGroupedBackground
        characterImageView.image = nil
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
