//
//  DOCUMENTATION.swift
//  RickMorty
//
//  Документация проекта на русском языке
//

// MARK: - Обзор проекта
//
// Rick and Morty Dimension Guide — iOS-приложение для просмотра персонажей,
// локаций и эпизодов из мультсериала "Рик и Морти".
// Данные загружаются из открытого Rick and Morty API (https://rickandmortyapi.com/api).
//
// Приложение поддерживает два режима интерфейса:
// - UIKit (классический императивный подход)
// - SwiftUI (современный декларативный подход)
//
// При первом запуске пользователь выбирает режим на экране AppModeSelector.
// Переключить режим можно позже на вкладке "Settings".

// MARK: - Архитектура
//
// UIKit: MVC (Model-View-Controller)
//   - Models: структуры данных (RMCharacter, RMLocation, RMEpisode)
//   - Views: ячейки коллекций (CharacterCell, LocationCell, EpisodeCell)
//   - Controllers: вью-контроллеры для списков и деталей
//
// SwiftUI: MVVM (Model-View-ViewModel)
//   - Models: те же структуры данных, что и в UIKit
//   - ViewModels: классы с макросом @Observable для управления состоянием
//   - Views: SwiftUI-экраны (списки, детали, избранное, настройки)

// MARK: - Структура файлов
//
// RickMorty/
// ├── RickMortyApp.swift          — Точка входа, выбор режима UIKit/SwiftUI
// ├── Theme.swift                 — Централизованные цвета и константы темы
// │
// ├── Models/
// │   ├── Character.swift         — RMCharacter, APIResponse, APIInfo
// │   ├── Location.swift          — RMLocation, LocationResponse
// │   └── Episode.swift           — RMEpisode, EpisodeResponse
// │
// ├── Services/
// │   ├── NetworkService.swift    — HTTP-запросы к API, пагинация
// │   ├── ImageLoader.swift       — Асинхронная загрузка и кэширование изображений (NSCache)
// │   └── FavoritesManager.swift  — Управление избранным через UserDefaults
// │
// ├── Controllers/                — UIKit вью-контроллеры
// │   ├── MainTabBarController.swift
// │   ├── CharactersViewController.swift
// │   ├── LocationsViewController.swift
// │   ├── EpisodesViewController.swift
// │   ├── CharacterDetailViewController.swift
// │   ├── LocationDetailViewController.swift
// │   ├── EpisodeDetailViewController.swift
// │   ├── FavoritesViewController.swift
// │   └── SettingsViewController.swift
// │
// ├── Views/                      — UIKit ячейки коллекций
// │   ├── CharacterCell.swift
// │   ├── LocationCell.swift
// │   └── EpisodeCell.swift
// │
// └── SwiftUI/                    — SwiftUI реализация
//     ├── SwiftUIMainTabView.swift    — TabView с 5 вкладками
//     ├── AppModeSelector.swift       — Экран выбора UIKit/SwiftUI
//     ├── CharactersListView.swift    — Список персонажей
//     ├── LocationsListView.swift     — Список локаций
//     ├── EpisodesListView.swift      — Список эпизодов
//     ├── CharacterDetailView.swift   — Детальная страница персонажа
//     ├── LocationDetailView.swift    — Детальная страница локации
//     ├── EpisodeDetailView.swift     — Детальная страница эпизода
//     ├── FavoritesView.swift         — Избранное
//     ├── SettingsView.swift          — Настройки
//     ├── ViewModels/
//     │   ├── CharactersViewModel.swift
//     │   ├── LocationsViewModel.swift
//     │   ├── EpisodesViewModel.swift
//     │   └── FavoritesViewModel.swift
//     └── Components/
//         ├── CachedAsyncImage.swift  — Кэшированная загрузка изображений
//         ├── CharacterCardView.swift — Карточка персонажа
//         ├── LocationCardView.swift  — Карточка локации
//         ├── EpisodeCardView.swift   — Карточка эпизода
//         └── InfoRowView.swift       — Строка информации для деталей

// MARK: - API интеграция
//
// Базовый URL: https://rickandmortyapi.com/api
//
// Эндпоинты:
//   GET /character?page={n}  — Список персонажей с пагинацией
//   GET /location?page={n}   — Список локаций с пагинацией
//   GET /episode?page={n}    — Список эпизодов с пагинацией
//
// NetworkService обрабатывает все HTTP-запросы.
// Он использует generic-метод fetch<T: Decodable> для декодирования ответов.
// Таймаут запроса: 30 секунд.
// Ошибки обрабатываются через enum NetworkError.

// MARK: - Загрузка изображений
//
// ImageLoader — синглтон для асинхронной загрузки и кэширования изображений.
// Используется NSCache с лимитом 200 объектов.
// В UIKit: ячейки показывают плейсхолдер (SF Symbol "person.crop.circle") во время загрузки.
// В SwiftUI: CachedAsyncImage использует тот же ImageLoader через .task модификатор.

// MARK: - Система избранного
//
// FavoritesManager — синглтон, хранит ID избранных элементов в UserDefaults.
// Поддерживает три типа: персонажи, локации, эпизоды.
// При изменении отправляет уведомление FavoritesManager.didChangeNotification.
// UIKit-контроллеры подписываются через NotificationCenter.
// SwiftUI-вьюхи используют .onReceive для обновления.

// MARK: - Навигация
//
// UIKit:
//   MainTabBarController → 5 вкладок (Characters, Locations, Episodes, Favorites, Settings)
//   Каждая вкладка обёрнута в UINavigationController.
//   Переход к детальным страницам через push в навигационный стек.
//
// SwiftUI:
//   SwiftUIMainTabView → 5 вкладок через TabView
//   Навигация через NavigationStack + navigationDestination(for:)

// MARK: - Пагинация
//
// Списки загружают данные постранично.
// UIKit: при прокрутке до конца коллекции загружается следующая страница.
//   Показывается спиннер в подвале коллекции.
// SwiftUI: .task модификатор на последнем элементе вызывает loadMoreIfNeeded().
//   Показывается ProgressView под списком.

// MARK: - Состояния загрузки
//
// Каждый список поддерживает три состояния:
// 1. Загрузка (спиннер по центру) — при первом запросе
// 2. Пустое состояние (иконка wifi.slash + кнопка "Retry") — при ошибке сети
// 3. Загрузка пагинации (спиннер внизу) — при загрузке следующих страниц

// MARK: - Переключение UIKit/SwiftUI
//
// @AppStorage("hasSelectedMode") — флаг, выбрал ли пользователь режим
// @AppStorage("useSwiftUI") — текущий выбранный режим (true = SwiftUI, false = UIKit)
//
// В RickMortyApp.swift:
//   - Если !hasSelectedMode → показать AppModeSelector
//   - Если useSwiftUI → показать SwiftUIMainTabView
//   - Иначе → показать MainTabBarRepresentable (UIKit)
//
// Переключить режим можно в Settings → "Switch to UIKit/SwiftUI"

// MARK: - Тема оформления
//
// Theme.swift содержит:
//   - Theme.accentColor (UIColor) — основной зелёный цвет
//   - Theme.accentSwiftUI (Color) — SwiftUI-версия акцентного цвета
//   - Theme.accentBackground (UIColor) — акцентный цвет с прозрачностью 10%
//
// Все элементы интерфейса используют эти константы для единообразия.

// MARK: - Доступность (Accessibility)
//
// Все ячейки имеют accessibilityLabel с именем и ключевой информацией.
// Кнопки избранного имеют accessibilityLabel ("Add to favorites" / "Remove from favorites").
// SwiftUI-карточки используют .accessibilityElement(children: .combine).
