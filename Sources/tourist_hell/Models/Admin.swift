//
//  Admin.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//
import Fluent
import struct Foundation.UUID


final class Admin: Model, @unchecked Sendable {
    static let schema = "admins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() {}
    
    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
    
}
