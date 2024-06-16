//
//  ViewModel.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    
    // Dispose bag for memory management
    private let disposeBag = DisposeBag()
    
    // Pokemon list for ViewController tableView
    var pokemonList: BehaviorRelay<[PokemonDetailsModel]> = BehaviorRelay(value: [])
    
    // Pagination
    let pagination = Pagination()
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let error: PublishRelay<Error> = PublishRelay()
    
    // Trigger to load more items
    let loadMoreTrigger: PublishRelay<Void> = PublishRelay()
    
    // Search and filter
    let searchQuery: BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchResults: BehaviorRelay<[PokemonDetailsModel]> = BehaviorRelay(value: [])

    
    init() {
        
        // Set up filter for searchResults
        Observable.combineLatest(pokemonList, searchQuery)
            .flatMapLatest { [weak self] (items, query) -> Observable<[PokemonDetailsModel]> in
                guard self != nil else { return Observable.just([]) }
                if query.isEmpty {
                    return Observable.just(items)
                } else {
                    let filtered = items.filter { $0.name.lowercased().contains(query.lowercased()) || $0.types.contains(where: { $0.type.name.lowercased().contains(query.lowercased()) })}
                    return Observable.just(filtered)
                }
            }
            .bind(to: searchResults)
            .disposed(by: disposeBag)
        
        // Initialise and set up loadMoreTrigger
        loadMoreTrigger.accept(())
        loadMoreTrigger
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .flatMapLatest { [weak self] _ -> Observable<[PokemonDetailsModel]> in
                guard let self = self else { return Observable.empty() }
                self.isLoading.accept(true)
                let currentPage = self.pokemonList.value.count / self.pagination.pageSize
                return self.pagination.loadNewItems(for: currentPage)
                    .retry(2)
                    .catch { [weak self] error -> Observable<[PokemonDetailsModel]> in
                        self?.error.accept(error)
                        self?.isLoading.accept(false)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] newItems in
                guard let self = self else { return }
                self.pokemonList.accept(self.pokemonList.value + newItems)
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
    }
    
}
