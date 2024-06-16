//
//  PokemonDetailsModel.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation

struct PokemonDetailsModel: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeModel]
    let sprites: SpritesModel
    var description: String?
    var photoUrl: URL? { URL(string: sprites.front_default ?? "") }
}


