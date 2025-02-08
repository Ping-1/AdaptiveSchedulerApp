//
//  User Input View.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 02.02.2025.
//
/*
import SwiftUI

// Расширяем тип Int, чтобы использовать его как Identifiable
extension Int: Identifiable {
    public var id: Int { self }
}

// Модель для задачи расписания, переименованная для избежания конфликтов
struct UserScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var notes: String?
}

struct UserInputView: View {
    // Настройки пользователя
    @State private var wakeUpTime = Date()
    @State private var sleepTime = Date()
    
    // Расписание пользователя
    @State private var scheduleItems: [UserScheduleItem] = []
    
    // Флаги показа модальных окон
    @State private var isAddingTask = false
    // Для редактирования: сохраняем индекс редактируемого элемента, если nil – редактирование не активно
    @State private var editingItemIndex: Int? = nil
    
    @AppStorage("timeFormat") private var timeFormat: TimeFormat = .twentyFourHour
    
    var body: some View {
        NavigationView {
            Form {
                // Секция настроек
                Section(header: Text("Настройки")) {
                    DatePicker("Время подъёма", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                    DatePicker("Время отхода ко сну", selection: $sleepTime, displayedComponents: .hourAndMinute)
                }
                
                // Секция расписания
                Section(header: Text("Расписание")) {
                    if scheduleItems.isEmpty {
                        Text("Расписание пока пусто.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(scheduleItems.indices, id: \.self) { index in
                            let item = scheduleItems[index]
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.headline)
                                Text("Начало: \(item.startTime, formatter: Self.timeFormatter)")
                                Text("Конец: \(item.endTime, formatter: Self.timeFormatter)")
                                if let notes = item.notes, !notes.isEmpty {
                                    Text("Заметки: \(notes)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button("Изменить") {
                                    editingItemIndex = index
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete(perform: deleteItem)
                    }
                    
                    Button(action: {
                        isAddingTask = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Добавить задачу")
                        }
                    }
                }
            }
            .navigationTitle("Настройки и Расписание")
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(isPresented: $isAddingTask, addTaskAction: addTask)
            }
            .sheet(item: $editingItemIndex) { index in
                EditTaskView(scheduleItem: $scheduleItems[index])
            }
        }
    }
    
    // Удаление задачи из расписания
    func deleteItem(at offsets: IndexSet) {
        scheduleItems.remove(atOffsets: offsets)
    }
    
    // Добавление новой задачи
    func addTask(title: String, start: Date, end: Date, notes: String?) {
        let newItem = UserScheduleItem(title: title, startTime: start, endTime: end, notes: notes)
        scheduleItems.append(newItem)
    }
    
    // Форматтер времени для отображения в расписании
    static let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.timeStyle = .short
       return formatter
    }()
}

// Представление для добавления новой задачи
struct AddTaskView: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var notes = ""
    
    var addTaskAction: (String, Date, Date, String?) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Новая задача")) {
                    TextField("Название задачи", text: $title)
                    DatePicker("Начало", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $endTime, displayedComponents: .hourAndMinute)
                    TextField("Заметки (опционально)", text: $notes)
                }
            }
            .navigationTitle("Добавить задачу")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        addTaskAction(title, startTime, endTime, notes.isEmpty ? nil : notes)
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct EditTaskView: View {
    @Binding var scheduleItem: UserScheduleItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Редактировать задачу")) {
                    TextField("Название задачи", text: $scheduleItem.title)
                    DatePicker("Начало", selection: $scheduleItem.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $scheduleItem.endTime, displayedComponents: .hourAndMinute)
                    TextField("Заметки (опционально)", text: Binding(
                        get: { scheduleItem.notes ?? "" },
                        set: { scheduleItem.notes = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .navigationTitle("Редактировать задачу")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}*/
