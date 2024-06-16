//
//  ViewController.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import UIKit
import RxCocoa
import RxSwift

final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        tv.tableFooterView = UIView()
        tv.keyboardDismissMode = .interactive
        tv.delegate = nil
        tv.dataSource = nil
        return tv
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.searchBarStyle = .minimal
        sb.placeholder = "Search name or type"
        return sb
    }()
    
    private lazy var loadingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        l.textColor = .secondaryLabel
        l.text = "Loading..."
        l.textAlignment = .center
        l.backgroundColor = .secondarySystemBackground
        l.alpha = 0.6
        return l
    }()
    
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var bottomConstraint: NSLayoutConstraint = self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNotifications()
        self.setUpView()
        self.setUpConstraints()
        self.setUpContent()
    }
    
    // Set up view
    private func setUpView() {
        self.title = "PokemonBox"
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(loadingLabel)
    }
    
    // Set up constraints
    private func setUpConstraints() {
        
        searchBar.customConstraints(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.safeAreaLayoutGuide.leadingAnchor,
            trailing: self.view.safeAreaLayoutGuide.trailingAnchor,
            leadingPadding: 15,
            trailingPadding: 15)
        
        tableView.customConstraints(
            top: searchBar.bottomAnchor,
            leading: self.view.safeAreaLayoutGuide.leadingAnchor,
            trailing: self.view.safeAreaLayoutGuide.trailingAnchor)
        bottomConstraint.isActive = true
        
        loadingLabel.anchorTo(view: self.view)
    }
    
    // Set up content and bind view model
    private func setUpContent() {
        tableView.rx.contentOffset
            .map { [unowned self] contentOffset in
                let contentHeight = self.tableView.contentSize.height
                let frameHeight = self.tableView.frame.size.height
                return contentOffset.y + frameHeight > contentHeight - 100
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(to: viewModel.loadMoreTrigger)
            .disposed(by: disposeBag)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        // Bind search bar text to search query
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
        
        // Bind filtered items to the table view
        viewModel.searchResults
            .bind(to: tableView.rx.items(cellIdentifier: PokemonCell.identifier, cellType: PokemonCell.self)) { (row, element, cell) in
                cell.config(with: element)
            }
            .disposed(by: disposeBag)
        
        // Set up loading view
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                UIView.animate(withDuration: 0.5) {
                    self.loadingLabel.isHidden = !isLoading
                }
            })
            .disposed(by: disposeBag)
        
        // Handle error
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
    }
    
    // Handle errors with alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(OK)
        alert.view.tintColor = .black
        self.present(alert, animated: true)
    }
    
    // Register notifications for keyboard
    private func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    // Handle table view size when keyboard is showing
    @objc private func keyboardDidShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
            }
    }
    
    // Reset table view size when keyboard is dismissed
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
    }
}
