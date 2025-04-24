//
//  Client.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//
import Fluent
import Vapor
import struct Foundation.UUID


final class Client: Model, @unchecked Sendable {
    static let schema = "clients"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "phone_number")
    var phoneNumber: String
    
    @Field(key: "age")
    var age: Int
    
    
    init() {}
    
    init(id: UUID? = nil, name: String, phoneNumber: String, age: Int) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.age = age
    }
    
    func toDTO() -> ClientDTO {
        return ClientDTO(with: self)
    }
}

struct ClientDTO: Content {
    var id: UUID?
    var name: String
    var phoneNumber: String
    var age: Int
    
    init(with client: Client) {
        self.id = client.id
        self.name = client.name
        self.phoneNumber = client.phoneNumber
        self.age = client.age
    }
}
