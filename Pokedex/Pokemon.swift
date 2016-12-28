//
//  Pokemon.swift
//  Pokedex
//
//  Created by Garrett Lee on 12/26/16.
//  Copyright © 2016 CSG2. All rights reserved.
//

import Foundation
import Alamofire


//Creating the pokemon class with a name and a pokedexID
class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    private var _nextEvolutionID: String!
    
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var attack: String {
        if _attack ==  nil{
            _attack = ""
        }
        return _attack
    }
    
    var defense: String {
        if _defense ==  nil{
            _defense = ""
        }
        return _defense
    }
    
    var weight: String {
        if _weight ==  nil{
            _weight = ""
        }
        return _weight
    }

    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = "No new evolution"
        }
        return _nextEvolutionText
    }
    
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        
        self._pokemonURL = "\(URL_BASE)\(self.pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON{response in
            if let value = response.result.value as? Dictionary<String, AnyObject> {
                //Supposed to do all of these in if lets
                self._attack = "\(value["attack"]!)" as String!
                self._defense = "\(value["defense"]!)" as String!
                self._height = value["height"] as! String!
                self._weight = value["weight"] as! String!
                if let types = value["types"] as? [Dictionary<String, AnyObject>] {
                    if let pokeType = types[0]["name"] as? String {
                        self._type = pokeType
                    }
                }
                
                if let evolutions = value["evolutions"] as? [Dictionary<String, AnyObject>] {
                    if let evolution = evolutions[0]["to"] as? String {
                        self._nextEvolutionText = "Next Evolution: \(evolution)"
                    }
                }
                
                if let descriptions = value["descriptions"] as? [Dictionary<String, AnyObject>] {
                    let descriptionURL = "http://pokeapi.co\(descriptions[0]["resource_uri"]!)"
                    Alamofire.request(descriptionURL).responseJSON{response2 in
                        if let descriptionValue = response2.result.value as? Dictionary<String, AnyObject> {
                            self._description = descriptionValue["description"] as! String!
                        }
                        completed()
                    }
                }
                
            }
            completed()
        }
    }
}
