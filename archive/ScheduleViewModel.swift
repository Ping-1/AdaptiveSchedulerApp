//
//  ScheduleViewModel.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 01.02.2025.
//

import SwiftUI

class ScheduleViewModel: ObservableObject {
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var showingAddItem = false
    
    func addItem(_ item: ScheduleItem) {
        scheduleItems.append(item)
    }
    
    func deleteItem(at offsets: IndexSet) {
        scheduleItems.remove(atOffsets: offsets)
    }
}
