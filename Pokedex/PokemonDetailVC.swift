//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Garrett Lee on 12/26/16.
//  Copyright © 2016 CSG2. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalized
        pokedexLabel.text = "\(pokemon.pokedexID)"
        mainImage.image = UIImage(named: "\(pokemon.pokedexID)")
        currentEvoImage.image = UIImage(named: "\(pokemon.pokedexID)")
        
        pokemon.downloadPokemonDetails {
            
            //Whatever we write here will only be called after the network call is complete
            self.updateUI()
            
        }
        
    }
    
    func updateUI() {
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type.capitalized
        descriptionLabel.text = pokemon.description
        evoLabel.text = pokemon.nextEvolutionText
        nextEvoImage.image = UIImage(named: "\(pokemon.nextEvolutionText)")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }

}
