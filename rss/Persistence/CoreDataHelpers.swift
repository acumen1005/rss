//
//  CoreDataHelpers.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/30.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import CoreData



// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {
    
    func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
    }
    
    func configureAsUpdateContext() {
        mergePolicy = NSOverwriteMergePolicy
        undoManager = nil
    }
}
