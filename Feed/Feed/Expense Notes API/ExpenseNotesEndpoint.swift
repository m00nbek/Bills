//
//  ExpenseNotesEndpoint.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import Foundation

public enum ExpenseNotesEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/expense/\(id)/notes")
        }
    }
}
