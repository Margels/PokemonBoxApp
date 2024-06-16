//
//  PokemonSpeciesModel.swift
//  CatchEmAll
//
//  Created by Margels on 15/06/24.
//

import Foundation

struct PokemonFlavorTextModel: Decodable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Decodable {
    let flavor_text: String
    let language: Language
}

struct Language: Decodable {
    let name: String
}
