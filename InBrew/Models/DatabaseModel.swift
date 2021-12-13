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
    
    private let reference = Storage.storage().reference()
    
    func addUserInDatabase(name: String, email: String, UID: String, completion: @escaping (Result<String, Error>) -> Void) {
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
    
    func getUserFromDatabase(completion: @escaping (Result<UserModel, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(FirebaseError.emptyDocumentData))
            return
        }
        database.collection("users").document(uid).addSnapshotListener {querySnapshot, error in
            guard error == nil,
                  let querySnapshot = querySnapshot,
                  querySnapshot.exists else {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            
            guard let email: String = querySnapshot.get("email") as? String,
                  let name: String = querySnapshot.get("name") as? String else {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            
            let bearReview: UserModel = UserModel.init(uid: uid, email: email, name: name, avatar: "")
            
            completion(.success(bearReview))
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
    
    func postBeerReviewInDatabase(beerId: String, image: Data?, review: String, rating: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(.failure(FirebaseError.emptyDocumentData))
            return
        }
        
        getUserFromDatabase {[weak self] result in
            switch result {
            case .success(let name):
                let data = ["uid": UID,
                            "name": name.name,
                            "rating": rating,
                            "review": review] as [String : Any]
                
                
                guard let reviewId = self?.database.collection("beer").document(beerId).collection("reviews").addDocument(data: data).documentID else {
                    return
                }
                
                let riversRef = self?.reference.child("review/" + reviewId + ".jpeg")
                if (image != nil) {
                    guard let image = image else {
                        return
                    }
                    
                    riversRef?.putData(image, metadata: nil) { (metadata, error) in
                        guard let _ = metadata,
                              error == nil else {
                            return
                        }
                    }
                }
               
                
            case .failure(_):
                return
            }
        }
        
        
        database.collection("alertMessage").document("BFScbBxZmVTpgn1dPTmK").addSnapshotListener { querySnapshot, error in
            guard error == nil,
                  let querySnapshot = querySnapshot,
                  querySnapshot.exists else {
                completion(.failure(FirebaseError.emptyDocumentData))
                return
            }
            
            let messages: [String] = querySnapshot.get("favourite") as? [String] ?? []
            
            completion(.success(messages.randomElement() ?? ""))
        }
        
    }
    
    func getBeerReviewFromDatabase(beerId: String, completion: @escaping (Result<[ReviewModel], Error>) -> Void) {
        database.collection("beer").document(beerId).collection("reviews").getDocuments { querySnapshot, error in
            guard error == nil else {
                completion(.failure(FirebaseError.notFindDocument))
                return
            }
            
            var reviewsProduct: [ReviewModel] = []
            for document in querySnapshot!.documents {
                guard let rating = document["rating"] as? Int,
                      let review = document["review"] as? String,
                      let uid = document["uid"] as? String,
                      let name = document["name"] as? String else {
                    return
                }
                
                let bearReview: ReviewModel = ReviewModel.init(id: document.documentID, rating: rating, review: review, uid: uid, name: name)
                reviewsProduct.append(bearReview)
            }
            
            completion(.success(reviewsProduct))
        }
        
    }
}
