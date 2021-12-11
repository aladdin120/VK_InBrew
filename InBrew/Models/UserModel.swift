//
//  UserModel.swift
//  InBrew
//
//  Created by golub_dobra on 03.11.2021.
//


struct UserModel {
    var uid: String
    var email: String
    var name: String
    var avatar: String?
    var favourite: [String] = []
    
    init(uid: String, email: String, name: String, avatar: String?) {
        self.uid = uid
        self.email = email
        self.name = name
        self.avatar = avatar
    }
}
