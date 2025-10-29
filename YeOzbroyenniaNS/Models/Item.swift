//
//  Item.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import Foundation

struct Item: Codable {
    let item: String
    let images: [String]?
    let property: [Property]
}

struct Property: Codable {
    let name: String
    let value: String
}
