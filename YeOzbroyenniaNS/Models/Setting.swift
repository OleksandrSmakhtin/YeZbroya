//
//  Setting.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 20.04.2023.
//

import Foundation

enum SettingType {
    case about
    case favorite
    case proposition
    case rate
    case share
    case thank
    case cache
}

struct Setting {
    let type: SettingType
    let image: String
    let title: String
}

class SettingsData {
    static let shared = SettingsData()
    
    func getSettings() -> [Setting] {
        let settings = [
            Setting(type: .favorite, image: "heart", title: "Обране"),
            Setting(type: .about, image: "exclamationmark.circle", title: "Про додаток"),
            Setting(type: .proposition, image: "lightbulb", title: "Ваші пропозиції"),
            Setting(type: .rate, image: "hand.thumbsup", title: "Оцінити додаток"),
            Setting(type: .share, image: "square.and.arrow.up", title: "Поділитися додатком"),
            Setting(type: .cache, image: "cloud", title: "Видалити кеш"),
        ]
        return settings
    }
}
