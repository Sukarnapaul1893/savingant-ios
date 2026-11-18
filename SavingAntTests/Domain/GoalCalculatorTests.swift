//
//  GoalCalculatorTests.swift
//  SavingAntTests
//

import XCTest
@testable import SavingAnt

final class GoalCalculatorTests: XCTestCase {

    // Fixed date + UTC calendar so tests give the same result on your Mac and on CI
    private let now = Date(timeIntervalSince1970: 0)
    private let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    private func makeGoal(target: Decimal, saved: Decimal, daysLeft: Int) -> Goal {
        Goal(id: UUID(),
             name: "Laptop",
             target: target,
             saved: saved,
             deadline: calendar.date(byAdding: .day, value: daysLeft, to: now)!)
    }

    func test_progress_isSavedDividedByTarget() {
        let goal = makeGoal(target: 1200, saved: 300, daysLeft: 84)
        XCTAssertEqual(GoalCalculator.progress(of: goal), 0.25, accuracy: 0.0001)
    }

    func test_progress_capsAtOneWhenOverSaved() {
        let goal = makeGoal(target: 1200, saved: 1500, daysLeft: 84)
        XCTAssertEqual(GoalCalculator.progress(of: goal), 1.0, accuracy: 0.0001)
    }

    func test_progress_isZeroWhenTargetIsZero() {
        let goal = makeGoal(target: 0, saved: 100, daysLeft: 84)
        XCTAssertEqual(GoalCalculator.progress(of: goal), 0, accuracy: 0.0001)
    }

    func test_weeklyTarget_splitsRemainingAcrossWeeksLeft() {
        let goal = makeGoal(target: 1200, saved: 300, daysLeft: 84)   // 12 weeks
        XCTAssertEqual(GoalCalculator.weeklyTarget(for: goal, now: now, calendar: calendar), 75)
    }

    func test_weeklyTarget_isNilWhenDeadlinePassed() {
        let goal = makeGoal(target: 1200, saved: 300, daysLeft: -1)
        XCTAssertNil(GoalCalculator.weeklyTarget(for: goal, now: now, calendar: calendar))
    }
}
