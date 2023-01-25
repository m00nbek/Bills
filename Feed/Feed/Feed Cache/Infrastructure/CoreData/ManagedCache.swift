//
//  ManagedCache.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/10/23.
//

import CoreData

extension ManagedCache {
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try deleteCache(in: context)
        return ManagedCache(context: context)
    }
    
    var localFeed: [LocalFeedExpense] {
        return feed!.compactMap { ($0 as? ManagedFeedExpense)?.local }
    }
}
