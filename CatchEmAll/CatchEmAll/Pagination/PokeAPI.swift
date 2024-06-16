//
//  PokeAPI.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation
import RxSwift
import RxCocoa

class PokeAPI {
    
    static var shared = PokeAPI()
    
    // Retrieve pokemon list
    func fetchPokemon(page: Int, offset: Int) -> Observable<[PokemonDetailsModel]> {
        let urlString = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(page)"
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> [PokemonModel] in
                let response = try JSONDecoder().decode(PokemonListModel.self, from: data)
                return response.results
            }
            .flatMap { results -> Observable<PokemonDetailsModel> in
                Observable.from(results)
                    .flatMap { result in
                        self.fetchPokemonDetails(url: result.url)
                    }
            }
            .toArray()
            .map { results in
                results.sorted { $0.id < $1.id }
            }
            .asObservable()
    }
    
    // Retrieve pokemon description
    private func fetchPokemonDetails(url: String) -> Observable<PokemonDetailsModel> {
        guard let url = URL(string: url) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .flatMap { data -> Observable<PokemonDetailsModel> in
                var pokemon = try JSONDecoder().decode(PokemonDetailsModel.self, from: data)
                return self.fetchPokemonSpecies(pokemonId: pokemon.id)
                    .map { species in
                        if let flavorTextEntry = species.flavor_text_entries.last(where: { $0.language.name == "en" }) {
                            pokemon.description = flavorTextEntry.flavor_text
                        }
                        return pokemon
                    }
            }
    }
    
    // Retrieve
    private func fetchPokemonSpecies(pokemonId: Int) -> Observable<PokemonFlavorTextModel> {
        let urlString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonId)/"
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data in
                return try JSONDecoder().decode(PokemonFlavorTextModel.self, from: data)
            }
    }
}
