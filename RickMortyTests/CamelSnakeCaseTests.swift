import Testing
@testable import RickMorty

struct CamelSnakeCaseTests {

    // MARK: - toCamelCase

    @Test func toCamelCaseBasic() {
        #expect(toCamelCase("hello_world") == "helloWorld")
    }

    @Test func toCamelCaseMultipleWords() {
        #expect(toCamelCase("hello_edabit") == "helloEdabit")
        #expect(toCamelCase("is_modal_open") == "isModalOpen")
    }

    @Test func toCamelCaseSingleWord() {
        #expect(toCamelCase("hello") == "hello")
    }

    @Test func toCamelCaseEmpty() {
        #expect(toCamelCase("") == "")
    }

    @Test func toCamelCaseLongChain() {
        #expect(toCamelCase("my_very_long_variable_name") == "myVeryLongVariableName")
    }

    // MARK: - toSnakeCase

    @Test func toSnakeCaseBasic() {
        #expect(toSnakeCase("helloWorld") == "hello_world")
    }

    @Test func toSnakeCaseMultipleWords() {
        #expect(toSnakeCase("helloEdabit") == "hello_edabit")
        #expect(toSnakeCase("isModalOpen") == "is_modal_open")
    }

    @Test func toSnakeCaseSingleWord() {
        #expect(toSnakeCase("hello") == "hello")
    }

    @Test func toSnakeCaseEmpty() {
        #expect(toSnakeCase("") == "")
    }

    @Test func toSnakeCaseLongChain() {
        #expect(toSnakeCase("myVeryLongVariableName") == "my_very_long_variable_name")
    }

    // MARK: - Round-trip

    @Test func roundTripCamelToSnakeToCamel() {
        let original = "helloWorld"
        #expect(toCamelCase(toSnakeCase(original)) == original)
    }

    @Test func roundTripSnakeToCamelToSnake() {
        let original = "hello_world"
        #expect(toSnakeCase(toCamelCase(original)) == original)
    }
}
