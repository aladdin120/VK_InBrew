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
    private var ratingStarsImage = [UIImageView]()
    private let maxRating: Int = 5
    private let numberOfRating: Int = 4 //mock
    
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
        for index in 0..<maxRating {
            var button = UIImageView()
            if index < numberOfRating {
                button = UIImageView(image: UIImage(systemName: "star.fill"))
            } else {
                button = UIImageView(image: UIImage(systemName: "star"))
            }
            
            button.tintColor = .primary
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 18.0).isActive = true
            
            addArrangedSubview(button)
            
            ratingStarsImage.append(button)
        }
    }
}
