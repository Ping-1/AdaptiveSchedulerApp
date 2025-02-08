//
//  AddScheduleItemView.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 01.02.2025.
//

import SwiftUI

struct AddScheduleItemView: View {
    @ObservedObject var scheduleVM: ScheduleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Детали задачи")) {
                    TextField("Название", text: $title)
                    DatePicker("Начало", selection: $startTime, displayedComponents: [.hourAndMinute])
                    DatePicker("Конец", selection: $endTime, displayedComponents: [.hourAndMinute])
                    TextField("Заметки (опционально)", text: $notes)
                }
            }
            .navigationTitle("Добавить элемент")
            .navigationBarItems(leading: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Сохранить") {
                let newItem = ScheduleItem(title: title, startTime: startTime, endTime: endTime, notes: notes.isEmpty ? nil : notes)
                scheduleVM.addItem(newItem)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddScheduleItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleItemView(scheduleVM: ScheduleViewModel())
    }
}
