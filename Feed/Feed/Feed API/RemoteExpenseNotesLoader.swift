//
//  RemoteExpenseNotesLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import Foundation

public final class RemoteExpenseNotesLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[ExpenseNote], Swift.Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteExpenseNotesLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ExpenseNotesMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
