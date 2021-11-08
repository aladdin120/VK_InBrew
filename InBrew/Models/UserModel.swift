//
//  UserModel.swift
//  InBrew
//
//  Created by golub_dobra on 03.11.2021.
//


struct UserModel {
    var uid: String
    var email: String
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
