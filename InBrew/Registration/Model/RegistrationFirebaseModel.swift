//
//  RegistrationFirebaseModel.swift
//  InBrew
//
//  Created by golub_dobra on 07.11.2021.
//

import UIKit
import Firebase

final class RegistrationFirebaseModel {
    private let databaseModel = DatabaseModel()
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let userEmail = result?.user.email,
                  let userUID = result?.user.uid else {
                completion(.failure(FirebaseError.notFindUser))
                return
            }
            
            let newUser = UserModel(uid: userUID, email: userEmail, name: username, avatar: "")
            
            self.databaseModel.addUserInDatabase(name: username, email: userEmail, UID: userUID) { result in
                
                switch result {
                case .success(_):
                    print("[DEBUG:] User info add in database!")
                    
                case .failure(_):
                    print("[DEBUG:] Error writing document!")
                    
                }
            }
            completion(.success(newUser))
            
        }
    }
}
