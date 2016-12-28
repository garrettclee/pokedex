//
//  ViewController.swift
//  Pokedex
//
//  Created by Garrett Lee on 12/26/16.
//  Copyright © 2016 CSG2. All rights reserved.
//

import UIKit
//When working with Audio
import AVFoundation


//Implementing new protocols for our UICollectionView
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    //Connecting the CollectionView
    @IBOutlet weak var collection: UICollectionView!
    //Instatiate an empty array of pokemans
    var pokemon = [Pokemon]()
    //Creating an audio player
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Have to have these to make delegate and dataSource work
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        //Puts all the pokemon in the array above
        parsePokemonCSV()
        print(self.pokemon[0].name)
        
        //Starts playing music when loading
        initAudio()
    }
    
    //Gets the music ready for playing ;)
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            
        }catch let err as NSError{
            print(err)
        }
        
    }
    
    func parsePokemonCSV(){
        //Tells us where our Pokeman data is at
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //do-catch here to be safe
        do {
            //run the CSV function given to us to parse this data
            let csv = try CSV(contentsOfURL: path)
            //grab the individual rows (each containing a pokeman's information)
            let rows = csv.rows
            
            //For each row we grab their pokeman number(for an image) and their name.
            //We then create a Pokeman with those given types and append it to our list
            for row in rows{
                let pokeID = Int(row["id"]!)!
                let pokeman = Pokemon(name: row["identifier"]!, pokedexID: pokeID)
                self.pokemon.append(pokeman)
            }
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    //MANDATORY - for creating the cells, sets them up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Try to make a new PokeCell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            //for each pokemon in our array we can access them
            let poke: Pokemon!
            
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            //then configure them with our function

            
            return cell
            
            //Otherwise, just give us an empty cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    //MANDATORY - what happens when you select an item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        
    }
    
    //MANDATORY - how many items we have in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }else {
            return pokemon.count
        }
        
    }

    //MANDATORY - how many sections we have
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MANDATORY - how big these items are going to be
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Sizing our cells
        return CGSize(width: 105, height: 105)
        
    }

    //When our music button is pressed, we stop/start the audio accordingly.
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.4
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            //$0 is placeholder for all objects in pokemon array
            //get the name, and see if the searchbar text is in the range of the original name
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            
            collection.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }

    }

}
