//
//  ProductsManager.swift
//  InBrew
//
//  Created by Fedo on 08.11.2021.
//

import Firebase
import UIKit


protocol ProductsManagerProtocol {
    func getAllBeer(completion: @escaping (Result<[Product], Error>) -> Void)
    func getAllBeerWithFilter(with country: String, completion: @escaping (Result<[Product], Error>) -> Void)
    func getBeerById(with id: String, completion: @escaping (Result<Product?, Error>) -> Void)
    func addBeer(with data: [String: Any], with image: Data?, completion: @escaping (Result<Bool, Error>) -> Void)
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
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    func getAllBeerWithFilter(with country: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        database.collection("beer").whereField("country", isEqualTo: country).getDocuments { [weak self] (querySnapshot, err) in
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
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    func getBeerById(with id: String, completion: @escaping (Result<Product?, Error>) -> Void) {
        database.collection("beer").document(id).getDocument { [weak self] (querySnapshot, err) in
            guard err == nil, let querySnapshot = querySnapshot else {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            
            guard let _ = querySnapshot.data() else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }

            var favouriteArray: [String] = []
            self?.databaseModel.getFavouriteBeerInDatabase { result in
                switch result {
                case .success(let favourite):
                    favouriteArray = favourite
                    let product = self?.productConverter.convertToProduct(from: querySnapshot, isFavourite: favouriteArray.contains(querySnapshot.documentID))
                    completion(.success(product))
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
        }
    }
    
    func addBeer(with data: [String: Any], with image: Data?, completion: @escaping (Result<Bool, Error>) -> Void) {
        let beerId = database.collection("beer").addDocument(data: data).documentID
        
        let reference = Storage.storage().reference()
        
        let storageRef = reference.child("beer/" + beerId + ".jpeg")
        if (image != nil) {
            guard let image = image else {
                return
            }
            
            storageRef.putData(image, metadata: nil) { (metadata, error) in
                guard let _ = metadata,
                      error == nil else {
                          completion(.failure(FirebaseError.canNotAddDocument))
                          return
                }
            }
        }
        completion(.success(true))
    }
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
