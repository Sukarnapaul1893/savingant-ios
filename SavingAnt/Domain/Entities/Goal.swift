//
//  Goal.swift
//  SavingAnt
//

import Foundation

/// A savings goal. Pure domain model: no SwiftUI, no SwiftData.
/// `nonisolated` keeps it off the MainActor so it can be used anywhere.
nonisolated struct Goal: Identifiable, Equatable, Sendable {
    let id: UUID
    var name: String
    var target: Decimal
    var saved: Decimal
    var deadline: Date
}
