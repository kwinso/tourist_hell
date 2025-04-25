//
//  AuthController.swift
//  tourist_hell
//
//  Created by Ruslan on 22.04.2025.
//

import Fluent

enum SortOrder: String, Codable {
    case asc, desc

    func toDirection() -> DatabaseQuery.Sort.Direction {
        switch self {
        case .asc:
            return .ascending
        case .desc:
            return .descending
        }
    }
}
