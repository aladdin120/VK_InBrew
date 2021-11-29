//
//  DatabaseModel.swift
//  InBrew
//
//  Created by golub_dobra on 15.11.2021.
//

import Firebase
import UIKit


final class DatabaseModel {
    private let database = Firestore.firestore()
    
    func addUserInDatabase(name: String, email: String, UID: String, complition: @escaping (Result<String, Error>) -> Void) {
        let user = UserModel(uid: UID, email: email, name: name, avatar: "")
        let data = ["name": user.name,
                    "email": user.email,
                    "favourite": user.favourite] as [String : Any]
        
        database.collection("users").document(UID).setData(data) { err in
            if let err = err {
                print("[DEBUG:] Error writing document: \(err)")
            } else {
                print("[DEBUG:] Document successfully written!")
            }
        }
    }
    
    func addFavouriteBeerInDatabase(beerId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            print("[DEBUG:] Unknown user id!")
            return
        }
        
        database.collection("users").document(UID).updateData(["favourite": FieldValue.arrayUnion([beerId])])
    }
    
    func removeFavouriteBeerFromDatabase(beerId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            print("[DEBUG:] Unknown user id!")
            return
        }
        
        database.collection("users").document(UID).updateData(["favourite": FieldValue.arrayRemove([beerId])])
    }
    
    func getFavouriteBeerInDatabase(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            print("[DEBUG]: \(FirebaseError.notFindUser)")
            return
        }
        
        database.collection("users").document(UID).addSnapshotListener { querySnapshot, error in
            guard error == nil,
                  let querySnapshot = querySnapshot,
                  querySnapshot.exists else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
            
            let favouriteDoc: [String] = querySnapshot.get("favourite") as? [String] ?? []
            
            completion(.success(favouriteDoc))
        }
    }
    
    func getDetailsOfFavouriteBeer(favouriteArray: [String], completion: @escaping (Result<[Product], Error>) -> Void) {
        database.collection("beer").whereField(FieldPath.documentID(), in: favouriteArray).getDocuments { querySnapshot, error in
            guard error == nil,
                  let beerDetails = querySnapshot else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
            
            var favProduct: [Product] = []
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let product = document.data()
                guard let productName = product["name"] as? String,
                      let productCountry = product["country"] as? String,
                      let productPrice = product["price"] as? String,
                      let productDescription = product["description"] as? String,
                      let productSort = product["sort"] as? String else {
                    return
                }
                favProduct.append(Product(id: document.documentID,
                                          name: productName,
                                          categories: productCountry,
                                          price: productPrice,
                                          description: productDescription,
                                          sort: productSort,
                                          isFavourite: true,
                                          imageUrl: nil))
                print("[DEBUG]: \(favProduct)")
            }
            
            
            
            print("[DEBUG]: \(beerDetails)")
            completion(.success(favProduct))
        }
    }
}
