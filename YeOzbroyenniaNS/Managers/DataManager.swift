//
//  DataManager.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import Foundation


class DataManager {
    static let shared = DataManager()
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    //MARK: - Subcategory
    func getSubcategory(by category: String) -> Subcategory {
        var result = Subcategory(category: "", subcategories: [""])
        guard let path = Bundle.main.path(forResource: "subcategories", ofType: "json") else { return result}
        do {
            //let jsonData = try Data(contentsOf: URL(filePath: path))
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let subcategories = try decoder.decode([Subcategory].self, from: jsonData)
            let selectedSubcategory = subcategories.first { $0.category == category }
            result = selectedSubcategory!
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    //MARK: - Elements
    func getElements(by subcategory: String) -> Element {
        var result = Element(subcategory: "", items: [""], imagePath: [""])
        guard let path = Bundle.main.path(forResource: "elements", ofType: "json") else { return result}
        do {
            //let jsonData = try Data(contentsOf: URL(filePath: path))
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let elements = try decoder.decode([Element].self, from: jsonData)
            let selectedElement = elements.first { $0.subcategory == subcategory }
            result = selectedElement!
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    //MARK: - Item
    func getItem(by item: String) -> Item {
        var result = Item(item: "", images: [], property: [Property]())
        guard let path = Bundle.main.path(forResource: "allItems", ofType: "json") else { return result }
        do {
            //let jsonData = try Data(contentsOf: URL(filePath: path))
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let items = try decoder.decode([Item].self, from: jsonData)
            let selectedItem = items.first { $0.item == item }
            if selectedItem != nil {
                result = selectedItem!
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    //MARK: - Random
    func getRandom() -> [String] {
        var results = [String]()
        guard let path = Bundle.main.path(forResource: "allItems", ofType: "json") else { return [String]() }
        do {
            //let jsonData = try Data(contentsOf: URL(filePath: path))
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let items = try decoder.decode([Item].self, from: jsonData)
            let randomItems = items.shuffled().prefix(3)
            
            for item in randomItems {
                results.append(item.item)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return results
    }
    
    private lazy var allItems = getAll()
    //MARK: - Search
    func getSearchedItems(by query: String) -> [String] {
        let searchWords = query.lowercased().split(separator: " ")
        
        let filteredData = allItems.filter { item in
            let itemWords = item.lowercased().split(separator: " ")
            return searchWords.allSatisfy { searchWord in
                itemWords.contains(where: { $0.hasPrefix(searchWord) })
            }
        }
        
        return filteredData
    }
    
    
    //MARK: - Get All
    private func getAll() -> [String] {
        var results = [String]()
        guard let path = Bundle.main.path(forResource: "allItems", ofType: "json") else { return [String]() }
        do {
            //let jsonData = try Data(contentsOf: URL(filePath: path))
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            
            let items = try decoder.decode([Item].self, from: jsonData)
            results = items.map { $0.item }
        } catch {
            print(error.localizedDescription)
        }
        
        return results
    }
                                    
}
