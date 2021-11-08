//
//  UIViewController+Extensions.swift
//  InBrew
//
//  Created by golub_dobra on 08.11.2021.
//

import UIKit

extension UIViewController {
    func animateButtonOpacity(button: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            button.alpha = 0.8
        }) { _ in
            button.alpha = 1.0
        }
    }
}
