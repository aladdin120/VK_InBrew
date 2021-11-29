//
//  ProductsManager.swift
//  InBrew
//
//  Created by Fedo on 08.11.2021.
//

import Firebase
//import FirebaseDatabase
import UIKit


protocol ProductsManagerProtocol {
    func getAllBeer(completion: @escaping (Result<[Product], Error>) -> Void)
}

class ProductsManager: ProductsManagerProtocol {
    static let shared: ProductsManagerProtocol = ProductsManager()
    
    private let database = Firestore.firestore()
    private let productConverter = ProductConverter()
    private let databaseModel: DatabaseModel = DatabaseModel()
    private init() {}
    
    func getAllBeer(completion: @escaping (Result<[Product], Error>) -> Void) {
        database.collection("beer").getDocuments { [weak self] (querySnapshot, err) in
            if err != nil {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
                        
            guard let documents = querySnapshot?.documents else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
            
            var favouriteArray: [String] = []
            self?.databaseModel.getFavouriteBeerInDatabase { result in
                switch result {
                case .success(let favourite):
                    favouriteArray = favourite
                    let products = documents.compactMap { self?.productConverter.convertToProduct(from: $0, isFavourite: favouriteArray.contains($0.documentID)) }
                    completion(.success(products))
                    
                case .failure(_):
                    return
                }
            }
        }
    }
    
//    func isBeerFavourite(completion: @escaping (Result<[String], Error>) -> Void) {
//        guard let UID = Auth.auth().currentUser?.uid else {
//            print("[DEBUG]: \(FirebaseError.notFindUser)")
//            return
//        }
//
//        database.collection("users").document(UID).addSnapshotListener {querySnapshot, error in
//            guard let querySnapshot = querySnapshot,
//                  querySnapshot.exists else {
//                completion(.failure(FirebaseError.emptyDocumentData))
//                return
//            }
//
//            let favouriteArray = querySnapshot.get("favourite") as? [String] ?? []
//
//            completion(.success(favouriteArray))
//        }
//    }
}

private final class ProductConverter {
    enum Key: String {
        case name
        case country
        case price
        case description
        case sort
    }
    
    func convertToProduct(from document: DocumentSnapshot, isFavourite: Bool) -> Product? {
        guard let dict = document.data(),
              let name = dict[Key.name.rawValue] as? String,
              let country = dict[Key.country.rawValue] as? String,
              let price = dict[Key.price.rawValue] as? String,
              let sort = dict[Key.sort.rawValue] as? String,
              let description = dict[Key.description.rawValue] as? String else {
                  return nil
              }
        let id = document.documentID
        return Product(id: id, name: name, categories: country, price: price, description: description, sort: sort, isFavourite: isFavourite, imageUrl: nil)
    }
}
