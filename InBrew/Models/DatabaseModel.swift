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
        let _ = self.database.collection("users").document(UID).setData(["name": name, "email": email]) { err in
            if let err = err {
                print("[DEBUG:] Error writing document: \(err)")
            } else {
                print("[DEBUG:] Document successfully written!")
            }
        }
    }
}
