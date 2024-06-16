//
//  PokemonListModel.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation

struct PokemonListModel: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonModel]
}
