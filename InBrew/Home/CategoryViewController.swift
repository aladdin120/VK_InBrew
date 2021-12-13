//
//  CategoryViewController.swift
//  InBrew
//
//  Created by fedo on 12.12.2021.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController {
    
    private var beerCollection: UICollectionView?
    
    private let model: ProductsManagerProtocol = ProductsManager.shared
    
    //cells
    private let cellsOffset: CGFloat = 8
    private let cellHeight: CGFloat = 230
    private let numberOfItemsPerRowProducts: CGFloat = 2
    
    var products: [Product] = []
    var nameCurrentCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nameCurrentCategory
        navigationController?.navigationBar.tintColor = .primary
        
        loadProducts()
        setupCollection()
    }
    
    func loadProducts() {
        model.getAllBeerWithFilter(with: nameCurrentCategory) { [weak self] result in
            switch result{
            case .success(let data):
                self?.products = data
                self?.beerCollection?.reloadData()
            case .failure(let error):
                print("[DEBUG] \(error)")
            }
        }
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        let backImage = UIImage(systemName: "chevron.backward")
//        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
//        navigationItem.leftBarButtonItem = backButtonItem
//        navigationController?.navigationBar.tintColor = .primary
//        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.shadowImage = UIImage()
//    }
    
    override func viewDidLayoutSubviews() {
        beerCollection?.pin
            .all()
    }
    
    @objc
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product: Product = products[indexPath.item]
        cell.configure(with: product)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product = products[indexPath.item]
        
        let beerCardViewController = BeerCardViewController()
        let navigationController = UINavigationController(rootViewController: beerCardViewController)
        navigationController.modalPresentationStyle = .fullScreen
        beerCardViewController.product = product
        
        present(navigationController, animated: true, completion: nil)
    }
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
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
