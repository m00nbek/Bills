//
//  ManagedFeedExpense.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/10/23.
//

import CoreData

extension ManagedFeedExpense {
    static func expenses(from localFeed: [LocalFeedExpense], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedFeedExpense(context: context)
            managed.id = local.id
            managed.title = local.title
            managed.timestamp = local.timestamp
            managed.cost = local.cost
            managed.currency = local.currency.rawValue
            return managed
        })
    }

    var local: LocalFeedExpense {
        return LocalFeedExpense(id: id!, title: title!, timestamp: timestamp!, cost: cost, currency: .init(rawValue: currency!)!)
    }
}
