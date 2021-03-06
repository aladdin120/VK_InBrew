//
//  Product.swift
//  InBrew
//
//  Created by Fedo on 08.11.2021.
//

import Foundation
import UIKit

struct Product {
    let id: String
    let name: String
    let categories: String
    let price: String
    let description: String
    let sort: String
    let isFavourite: Bool
    var imageUrl: URL?
    
    // review fields
    var review: [String: Any] = [:]
//    var uid: String
//    var text: String
//    var rating: Int
//    var userImage: URL?
}
