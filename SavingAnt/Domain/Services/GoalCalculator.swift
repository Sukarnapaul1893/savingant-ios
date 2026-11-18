//
//  GoalCalculator.swift
//  SavingAnt
//

import Foundation

/// Pure savings maths. `nonisolated` because business logic
/// shouldn't depend on the UI thread.
nonisolated enum GoalCalculator {

    /// Fraction saved, from 0.0 to 1.0.
    static func progress(of goal: Goal) -> Double {
        guard goal.target > 0 else { return 0 }
        let ratio = NSDecimalNumber(decimal: goal.saved / goal.target).doubleValue
        return min(ratio, 1.0)
    }

    /// Amount still needed. Never negative.
    static func remaining(of goal: Goal) -> Decimal {
        max(goal.target - goal.saved, 0)
    }

    /// Amount to save per week to hit the deadline. nil if the deadline has passed.
    static func weeklyTarget(for goal: Goal, now: Date, calendar: Calendar = .current) -> Decimal? {
        let days = calendar.dateComponents([.day], from: now, to: goal.deadline).day ?? 0
        guard days > 0 else { return nil }
        let weeks = Decimal(days) / 7
        return remaining(of: goal) / weeks
    }
}
