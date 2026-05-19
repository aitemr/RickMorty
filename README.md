# Rick and Morty — Dimension Guide

> iOS-приложение для просмотра персонажей, локаций и эпизодов мультсериала «Рик и Морти».  
> Данные загружаются из открытого [Rick and Morty API](https://rickandmortyapi.com/api).

---

## Особенности

- **Два режима интерфейса** — UIKit (MVC) и SwiftUI (MVVM) с выбором при первом запуске
- **Пагинация** — бесконечная прокрутка с загрузкой страниц по мере скролла
- **Избранное** — добавление персонажей, локаций и эпизодов в избранное
- **Анимации** — zoom-переход к деталям, параллакс-заголовок, spring-анимации
- **Фильтрация** — сегментированные контролы для фильтрации по статусу, типу, сезону
- **Тёмная тема** — полная поддержка Dark Mode
- **Accessibility** — метки доступности на всех интерактивных элементах
- **Launch Screen** — анимированный экран загрузки с логотипом приложения

---

## Архитектура

### UIKit — MVC (Model-View-Controller)

| Слой | Содержимое |
|------|-----------|
| **Models** | `RMCharacter`, `RMLocation`, `RMEpisode` |
| **Views** | `CharacterCell`, `LocationCell`, `EpisodeCell` |
| **Controllers** | Вью-контроллеры для списков и деталей |

### SwiftUI — MVVM (Model-View-ViewModel)

| Слой | Содержимое |
|------|-----------|
| **Models** | Те же структуры данных |
| **ViewModels** | Классы с макросом `@Observable` |
| **Views** | SwiftUI-экраны (списки, детали, избранное, настройки) |

---

## Структура проекта

```
RickMorty/
├── RickMortyApp.swift              — Точка входа, выбор UIKit/SwiftUI
├── Theme.swift                     — Централизованные цвета темы
│
├── Models/
│   ├── Character.swift             — RMCharacter, APIResponse, APIInfo
│   ├── Location.swift              — RMLocation, LocationResponse
│   └── Episode.swift               — RMEpisode, EpisodeResponse
│
├── Services/
│   ├── NetworkService.swift        — HTTP-запросы к API с пагинацией
│   ├── ImageLoader.swift           — Асинхронная загрузка и кэш (NSCache)
│   └── FavoritesManager.swift      — Управление избранным (UserDefaults)
│
├── Controllers/                    — UIKit вью-контроллеры
│   ├── MainTabBarController.swift
│   ├── CharactersViewController.swift
│   ├── LocationsViewController.swift
│   ├── EpisodesViewController.swift
│   ├── CharacterDetailViewController.swift
│   ├── LocationDetailViewController.swift
│   ├── EpisodeDetailViewController.swift
│   ├── FavoritesViewController.swift
│   └── SettingsViewController.swift
│
├── Views/                          — UIKit ячейки коллекций
│   ├── CharacterCell.swift
│   ├── LocationCell.swift
│   └── EpisodeCell.swift
│
└── SwiftUI/                        — SwiftUI реализация
    ├── SwiftUIMainTabView.swift
    ├── AppModeSelector.swift
    ├── CharactersListView.swift
    ├── LocationsListView.swift
    ├── EpisodesListView.swift
    ├── CharacterDetailView.swift
    ├── LocationDetailView.swift
    ├── EpisodeDetailView.swift
    ├── FavoritesView.swift
    ├── SettingsView.swift
    ├── ViewModels/
    │   ├── CharactersViewModel.swift
    │   ├── LocationsViewModel.swift
    │   ├── EpisodesViewModel.swift
    │   └── FavoritesViewModel.swift
    └── Components/
        ├── CachedAsyncImage.swift
        ├── CharacterCardView.swift
        ├── LocationCardView.swift
        ├── EpisodeCardView.swift
        └── InfoRowView.swift
```

---

## API

| Метод | Эндпоинт | Описание |
|-------|----------|----------|
| `GET` | `/character?page={n}` | Список персонажей |
| `GET` | `/location?page={n}` | Список локаций |
| `GET` | `/episode?page={n}` | Список эпизодов |

- **Базовый URL:** `https://rickandmortyapi.com/api`
- **Таймаут:** 30 секунд
- **Декодирование:** Generic-метод `fetch<T: Decodable>`

---

## Загрузка изображений

`ImageLoader` — синглтон с `NSCache` (лимит 200 объектов).

- **UIKit:** Ячейки показывают SF Symbol `person.crop.circle` как плейсхолдер
- **SwiftUI:** `CachedAsyncImage` использует тот же `ImageLoader` через `.task`

---

## Система избранного

`FavoritesManager` хранит ID в `UserDefaults` и отправляет `Notification` при изменении.

| Тип | Методы |
|-----|--------|
| Персонажи | `isCharacterFavorite(_:)`, `toggleCharacter(_:)` |
| Локации | `isLocationFavorite(_:)`, `toggleLocation(_:)` |
| Эпизоды | `isEpisodeFavorite(_:)`, `toggleEpisode(_:)` |

---

## Навигация

### UIKit
`MainTabBarController` → 5 вкладок, каждая в `UINavigationController`.  
Переход к деталям через `pushViewController`.

### SwiftUI
`SwiftUIMainTabView` → 5 вкладок через `TabView`.  
Навигация через `NavigationStack` + `.navigationDestination(for:)`.  
Zoom-переход: `.matchedTransitionSource` + `.navigationTransition(.zoom)`.

---

## Переключение UIKit / SwiftUI

- `@AppStorage("hasSelectedMode")` — выбрал ли пользователь режим
- `@AppStorage("useSwiftUI")` — текущий режим (`true` = SwiftUI)
- Переключить можно в **Settings → Switch to UIKit/SwiftUI**

---

## Тема оформления

```swift
enum Theme {
    static let accentColor       // UIColor — основной зелёный
    static let accentSwiftUI     // Color — SwiftUI-версия
    static let accentBackground  // UIColor — 10% прозрачность
}
```

---

## Требования

- **iOS 18.0+**
- **Xcode 26+**
- **Swift 6**

---

## Автор

Islam Temirbek — [@islamtemirbek](https://github.com/islamtemirbek)
