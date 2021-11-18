//
//  FavouriteViewController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit
import PinLayout

final class FavouriteViewController: UIViewController {
    private var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        
        return UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    }()
    
    private var itemOfFav: UIButton = {
        let button = UIButton()
        button.setTitle("like", for: .normal)
        button.backgroundColor = .fail
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        collectionView.backgroundColor = .background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouriteViewControllerCell.self, forCellWithReuseIdentifier: "FavouriteViewControllerCell")
        
        view.addSubview(collectionView)
        view.addSubview(itemOfFav)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let filterButtonImage = UIImage(systemName: "slider.horizontal.3")
        let rightButtonItem = UIBarButtonItem(image: filterButtonImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationController?.navigationBar.tintColor = .primary
        navigationItem.title = "Favourite"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Comfortaa-Bold", size: 20)]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        itemOfFav.pin
            .center()
            .sizeToFit()
        
        collectionView.pin.all()
    }
    
    @objc
    func didTapLikeButton() {
        let beerCardViewController = UINavigationController(rootViewController: BeerCardViewController())
        beerCardViewController.modalPresentationStyle = .fullScreen
        self.present(beerCardViewController, animated: true, completion: nil)
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteViewControllerCell", for: indexPath) as? FavouriteViewControllerCell else {
            return .init();
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 173, height: 201)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}


final class FavouriteViewControllerCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
