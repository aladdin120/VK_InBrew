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
    private let emptyFavouriteLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have favorite beer!"
        label.font = UIFont(name: "Comfortaa-Bold", size: 18)
        label.numberOfLines = 0
        label.textColor = .minorText
        
        return label
    }()
    private let cellsOffset: CGFloat = 8
    private let cellHeight: CGFloat = 230
    private let numberOfItemsPerRowProducts: CGFloat = 2
    private let databaseModel: DatabaseModel = DatabaseModel()
    private var favouriteProduct: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        collectionView.backgroundColor = .background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavouriteViewControllerCell.self,
                                forCellWithReuseIdentifier: "FavouriteViewControllerCell")
        
        getDetails()
        emptyFavouriteLabel.isHidden = true
        view.addSubview(collectionView)
        view.addSubview(emptyFavouriteLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Favourite"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
        
        emptyFavouriteLabel.pin
            .top(view.pin.safeArea.top + 100)
            .hCenter()
            .sizeToFit()
    }
    
    func getDetails() {
        var fav: [String] = []
        databaseModel.getFavouriteBeerInDatabase {[weak self] result in
            switch result {
            case .success(let res):
                guard !res.isEmpty else {
                    self?.emptyFavouriteLabel.isHidden = false
                    self?.favouriteProduct = []
                    self?.collectionView.reloadData()
                    return
                }
                self?.emptyFavouriteLabel.isHidden = true
                fav = res
                self?.databaseModel.getDetailsOfFavouriteBeer(favouriteArray: fav) {[weak self] result in
                    switch result {
                    case .success(let product):
                        self?.favouriteProduct = product
                        self?.collectionView.reloadData()

                    case .failure(_):
                        print("[DEBUG]: \(FirebaseError.emptyDocumentData)")
                    }
                }
                print("[DEBUG]: Good!")

            case .failure(_):
                print("[DEBUG]: \(FirebaseError.emptyDocumentData)")
            }
        }
    }
}

extension FavouriteViewController: FavouriteViewControllerCellDelegate {
    func didTapLikeBeer(isLiked: Bool, beerId: String) {
        
        if isLiked {
            databaseModel.removeFavouriteBeerFromDatabase(beerId: beerId) {[weak self] result in
                switch result {
                case .success(_):
                    self?.getDetails()
                case .failure(_):
                    return
                }
            }
        } else {
            databaseModel.addFavouriteBeerInDatabase(beerId: beerId) {[weak self] result in
                switch result {
                case .success(_):
                    self?.getDetails()
                case .failure(_):
                    return
                }
            }
        }
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteViewControllerCell", for: indexPath) as? FavouriteViewControllerCell else {
            return .init();
        }
        let favouriteCell = favouriteProduct[indexPath.item]
        cell.configure(with: favouriteCell)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - cellsOffset * (numberOfItemsPerRowProducts + 1)
        let cellWidth = availableWidth / numberOfItemsPerRowProducts
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellsOffset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: cellsOffset, bottom: 0, right: cellsOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let beerCardViewController = BeerCardViewController()
        let navigationController = UINavigationController(rootViewController: beerCardViewController)
        navigationController.modalPresentationStyle = .fullScreen
        beerCardViewController.product = favouriteProduct[indexPath.item]
    
        present(navigationController, animated: true, completion: nil)
    }
}

