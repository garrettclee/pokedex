//
//  PokeCell.swift
//  Pokedex
//
//  Created by Garrett Lee on 12/26/16.
//  Copyright © 2016 CSG2. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
    //Creates rounded corners on the PokeCells
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    //When passed in a pokemon, it makes the cells picture the ID, and the label its name
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbImage.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }
    
    
}
