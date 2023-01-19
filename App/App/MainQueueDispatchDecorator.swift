//
//  MainQueueDispatchDecorator.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/16/23.
//

import Feed
import FeediOS

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}
