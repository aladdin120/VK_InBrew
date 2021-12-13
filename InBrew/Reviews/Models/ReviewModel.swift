//
//  ReviewModel.swift
//  InBrew
//
//  Created by golub_dobra on 12.12.2021.
//

import Foundation

struct ReviewModel {
    let id: String
    let rating: Int
    let review: String
    let uid: String
    let name: String
    
    init(id: String,rating: Int, review: String, uid: String, name: String) {
        self.id = id
        self.rating = rating
        self.review = review
        self.uid = uid
        self.name = name
    }
}
