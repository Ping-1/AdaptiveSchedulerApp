//
//  ScheduleItem.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 01.02.2025.
//

import Foundation

struct ScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var notes: String?
}

