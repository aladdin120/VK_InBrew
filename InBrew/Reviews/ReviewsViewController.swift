//
//  ReviewsViewController.swift
//  InBrew
//
//  Created by golub_dobra on 10.12.2021.
//

import UIKit

final class ReviewsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView()
    private let databaseModel = DatabaseModel()
    
    private var reviewsProduct: [ReviewModel] = []
    
    var product: Product? {
        didSet {
            guard product != nil else {
                return
            }
        }
    }
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReviewsViewControllerCell.self, forCellReuseIdentifier: "ReviewsViewControllerCell")
        tableView.separatorStyle = .none
        
        activityIndicator.hidesWhenStopped = true
        
        getReviews()
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    func getReviews() {
        activityIndicator.startAnimating()
        guard let beerId = product?.id else {
            return
        }
        databaseModel.getBeerReviewFromDatabase(beerId: beerId) {[weak self] result in
            switch result {
            case .success(let productReviews):
                self?.reviewsProduct = productReviews
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            case .failure(_):
                self?.activityIndicator.stopAnimating()
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Reviews"
        let backImage = UIImage(systemName: "chevron.backward")
        let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(didTapBackButton))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = .primary
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.pin.all()
        
        activityIndicator.pin.center()
    }
    
    @objc
    func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviewsProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsViewControllerCell", for: indexPath) as? ReviewsViewControllerCell else {
            return .init();
        }
        
        let reviewsCell = reviewsProduct[indexPath.item]
        cell.configure(with: reviewsCell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewCell = reviewsProduct[indexPath.item]
        let reviewViewController = ReviewViewController()
        reviewViewController.review = reviewCell
        reviewViewController.modalPresentationStyle = .popover
        self.present(reviewViewController, animated: true, completion: nil)
    }
}
