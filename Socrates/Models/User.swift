//
//  User.swift
//  Socrates
//
//  Created by David Jabech on 5/21/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//
import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
    let id: String?
    let username: String?
    let comments: Int?
    let opinions: Int?
    let facts: Int?
    let debateScore: Int?
}
