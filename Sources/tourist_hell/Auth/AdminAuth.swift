//
//  File.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Vapor
import Fluent

extension Admin: ModelAuthenticatable {
    static let usernameKey: KeyPath<Admin, Field<String>> = \Admin.$username
    
    static let passwordHashKey: KeyPath<Admin, Field<String>> = \Admin.$passwordHash

    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
