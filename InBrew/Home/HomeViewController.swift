//
//  HomeViewController.swift
//  InBrew
//
//  Created by Ольга Лемешева on 05.11.2021.
//  
//

import UIKit

final class HomeViewController: UIViewController {
	private let output: HomeViewOutput

    init(output: HomeViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension HomeViewController: HomeViewInput {
}