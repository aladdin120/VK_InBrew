//
//  AuthFirebaseModel.swift
//  InBrew
//
//  Created by golub_dobra on 03.11.2021.
//

import UIKit
import Firebase

final class AuthFirebaseModel {
    func signIn(email: String,
                 password: String,
                 completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let userEmail = user?.user.email,
                  let userUID = user?.user.uid else {
                completion(.failure(FirebaseError.notFindUser))
                return
            }
            
            let findUser: UserModel = UserModel.init(uid: userUID, email: userEmail)
            completion(.success(findUser))
        }
    }
}
