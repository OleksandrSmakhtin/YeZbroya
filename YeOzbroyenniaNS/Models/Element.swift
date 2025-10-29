//
//  Element.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 18.04.2023.
//

import Foundation

struct Element: Codable {
    let subcategory: String
    let items: [String]
    let imagePath: [String]?
}
