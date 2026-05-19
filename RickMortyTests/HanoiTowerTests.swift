import Foundation
import Testing
@testable import RickMorty

struct HanoiTowerTests {

    // MARK: - Move count (2^n - 1)

    @Test func oneDiskMoveCount() {
        #expect(hanoiTower(1).count == 1)
    }

    @Test func twoDisksMoveCount() {
        #expect(hanoiTower(2).count == 3)
    }

    @Test func threeDisksMoveCount() {
        #expect(hanoiTower(3).count == 7)
    }

    @Test func fiveDisksMoveCount() {
        #expect(hanoiTower(5).count == 31)
    }

    // MARK: - Exact output for n = 2

    @Test func twoDisksExactMoves() {
        let expected = [
            "Диск 1 с башни 1 переложить в башню 2",
            "Диск 2 с башни 1 переложить в башню 3",
            "Диск 1 с башни 2 переложить в башню 3"
        ]
        #expect(hanoiTower(2) == expected)
    }

    // MARK: - Exact output for n = 1

    @Test func oneDiskExactMove() {
        let expected = ["Диск 1 с башни 1 переложить в башню 3"]
        #expect(hanoiTower(1) == expected)
    }

    // MARK: - Sample output for n = 5 (first and last moves)

    @Test func fiveDisksFirstMove() {
        let moves = hanoiTower(5)
        #expect(moves.first == "Диск 1 с башни 1 переложить в башню 3")
    }

    @Test func fiveDisksLastMove() {
        let moves = hanoiTower(5)
        #expect(moves.last == "Диск 1 с башни 1 переложить в башню 3")
    }

    // MARK: - Validity check: no larger disk placed on smaller

    @Test func threeDisksValidMoves() {
        let moves = hanoiTower(3)
        // Simulate the puzzle and verify no invalid placement occurs
        var towers: [[Int]] = [[3, 2, 1], [], []]

        for move in moves {
            let parts = move.components(separatedBy: " ")
            // "Диск X с башни Y переложить в башню Z"
            guard let disk = Int(parts[1]),
                  let from = Int(parts[4]),
                  let to = Int(parts[8]) else {
                Issue.record("Failed to parse move: \(move)")
                return
            }

            let fromIndex = from - 1
            let toIndex = to - 1

            // The disk being moved must be on top of the source tower
            #expect(towers[fromIndex].last == disk)
            towers[fromIndex].removeLast()

            // If target tower is not empty, the top disk must be larger
            if let topDisk = towers[toIndex].last {
                #expect(topDisk > disk, "Invalid move: disk \(disk) placed on disk \(topDisk)")
            }

            towers[toIndex].append(disk)
        }

        // All disks should end up on tower 3
        #expect(towers[0].isEmpty)
        #expect(towers[1].isEmpty)
        #expect(towers[2] == [3, 2, 1])
    }
}
