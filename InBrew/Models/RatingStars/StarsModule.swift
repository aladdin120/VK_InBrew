//
//  StarsModule.swift
//  InBrew
//
//  Created by golub_dobra on 29.11.2021.
//

import UIKit
import PinLayout

let starSize: Int = 18
let starSpasing: Int = 3

final class StarsModule: UIStackView {
    private var ratingStarsButtons = [UIButton]()
    private var maxRating: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    var rating: Int = 0 {
        didSet {
            updateButtonSelectedStates()
        }
    }
    
//    func numberOfRatingStar(count: Int) {
//        rating = count
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        spacing = CGFloat(starSpasing)
        alignment = .fill
        distribution = .fill
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super .init(coder: coder)
        setUpButtons()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpButtons() {
        for _ in 0..<maxRating {
            let button = UIButton()
            
            button.setImage(UIImage(systemName: "star") , for: .normal)
            button.setImage(UIImage(systemName: "star") , for: .highlighted)
            button.setImage(UIImage(systemName: "star.fill") , for: .selected)
            
            button.tintColor = .primary
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 18.0).isActive = true
            
            button.addTarget(self, action: #selector(didTapRatingStar(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            ratingStarsButtons.append(button)
        }
    }
    
    @objc
    func didTapRatingStar(button: UIButton) {
        guard let index = ratingStarsButtons.firstIndex(of: button) else {
            return
        }
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    @objc
    func updateButtonSelectedStates() {
        for (index, button) in ratingStarsButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
