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
    
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = CategoryManager.shared.loadCategories()
        
        setupNavBar()
        setupCollectionView()
    }
    
    func setupNavBar() {
        view.backgroundColor = .white
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        MyCollectionView.backgroundColor = .white
        
        
        view.addSubview(MyCollectionView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        MyCollectionView?.pin
            .top(view.safeAreaInsets.bottom)
            .bottom(view.pin.safeArea)
            .marginTop(10)
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

