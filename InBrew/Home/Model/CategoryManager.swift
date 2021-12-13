//
//  CategoryManager.swift
//  InBrew
//
//  Created by Fedo on 01.11.2021.
//

import Foundation
import Firebase

protocol CategoryManagerProtocol {
    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void)
    func getBeerOfTheDay(completion: @escaping (Result<String, Error>) -> Void)
}

class CategoryManager: CategoryManagerProtocol {
    
    static let shared: CategoryManagerProtocol = CategoryManager()
    private let database = Firestore.firestore()
    
    private init() {}
    
    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        database.collection("categories").document("countries").getDocument {(document, err) in
            
            if err != nil {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            guard let document = document, document.exists else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
                                    
            let categoriesStrings: [String] = document.get("countries") as? [String] ?? []
            var categories: [Category] = []
            for categoryString in categoriesStrings {
                categories.append(Category(name: categoryString, iconUrl: nil))
            }
            
            completion(.success(categories))
        }
    }
    
    func getBeerOfTheDay(completion: @escaping (Result<String, Error>) -> Void) {
        database.collection("categories").document("bestOfDay").getDocument { (document, err) in
            if err != nil {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            guard let document = document, document.exists else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
            let beerId: String = document.get("id") as? String ?? ""
            print(beerId)
            completion(.success(beerId))
        }
    }
    
//    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
//        database.collection("categories").getDocuments {(querySnapshot, err) in
//
//            if err != nil {
//                completion(.failure(FirebaseError.notFindDocument))
//                return
//            }
//            guard let documents = querySnapshot?.documents else {
//                completion(.failure(FirebaseError.emptyDocumentData))
//                return
//            }
//
//            var categories: [Category] = []
//            for document in documents {
//                if let categoryName = document.get("country") as? String {
//                    categories.append(Category(id: document.documentID, name: categoryName, iconUrl: nil))
//                }
//            }
//            completion(.success(categories))
//        }
//    }
}
