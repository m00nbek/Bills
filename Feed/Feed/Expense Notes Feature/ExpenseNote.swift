//
//  ExpenseNote.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import Foundation

public struct ExpenseNote: Equatable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    
    public init(id: UUID, message: String, createdAt: Date) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
    }
}
