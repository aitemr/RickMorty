# Rick and Morty — Dimension Guide

## Алгоритмические задачи

Папка [`Tasks/`](RickMorty/Tasks/) содержит решения алгоритмических задач на Swift. Каждая задача покрыта юнит-тестами (Swift Testing framework).

### Задача 1 — camelCase ⇄ snake_case

> **Файл:** [`CamelSnakeCase.swift`](RickMorty/Tasks/CamelSnakeCase.swift)
> **Тесты:** [`CamelSnakeCaseTests.swift`](RickMortyTests/CamelSnakeCaseTests.swift)

Конвертация между двумя популярными стилями именования переменных:

| Функция | Вход | Выход |
|---------|------|-------|
| `toCamelCase(_:)` | `"hello_world"` | `"helloWorld"` |
| `toSnakeCase(_:)` | `"helloWorld"` | `"hello_world"` |

**Как работает `toCamelCase`:**
1. Разбивает строку по символу `_` на массив слов
2. Первое слово оставляет в нижнем регистре
3. У каждого последующего слова делает первую букву заглавной
4. Склеивает всё в одну строку

**Как работает `toSnakeCase`:**
1. Проходит посимвольно по строке
2. Если символ — заглавная буква и это не начало строки, добавляет `_` перед ним
3. Переводит символ в нижний регистр

**Примеры:**
```
toCamelCase("is_modal_open")         → "isModalOpen"
toSnakeCase("myVeryLongVariableName") → "my_very_long_variable_name"
```

**Тесты (12 шт.):** базовые кейсы, множественные слова, одно слово, пустая строка, длинные цепочки, round-trip (туда-обратно).

---

### Задача 2 — Ханойские башни

> **Файл:** [`HanoiTower.swift`](RickMorty/Tasks/HanoiTower.swift)
> **Тесты:** [`HanoiTowerTests.swift`](RickMortyTests/HanoiTowerTests.swift)

Классическая математическая головоломка: переместить `n` дисков с башни 1 на башню 3, используя башню 2 как вспомогательную. Диск большего размера нельзя класть на меньший.

| Функция | Описание |
|---------|----------|
| `hanoiTower(_:)` | Возвращает массив ходов `[String]` |
| `printHanoiTower(_:)` | Печатает ходы в консоль |

**Формат вывода:** `Диск a с башни b переложить в башню c`

**Как работает алгоритм (рекурсия):**
1. Чтобы переместить `n` дисков с башни A на башню C:
   - Переместить `n-1` дисков с A на B (используя C как вспомогательную)
   - Переместить диск `n` с A на C
   - Переместить `n-1` дисков с B на C (используя A как вспомогательную)
2. Базовый случай: если дисков 0 — ничего не делать
3. Минимальное количество ходов: **2ⁿ − 1**

**Пример для n = 2 (3 хода):**
```
Диск 1 с башни 1 переложить в башню 2
Диск 2 с башни 1 переложить в башню 3
Диск 1 с башни 2 переложить в башню 3
```

**Ограничения:** 0 < n < 100

**Тесты (9 шт.):** подсчёт ходов (2ⁿ−1), точный вывод для n=1 и n=2, первый/последний ход для n=5, симуляция головоломки с проверкой валидности всех перемещений.

---


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
├── Tasks/                          — Алгоритмические задачи
│   ├── CamelSnakeCase.swift       — Конвертация camelCase ⇄ snake_case
│   └── HanoiTower.swift           — Ханойские башни
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
