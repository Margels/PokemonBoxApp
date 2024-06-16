//
//  PokemonTypeModel.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation

struct PokemonTypeModel: Decodable {
    let slot: Int
    let type: TypeModel
}

struct TypeModel: Decodable {
    let name: String
    let url: String
}
