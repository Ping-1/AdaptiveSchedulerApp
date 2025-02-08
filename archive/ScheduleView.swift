//
//  ScheduleView.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 01.02.2025.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var scheduleVM = ScheduleViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(scheduleVM.scheduleItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        Text("Начало: \(item.startTime, style: .time)")
                        Text("Конец: \(item.endTime, style: .time)")
                        if let notes = item.notes, !notes.isEmpty {
                            Text("Заметки: \(notes)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: scheduleVM.deleteItem)
            }
            .navigationTitle("Моё расписание")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        scheduleVM.showingAddItem = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $scheduleVM.showingAddItem) {
                AddScheduleItemView(scheduleVM: scheduleVM)
            }
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
