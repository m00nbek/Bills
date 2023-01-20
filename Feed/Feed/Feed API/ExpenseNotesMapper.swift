//
//  ExpenseNotesMapper.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import Foundation

final class ExpenseNotesMapper {
   
   private struct Root: Decodable {
       let items: [RemoteFeedItem]
   }
   
   private static var OK_200: Int { return 200 }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
       
       let decoder = JSONDecoder()
       decoder.dateDecodingStrategy = .iso8601
       
       guard response.statusCode == OK_200,
             let root = try? decoder.decode(Root.self, from: data)
       else {
           throw RemoteExpenseNotesLoader.Error.invalidData
       }
       
       return root.items
   }
}
