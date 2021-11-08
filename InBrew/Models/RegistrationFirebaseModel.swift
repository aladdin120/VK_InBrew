//
//  RegistrationFirebaseModel.swift
//  InBrew
//
//  Created by golub_dobra on 07.11.2021.
//

import UIKit
import Firebase

final class RegistrationFirebaseModel {
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let userEmail = result?.user.email,
                  let userUID = result?.user.uid else {
                completion(.failure(FirebaseError.notFindUser))
                return
            }
            
            let newUser = UserModel(uid: userUID, email: userEmail)
            completion(.success(newUser))
            
        }
    }
}
