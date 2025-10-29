//
//  CoreDataManager.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 20.04.2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK: - Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Add
    func addItem(with title: String) {
        let item = CoreItem(context: context)
        item.title = title
        do {
            try context.save()
            print("Successfully saved Item to CoreData")
        } catch {
            print("Failed to add Item to CoreData due to: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Fetch
    func fetchItems() -> [String] {
        var results = [String]()
        let request = CoreItem.fetchRequest()
        do {
            let items = try context.fetch(request)
            results = items.map({ item in
                guard let title = item.title else { return ""}
                return title
            })
            print("Successfully fetched Items from CoreData")
        } catch {
            print("Failed to fetch Items from CoreData due to: \(error.localizedDescription)")
        }
        return results
    }
    
    //MARK: - Delete
    func deleteItem(with title: String) {
        let request = CoreItem.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            if let item = items.first {
                context.delete(item)
                try context.save()
            }
        } catch {
            print("Error fetching or deleting item: \(error)")
        }
    }
    
    //MARK: - Exist
    func isItemExists(with title: String) -> Bool {
        let request = CoreItem.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        do {
            let items = try context.fetch(request)
            return !items.isEmpty
        } catch {
            print("Error fetching items: \(error)")
            return false
        }
        
    }
}
