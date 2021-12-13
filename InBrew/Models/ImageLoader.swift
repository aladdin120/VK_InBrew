//
//  ImageLoader.swift
//  InBrew
//
//  Created by Fedo on 17.11.2021.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

protocol ImageLoaderProtocol {
    func getBeerImage(beerId: String, completion: @escaping (Result<UIImage, Error>) -> Void)
    func getBeerImageUrl(beerId: String, completion: @escaping (Result<URL, Error>) -> Void)
    func getReviewImage(reviewId: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    static let shared: ImageLoaderProtocol = ImageLoader()
    
    private let reference = Storage.storage().reference()
    
    private init() {}
    
    func getBeerImage(beerId: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let pathRef = reference.child("beer")
        let fileRef = pathRef.child(beerId + ".jpeg")

        fileRef.getData(maxSize: 15 * 1024 * 1024) { (data, err) in
            if err != nil {
                completion(.failure(FirebaseError.notFindData))
                return
            } else if let data = data, let img = UIImage(data: data) {
                completion(.success(img))
            }
        }
    }
    
    func getBeerImageUrl(beerId: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let pathRef = reference.child("beer")
        let fileRef = pathRef.child(beerId + ".jpeg")
        
        fileRef.downloadURL { (url, err) in
            if err != nil {
                completion(.failure(FirebaseError.notFindData))
                return
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
    
    func getReviewImage(reviewId: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let pathRef = reference.child("review")
        let fileRef = pathRef.child(reviewId + ".jpeg")

        fileRef.getData(maxSize: 15 * 1024 * 1024) { (data, err) in
            if err != nil {
                completion(.failure(FirebaseError.notFindData))
                return
            } else if let data = data, let img = UIImage(data: data) {
                completion(.success(img))
            }
        }
    }
}
