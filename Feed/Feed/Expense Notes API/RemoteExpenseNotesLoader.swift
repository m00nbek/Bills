//
//  RemoteExpenseNotesLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import Foundation

public typealias RemoteExpenseNotesLoader = RemoteLoader<[ExpenseNote]>

public extension RemoteExpenseNotesLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ExpenseNotesMapper.map)
    }
}
