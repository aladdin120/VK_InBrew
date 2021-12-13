//
//  HomeViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import PinLayout

final class HomeViewController: UIViewController {
    
    private var MyCollectionView: UICollectionView?
    
    private let cellsOffset: CGFloat = 8
    private let cellHeight: CGFloat = 190
    
    //Categories cells
    private let numberOfItemsPerRowCategories: CGFloat = 2
    
    //Banners cells
    private let numberOfItemsPerRowBanner: CGFloat = 1
    private let numberOfBanners = 1
    
    private let model: CategoryManagerProtocol = CategoryManager.shared
    private let productModel: ProductsManagerProtocol = ProductsManager.shared
    
    private var categories: [Category] = []
    private var beerId: String = ""
    private var product: Product? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        setupNavBar()
        setupCollectionView()
    }
    
    func loadCategories() {
        model.getAllCategories { [weak self] result in
            switch result {
            case .success(let data):
                self?.categories = data
                self?.MyCollectionView?.reloadData()
            case .failure(let error):
                print("[DEBUG]: \(error)")
            }
        }
        
        
        model.getBeerOfTheDay { [weak self] result in
            switch result {
            case .success(let data):
                self?.beerId = data
            case .failure(let error):
                print("[DEBUG]: \(error)")
            }
        }
    }
    

    
    func setupNavBar() {
        view.backgroundColor = .white
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupCollectionView() {
        let layoutCategory = UICollectionViewFlowLayout()
        MyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCategory)
        guard let MyCollectionView = MyCollectionView else {
            return
        }
        MyCollectionView.register(CategoryCellCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCellCollectionViewCell.identifier)
        MyCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        MyCollectionView.dataSource = self
        MyCollectionView.delegate = self
        MyCollectionView.frame = view.bounds
        MyCollectionView.backgroundColor = .background
        
        
        view.addSubview(MyCollectionView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        MyCollectionView?.pin
            .top(view.pin.safeArea.bottom)
            .bottom(view.pin.safeArea)
            .marginTop(20)
            .horizontally(5)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + numberOfBanners
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let range = 0..<numberOfBanners
        
        if (range.contains(indexPath.item)) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellCollectionViewCell.identifier, for: indexPath) as? CategoryCellCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item - numberOfBanners]
        cell.configure(with: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let beerCardViewController = BeerCardViewController()
            let navigationController = UINavigationController(rootViewController: beerCardViewController)
            navigationController.modalPresentationStyle = .fullScreen
            beerCardViewController.beerId = self.beerId
            self.present(navigationController, animated: true, completion: nil)
        } else {
            let categoryViewController = CategoryViewController()
            categoryViewController.nameCurrentCategory = categories[indexPath.item - numberOfBanners].name
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let range = 0..<numberOfBanners
        
        if (range.contains(indexPath.item)) {
            
            let availableWidth = collectionView.frame.width - cellsOffset * (numberOfItemsPerRowBanner + 1)
            let cellWidth = availableWidth / numberOfItemsPerRowBanner
            
            return CGSize(width: cellWidth, height: cellHeight)
        
        } else {
            
            let availableWidth = collectionView.frame.width - cellsOffset * (numberOfItemsPerRowCategories + 1)
            let cellWidth = availableWidth / numberOfItemsPerRowCategories
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
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

