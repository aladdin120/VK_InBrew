//
//  CategoriesViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit

final class CategoriesViewController: UIViewController {

    private var beerCollection: UICollectionView?
    private let searchController = UISearchController(searchResultsController: nil)
    
    //cells
    private let cellsOffset: CGFloat = 8
    private let cellHeight: CGFloat = 230
    private let numberOfItemsPerRowProducts: CGFloat = 2
    
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = ProductsManager.shared.loadContent()
        
        setupNavBarAndSc()
        setupCollection()
    }
    
    func setupNavBarAndSc() {
        view.backgroundColor = .white
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let sc = UISearchController(searchResultsController: nil)
        navigationItem.searchController = sc
        //searchController.searchBar.delegate = self
//        searchController.searchBar.showsBookmarkButton = true
//        searchController.searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
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

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.item]
        cell.configure(with: product)
        
        return cell
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
