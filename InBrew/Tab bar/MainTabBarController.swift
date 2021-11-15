//
//  MainTabBarController.swift
//  InBrew
//
//  Created by golub_dobra on 24.10.2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let homeViewController = HomeViewController()
    private let categoriesViewController = CategoriesViewController()
    private let addBeerViewController = AddBeerViewController()
    private let favouriteViewController = FavouriteViewController()
    private let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        UITabBar.appearance().tintColor = .systemYellow

        setupTabBar()
    }
    
    private func setupTabBar() {
        homeViewController.tabBarItem.image = UIImage(named: "homeIcon")
        homeViewController.tabBarItem.title = "Home"
        categoriesViewController.tabBarItem.image = UIImage(named: "categoriesIcon")
        categoriesViewController.tabBarItem.title = "List"
        addBeerViewController.tabBarItem.image = UIImage(named: "addBeerIcon")
        favouriteViewController.tabBarItem.image = UIImage(named: "favouriteIcon")
        favouriteViewController.tabBarItem.title = "Favourite"
        profileViewController.tabBarItem.image = UIImage(named: "profileIcon")
        profileViewController.tabBarItem.title = "Profile"
        
        addBeerViewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        
        setViewControllers([homeViewController,
                            categoriesViewController,
                            addBeerViewController,
                            favouriteViewController,
                            profileViewController].map { UINavigationController(rootViewController: $0) },
                           animated: false)
    }
}
