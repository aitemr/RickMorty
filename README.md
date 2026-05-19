# Rick and Morty — Dimension Guide

> iOS-приложение для просмотра персонажей, локаций и эпизодов мультсериала «Рик и Морти».
> Данные загружаются из открытого [Rick and Morty API](https://rickandmortyapi.com/api).

---

## Особенности

- **Два режима интерфейса** — UIKit (MVC) и SwiftUI (MVVM) с выбором при первом запуске
- **Пагинация** — бесконечная прокрутка с загрузкой страниц по мере скролла
- **Избранное** — добавление персонажей, локаций и эпизодов в избранное (кнопка в навигационном баре)
- **Поиск** — встроенные поля поиска на страницах персонажей, локаций и эпизодов с пустым состоянием
- **Фильтрация** — сегментированный контрол на странице персонажей (ALL / ALIVE / DEAD)
- **Локализация** — поддержка английского и русского языков с переключением в настройках
- **Анимации** — zoom-переход к деталям, параллакс-заголовок, spring-анимации
- **Тёмная тема** — полная поддержка Dark Mode
- **Accessibility** — метки доступности на всех интерактивных элементах
- **Launch Screen** — анимированный экран загрузки с порталом и логотипом
- **Статус-бейдж** — статус персонажа (Alive/Dead/Unknown) отображается в центре навигационного бара

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
├── RickMortyApp.swift              — Точка входа, выбор UIKit/SwiftUI, Launch Screen
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
│   ├── FavoritesManager.swift      — Управление избранным (UserDefaults)
│   └── LocalizationManager.swift   — Локализация EN/RU (@Observable)
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
    ├── SwiftUIMainTabView.swift    — TabView с 5 вкладками
    ├── AppModeSelector.swift       — Экран выбора режима
    ├── LaunchScreenView.swift      — Анимированный экран загрузки
    ├── CharactersListView.swift    — Список персонажей + фильтр + поиск
    ├── LocationsListView.swift     — Список локаций + поиск
    ├── EpisodesListView.swift      — Список эпизодов + поиск
    ├── CharacterDetailView.swift   — Детали персонажа + параллакс
    ├── LocationDetailView.swift    — Детали локации
    ├── EpisodeDetailView.swift     — Детали эпизода
    ├── FavoritesView.swift         — Избранное (секции по типам)
    ├── SettingsView.swift          — Настройки (режим, язык, общие)
    ├── ViewModels/
    │   ├── CharactersViewModel.swift
    │   ├── LocationsViewModel.swift
    │   ├── EpisodesViewModel.swift
    │   └── FavoritesViewModel.swift
    └── Components/
        ├── CachedAsyncImage.swift  — Обёртка для загрузки изображений
        ├── CharacterCardView.swift — Карточка персонажа
        ├── LocationCardView.swift  — Карточка локации
        ├── EpisodeCardView.swift   — Карточка эпизода
        └── InfoRowView.swift       — Строка информации
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

## Поиск

На каждой странице списка встроено поле поиска в кастомном заголовке:

| Страница | Поиск по полям |
|----------|----------------|
| Персонажи | Имя, вид, локация |
| Локации | Название, тип, измерение |
| Эпизоды | Название, код эпизода, дата выхода |

- Клавиатура скрывается при скролле (`.scrollDismissesKeyboard(.immediately)`)
- Клавиатура скрывается при тапе вне поля ввода
- Пустое состояние поиска: иконка + «Нет результатов для "..."» + подсказка

---

## Система избранного

`FavoritesManager` хранит ID в `UserDefaults` и отправляет `Notification` при изменении.

| Тип | Методы |
|-----|--------|
| Персонажи | `isCharacterFavorite(_:)`, `toggleCharacter(_:)` |
| Локации | `isLocationFavorite(_:)`, `toggleLocation(_:)` |
| Эпизоды | `isEpisodeFavorite(_:)`, `toggleEpisode(_:)` |

Кнопка избранного (сердце) расположена в **навигационном баре** (`.toolbar`) на всех страницах деталей.

---

## Локализация

`LocalizationManager` — синглтон с макросом `@Observable`.

| Язык | Код |
|------|-----|
| English (по умолчанию) | `en` |
| Русский | `ru` |

- Язык хранится в `UserDefaults` под ключом `"appLanguage"`
- Переключение в **Настройки → Интерфейс → Язык**
- Изменения применяются мгновенно без перезапуска
- Локализованы: вкладки, заголовки, фильтры, поиск, детали, избранное, настройки, экран выбора режима

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

## Launch Screen

Анимированный экран загрузки (`LaunchScreenView`):
- Градиентный фон тёмно-зелёного цвета
- Концентрические кольца портала с вращением
- Светящийся круг с надписью «RM»
- Появление заголовка «The Rick and Morty» + «DIMENSION GUIDE»
- Автоматическое исчезновение через 1.8 секунд с fade-анимацией

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
