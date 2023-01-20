//
//  ExpenseNotesMapper.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import Foundation

final class ExpenseNotesMapper {
    
    private struct Root: Decodable {
        private let items: [Item]
        
        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
        }
        
        var comments: [ExpenseNote] {
            items.map { ExpenseNote(id: $0.id, message: $0.message, createdAt: $0.created_at) }
        }
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ExpenseNote] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw RemoteExpenseNotesLoader.Error.invalidData
        }
        
        return root.comments
    }
    
    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200...299).contains(response.statusCode)
    }
}
