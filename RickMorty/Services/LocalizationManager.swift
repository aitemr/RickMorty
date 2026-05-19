//
//  LocalizationManager.swift
//  RickMorty
//

import SwiftUI

@Observable
final class LocalizationManager {
    static let shared = LocalizationManager()

    var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "appLanguage")
        }
    }

    private init() {
        self.language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    }

    // MARK: - Localized Strings

    func string(_ key: String) -> String {
        strings[language]?[key] ?? strings["en"]?[key] ?? key
    }

    private let strings: [String: [String: String]] = [
        "en": [
            // Tabs
            "tab.characters": "Characters",
            "tab.locations": "Locations",
            "tab.episodes": "Episodes",
            "tab.favorites": "Favorites",
            "tab.settings": "Settings",

            // Characters
            "characters.title.the": "The ",
            "characters.title.name": "Rick and Morty",
            "characters.subtitle": "DIMENSION GUIDE",
            "characters.filter.all": "ALL",
            "characters.filter.alive": "ALIVE",
            "characters.filter.dead": "DEAD",
            "characters.search": "Search characters",

            // Locations
            "locations.title": "Locations",
            "locations.search": "Search locations",

            // Episodes
            "episodes.title": "Episodes",
            "episodes.search": "Search episodes",

            // Detail - Character
            "detail.species": "Species",
            "detail.gender": "Gender",
            "detail.origin": "Origin",
            "detail.location": "Location",
            "detail.episodes": "Episodes",
            "detail.episodes.count": "episode(s)",

            // Detail - Location
            "detail.type": "Type",
            "detail.dimension": "Dimension",
            "detail.residents": "Residents",
            "detail.residents.count": "resident(s)",

            // Detail - Episode
            "detail.airDate": "Air Date",
            "detail.episodeCode": "Episode Code",
            "detail.characters": "Characters",
            "detail.characters.count": "character(s)",

            // Favorites
            "favorites.title": "Favorites",
            "favorites.empty": "No favorites yet",
            "favorites.hint": "Tap the heart icon on any item to add it here",

            // Search
            "search.noResults": "No results for",
            "search.tryDifferent": "Try a different search term",

            // Empty State
            "empty.noData": "No data available",
            "empty.retry": "Retry",

            // Settings
            "settings.title": "Settings",
            "settings.interface": "Interface",
            "settings.uiMode": "UI Mode",
            "settings.switchTo": "Switch to",
            "settings.language": "Language",
            "settings.general": "General",
            "settings.shareApp": "Share App",
            "settings.rateUs": "Rate Us",
            "settings.supportUs": "Support Us",
            "settings.information": "Information",
            "settings.privacyPolicy": "Privacy Policy",
            "settings.contactUs": "Contact Us",
            "settings.appVersion": "App Version",

            // Accessibility
            "a11y.removeFromFavorites": "Remove from favorites",
            "a11y.addToFavorites": "Add to favorites",

            // App Mode Selector
            "modeSelector.title": "Rick and Morty",
            "modeSelector.subtitle": "Choose your interface",
            "modeSelector.swiftui": "SwiftUI",
            "modeSelector.swiftui.desc": "Modern declarative UI",
            "modeSelector.uikit": "UIKit",
            "modeSelector.uikit.desc": "Classic imperative UI",
            "modeSelector.changeLater": "You can change this later in Settings",
        ],
        "ru": [
            // Tabs
            "tab.characters": "Персонажи",
            "tab.locations": "Локации",
            "tab.episodes": "Эпизоды",
            "tab.favorites": "Избранное",
            "tab.settings": "Настройки",

            // Characters
            "characters.title.the": "",
            "characters.title.name": "Рик и Морти",
            "characters.subtitle": "ПУТЕВОДИТЕЛЬ ПО ИЗМЕРЕНИЯМ",
            "characters.filter.all": "ВСЕ",
            "characters.filter.alive": "ЖИВЫЕ",
            "characters.filter.dead": "МЁРТВЫЕ",
            "characters.search": "Поиск персонажей",

            // Locations
            "locations.title": "Локации",
            "locations.search": "Поиск локаций",

            // Episodes
            "episodes.title": "Эпизоды",
            "episodes.search": "Поиск эпизодов",

            // Detail - Character
            "detail.species": "Вид",
            "detail.gender": "Пол",
            "detail.origin": "Происхождение",
            "detail.location": "Местоположение",
            "detail.episodes": "Эпизоды",
            "detail.episodes.count": "эпизод(ов)",

            // Detail - Location
            "detail.type": "Тип",
            "detail.dimension": "Измерение",
            "detail.residents": "Жители",
            "detail.residents.count": "житель(ей)",

            // Detail - Episode
            "detail.airDate": "Дата выхода",
            "detail.episodeCode": "Код эпизода",
            "detail.characters": "Персонажи",
            "detail.characters.count": "персонаж(ей)",

            // Favorites
            "favorites.title": "Избранное",
            "favorites.empty": "Нет избранного",
            "favorites.hint": "Нажмите на сердечко, чтобы добавить сюда",

            // Search
            "search.noResults": "Нет результатов для",
            "search.tryDifferent": "Попробуйте другой запрос",

            // Empty State
            "empty.noData": "Нет данных",
            "empty.retry": "Повторить",

            // Settings
            "settings.title": "Настройки",
            "settings.interface": "Интерфейс",
            "settings.uiMode": "Режим UI",
            "settings.switchTo": "Переключить на",
            "settings.language": "Язык",
            "settings.general": "Основные",
            "settings.shareApp": "Поделиться",
            "settings.rateUs": "Оценить",
            "settings.supportUs": "Поддержать",
            "settings.information": "Информация",
            "settings.privacyPolicy": "Политика конфиденциальности",
            "settings.contactUs": "Связаться с нами",
            "settings.appVersion": "Версия приложения",

            // Accessibility
            "a11y.removeFromFavorites": "Удалить из избранного",
            "a11y.addToFavorites": "Добавить в избранное",

            // App Mode Selector
            "modeSelector.title": "Рик и Морти",
            "modeSelector.subtitle": "Выберите интерфейс",
            "modeSelector.swiftui": "SwiftUI",
            "modeSelector.swiftui.desc": "Современный декларативный UI",
            "modeSelector.uikit": "UIKit",
            "modeSelector.uikit.desc": "Классический императивный UI",
            "modeSelector.changeLater": "Можно изменить позже в Настройках",
        ],
    ]
}
