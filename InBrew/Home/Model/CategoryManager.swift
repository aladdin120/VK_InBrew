//
//  CategoryManager.swift
//  InBrew
//
//  Created by Fedo on 01.11.2021.
//

import Foundation

protocol CategoryManagerProtocol {
    func loadCategories() -> [Category]
}

class CategoryManager: CategoryManagerProtocol {
    static let shared: CategoryManagerProtocol = CategoryManager()
    
    private init() {}
    
    func loadCategories() -> [Category] {
        return [
            Category(name: "Russian", iconUrl: URL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Flag_of_Russia.svg/1200px-Flag_of_Russia.svg.png")),
            Category(name: "German", iconUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Flag_of_Germany_%28state%29.svg/2560px-Flag_of_Germany_%28state%29.svg.png")),
            Category(name: "Belgium", iconUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Flag_of_Belgium.svg/1200px-Flag_of_Belgium.svg.png")),
            Category(name: "Light", iconUrl: URL(string: "https://www.futurity.org/wp/wp-content/uploads/2018/09/beer-against-black-background_1600.jpg")),
            Category(name: "Dark", iconUrl: URL(string: "https://images.ctfassets.net/sz2xpiwl6od9/7ClChyLkTR3ZALpWWaqJ4c/98b569df806d5a7dc82b7d00962c05c1/You-Down-With-Brown.jpg?w=900&fm=jpg")),
            Category(name: "Czech", iconUrl: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Flag_of_the_Czech_Republic.svg/1200px-Flag_of_the_Czech_Republic.svg.png"))
        ]
    }
}
