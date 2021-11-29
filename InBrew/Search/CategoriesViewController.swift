//
//  CategoriesViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit

protocol CategoriesViewControllerInput: AnyObject {
    func didReceive(_ products: [Product])
}

final class CategoriesViewController: UIViewController {

    private var beerCollection: UICollectionView?
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    private let model: ProductsManagerProtocol = ProductsManager.shared
    
    //cells
    private let cellsOffset: CGFloat = 8
    private let cellHeight: CGFloat = 230
    private let numberOfItemsPerRowProducts: CGFloat = 2
    
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isSearching: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty || searchBarScopeIsFiltering)
    }
    
    private var products: [Product] = []
    private var searchedProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
        
        setupNavBarAndSc()
        setupCollection()
        setupRefreshControl()
    }
    
    func loadProducts() {
        model.getAllBeer { [weak self] result in
            switch result {
            case .success(let dat):
                self?.products = dat
                self?.beerCollection?.reloadData()
            case .failure(let error):
                print("[DEBUG]: \(error)")
            }
        }
    }
    
    func setupNavBarAndSc() {
        view.backgroundColor = .white
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search some brew"
        searchController.searchBar.scopeButtonTitles = ["All", "Light", "Dark"]
    }
    
    func setupRefreshControl() {
        beerCollection?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender: )), for: .valueChanged)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        loadProducts()
        sender.endRefreshing()
    }
    
    func setupCollection() {
        let layoutBeer = UICollectionViewFlowLayout()
        beerCollection = UICollectionView(frame: .zero, collectionViewLayout: layoutBeer)
        guard let beerCollection = beerCollection else {
            return
        }
        beerCollection.delegate = self
        beerCollection.dataSource = self
        beerCollection.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        beerCollection.backgroundColor = .white
        
        view.addSubview(beerCollection)
    }
    
    override func viewDidLayoutSubviews() {
        beerCollection?.pin
            .top(view.safeAreaInsets.bottom)
            .bottom(view.pin.safeArea)
            .marginTop(10)
            .horizontally(5)
    }
}


extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        searchedProducts = products.filter { (product: Product) -> Bool in
            let doesCategoryMatch = (scope == "All") || (product.sort.contains(scope))
            if searchBarIsEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && product.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        beerCollection?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return searchedProducts.count
        }
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        var product: Product
        
        if isSearching {
            product = searchedProducts[indexPath.item]
        } else {
            product = products[indexPath.item]
        }
        cell.configure(with: product)
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text
        let scope = searchBar.scopeButtonTitles
        if let scope = scope, let searchText = searchText {
            filterContentForSearchText(searchText, scope: scope[searchBar.selectedScopeButtonIndex])
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedProducts.removeAll()
        beerCollection?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchText = searchBar.text
        let searchScope = searchBar.scopeButtonTitles
        if let searchText = searchText, let searchScope = searchScope {
        filterContentForSearchText(searchText, scope: searchScope[selectedScope])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var product: Product
        
        if isSearching {
            product = searchedProducts[indexPath.item]
        } else {
            product = products[indexPath.item]
        }
        
        let beerCardViewController = BeerCardViewController()
        let navigationController = UINavigationController(rootViewController: beerCardViewController)
        navigationController.modalPresentationStyle = .fullScreen
        beerCardViewController.product = product
        
        present(navigationController, animated: true, completion: nil)
    }
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - cellsOffset * (numberOfItemsPerRowProducts + 1)
        let cellWidth = availableWidth / numberOfItemsPerRowProducts
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: cellsOffset, bottom: 0, right: cellsOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
}

