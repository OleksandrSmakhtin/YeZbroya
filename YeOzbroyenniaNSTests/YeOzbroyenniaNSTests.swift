//
//  YeOzbroyenniaNSTests.swift
//  YeOzbroyenniaNSTests
//
//  Created by Oleksandr Smakhtin on 16.04.2023.
//

import XCTest
@testable import YeOzbroyenniaNS

final class YeOzbroyenniaNSTests: XCTestCase {

    var dataManager: DataManager!
        
        override func setUpWithError() throws {
            dataManager = DataManager.shared
        }

        override func tearDownWithError() throws {
            dataManager = nil
        }

        func testGetSubcategory() throws {
            let expectedCategory = "Стрілецька зброя"
            let subcategory = dataManager.getSubcategory(by: expectedCategory)
            
            XCTAssertEqual(subcategory.category, expectedCategory, "Category should match the expected category")
            XCTAssertFalse(subcategory.subcategories.isEmpty, "Subcategories should not be empty")
        }

        func testGetElements() throws {
            let expectedSubcategory = "Автомати"
            let element = dataManager.getElements(by: expectedSubcategory)
            
            XCTAssertEqual(element.subcategory, expectedSubcategory, "Subcategory should match the expected subcategory")
            XCTAssertFalse(element.items.isEmpty, "Items should not be empty")
        }

        func testGetItem() throws {
            let expectedItem = "Glock 17"
            let item = dataManager.getItem(by: expectedItem)
            
            XCTAssertEqual(item.item, expectedItem, "Item should match the expected item")
            XCTAssertFalse(item.property.isEmpty, "Properties should not be empty")
        }

        func testGetRandom() throws {
            let randomItems = dataManager.getRandom()
            
            XCTAssertEqual(randomItems.count, 3, "Should return exactly 3 random items")
            for item in randomItems {
                XCTAssertFalse(item.isEmpty, "Item names should not be empty")
            }
        }

        func testGetSearchedItems() throws {
            let query = "Glock 17"
            let searchResults = dataManager.getSearchedItems(by: query)
            
            XCTAssertFalse(searchResults.isEmpty, "Search results should not be empty")
            for result in searchResults {
                XCTAssertTrue(result.lowercased().contains(query.lowercased()), "Search results should contain the query")
            }
        }

}
