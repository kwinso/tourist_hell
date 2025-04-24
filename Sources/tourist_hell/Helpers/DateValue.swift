//
//  DateValue.swift
//  tourist_hell
//
//  Created by Ruslan on 24.04.2025.
//

import Foundation

/// A protocol for providing a custom strategy for encoding and decoding dates.
///
/// `DateValueCodableStrategy` provides a generic strategy type that the `DateValue` property wrapper can use to inject
///  custom strategies for encoding and decoding date values.
public protocol DateValueCodableStrategy {
    associatedtype RawValue
    
    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

/// Decodes and encodes dates using a strategy type.
///
/// `@DateValue` decodes dates using a `DateValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct DateValue<Formatter: DateValueCodableStrategy> {
    public var wrappedValue: Date
    
    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }
}

extension DateValue: Decodable where Formatter.RawValue: Decodable {
    public init(from decoder: any Decoder) throws {
        let value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
    }
}

extension DateValue: Encodable where Formatter.RawValue: Encodable {
    public func encode(to encoder: any Encoder) throws {
        let value = Formatter.encode(wrappedValue)
        try value.encode(to: encoder)
    }
}

extension DateValue: Equatable {
    public static func == (lhs: DateValue<Formatter>, rhs: DateValue<Formatter>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension DateValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

/// Decodes and encodes dates using a strategy type.
///
/// `@DateValue` decodes dates using a `DateValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct OptionalDateValue<Formatter: DateValueCodableStrategy> {
    public var wrappedValue: Date?
    
    public init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalDateValue: Decodable where Formatter.RawValue: Decodable {
    public init(from decoder: any Decoder) throws {
        let value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
        
    }
}

extension OptionalDateValue: Encodable where Formatter.RawValue: Encodable {
    public func encode(to encoder: any Encoder) throws {
        if let optionalValue = self.wrappedValue {
            let value = Formatter.encode(optionalValue)
            try value.encode(to: encoder)
        }
    }
}

extension OptionalDateValue: Equatable {
    public static func == (lhs: OptionalDateValue<Formatter>, rhs: OptionalDateValue<Formatter>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension OptionalDateValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

/// Decodes `String` values as an ISO8601 `Date`.
///
/// `@ISO8601Date` relies on an `ISO8601DateFormatter` in order to decode `String` values into `Date`s. Encoding the `Date`
/// will encode the value into the original string value.
///
/// For example, decoding json data with a `String` representation  of `"1996-12-19T16:39:57-08:00"` produces a valid `Date`
/// representing 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC
/// (Pacific Standard Time).
public struct ISO8601Strategy: DateValueCodableStrategy {
    public static func decode(_ value: String) throws -> Date {
        guard let date = ISO8601DateFormatter().date(from: value) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
        return date
    }
    
    public static func encode(_ date: Date) -> String {
        return ISO8601DateFormatter().string(from: date)
    }
}
