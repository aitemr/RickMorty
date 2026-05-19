import Foundation

// MARK: - Задача 1: camelCase ⇄ snake_case
//
// Конвертация между двумя стилями именования переменных:
// - camelCase (верблюжий регистр): helloWorld, isModalOpen
// - snake_case (змеиный регистр): hello_world, is_modal_open

/// Конвертирует строку из snake_case в camelCase.
///
/// Алгоритм:
/// 1. Разбивает строку по символу `_`
/// 2. Первое слово оставляет без изменений (в нижнем регистре)
/// 3. У остальных слов делает первую букву заглавной
/// 4. Склеивает все части в одну строку
///
/// - Parameter str: Строка в формате snake_case (например, `"hello_world"`).
/// - Returns: Строка в формате camelCase (например, `"helloWorld"`).
func toCamelCase(_ str: String) -> String {
    let components = str.split(separator: "_", omittingEmptySubsequences: false)
    guard let first = components.first else { return "" }

    let rest = components.dropFirst().map { word in
        word.prefix(1).uppercased() + word.dropFirst().lowercased()
    }

    return first.lowercased() + rest.joined()
}

/// Конвертирует строку из camelCase в snake_case.
///
/// Алгоритм:
/// 1. Проходит по каждому символу строки
/// 2. Если символ — заглавная буква и не первый в строке, добавляет `_` перед ним
/// 3. Переводит символ в нижний регистр
///
/// - Parameter str: Строка в формате camelCase (например, `"helloWorld"`).
/// - Returns: Строка в формате snake_case (например, `"hello_world"`).
func toSnakeCase(_ str: String) -> String {
    var result = ""

    for (index, character) in str.enumerated() {
        if character.isUppercase {
            if index > 0 {
                result += "_"
            }
            result += character.lowercased()
        } else {
            result += String(character)
        }
    }

    return result
}
