//
//  Pagination.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation
import RxSwift
import RxCocoa

class Pagination {
    let pageSize = 20
    
    func loadNewItems(for page: Int) -> Observable<[PokemonDetailsModel]> {
        let offset = page * self.pageSize
        return PokeAPI.shared.fetchPokemon(page: self.pageSize, offset: offset)
    }
    
}
