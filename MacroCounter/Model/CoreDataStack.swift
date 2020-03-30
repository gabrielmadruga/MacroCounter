//
//  CoreDataStack.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 3/25/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: self.modelName)
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)") }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

private var child_managedContext_objc_key: UInt8 = 0
private var grand_child_managedContext_objc_key: UInt8 = 0
extension UIViewController {
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        appDelegate.coreData.managedContext
    }
    
    func saveContext() {
        appDelegate.coreData.saveContext()
    }
    
    var childContext: NSManagedObjectContext {
        if let result = objc_getAssociatedObject(self, &child_managedContext_objc_key) as? NSManagedObjectContext {
            return result
        } else {
            let childManagedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            childManagedContext.parent = appDelegate.coreData.managedContext
            objc_setAssociatedObject(self, &child_managedContext_objc_key, childManagedContext, .OBJC_ASSOCIATION_RETAIN)
            return childManagedContext
        }
    }
    
    func setupGrandChildContext() {
        let grandChildManagedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        grandChildManagedContext.parent = childContext
        objc_setAssociatedObject(self, &grand_child_managedContext_objc_key, grandChildManagedContext, .OBJC_ASSOCIATION_RETAIN)
    }
    /// We want to be able to save so that we don't have to check for changes and instead use the context hasChanges
    /// This is used so that saving does not reach the root context, avoiding unesesary updates on the rest of the app.
    var grandChildContext: NSManagedObjectContext? {
        return objc_getAssociatedObject(self, &grand_child_managedContext_objc_key) as? NSManagedObjectContext
    }
    
}
