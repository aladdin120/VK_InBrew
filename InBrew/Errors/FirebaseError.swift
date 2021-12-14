//
//  FirebaseError.swift
//  InBrew
//
//  Created by golub_dobra on 03.11.2021.
//

enum FirebaseError: Error {
    case badLoginOrPass
    case notFindUser
    case emptyFields
    case badDataDuringRegistration
    case emptyDocumentData
    case notFindDocument
    case notFindData
    case canNotAddDocument
}

