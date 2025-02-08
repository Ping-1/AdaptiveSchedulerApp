//
//  User Input View.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 02.02.2025.
//
/*
import SwiftUI

// Перечисление для повтора задач
enum RepeatInterval: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case none = "Нет"
    case daily = "Ежедневно"
    case weekly = "Еженедельно"
    case monthly = "Ежемесячно"
}

// Расширяем тип Int, чтобы использовать его как Identifiable
extension Int: Identifiable {
    public var id: Int { self }
}

// Модель для задачи расписания
struct UserScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var notes: String?
    
    var isCompleted: Bool = false              // Отметка выполнения задачи
    var repeatInterval: RepeatInterval = .none  // Интервал повторения задачи
}

struct UserInputView: View {
    // Настройки пользователя
    @State private var wakeUpTime = Date()
    @State private var sleepTime = Date()
    
    // Расписание пользователя
    @State private var scheduleItems: [UserScheduleItem] = []
    
    // Флаги показа модальных окон
    @State private var isAddingTask = false
    // Для редактирования: сохраняем индекс редактируемой задачи
    @State private var editingItemIndex: Int? = nil
    
    // Состояние строки поиска
    @State private var searchText: String = ""
    
    // Система достижений: счётчик выполненных задач
    @State private var completedCount: Int = 0
    @State private var showAchievementAlert: Bool = false
    
    // Форматтер времени для отображения в расписании
    static let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.timeStyle = .short
       return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // Секция настроек
                    Section(header: Text("Настройки")) {
                        DatePicker("Время подъёма", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        DatePicker("Время отхода ко сну", selection: $sleepTime, displayedComponents: .hourAndMinute)
                    }
                    
                    // Секция расписания
                    Section(header: Text("Расписание")) {
                        if filteredTasks.isEmpty {
                            Text("Расписание пока пусто.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(filteredTasks.indices, id: \.self) { index in
                                // Так как список фильтруется, находим реальный индекс задания
                                let task = filteredTasks[index]
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(task.title)
                                            .font(.headline)
                                            .strikethrough(task.isCompleted, color: .gray)
                                        Spacer()
                                        if task.isCompleted {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    Text("Начало: \(task.startTime, formatter: Self.timeFormatter)")
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .strikethrough(task.isCompleted, color: .gray)
                                    Text("Конец: \(task.endTime, formatter: Self.timeFormatter)")
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .strikethrough(task.isCompleted, color: .gray)
                                    if let notes = task.notes, !notes.isEmpty {
                                        Text("Заметки: \(notes)")
                                            .font(.subheadline)
                                            .foregroundColor(task.isCompleted ? .gray : .secondary)
                                            .strikethrough(task.isCompleted, color: .gray)
                                    }
                                    if task.repeatInterval != .none {
                                        Text("Повтор: \(task.repeatInterval.rawValue)")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(5)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                                .transition(.slide)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button("Изменить") {
                                        if let index = scheduleItems.firstIndex(where: { $0.id == task.id }) {
                                            editingItemIndex = index
                                        }
                                    }
                                    .tint(.blue)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        if let index = scheduleItems.firstIndex(where: { $0.id == task.id }) {
                                            withAnimation {
                                                toggleTaskCompletion(at: index)
                                            }
                                        }
                                    } label: {
                                        if task.isCompleted {
                                            Label("Вернуть", systemImage: "arrow.uturn.left")
                                        } else {
                                            Label("Выполнено", systemImage: "checkmark")
                                        }
                                    }
                                    .tint(task.isCompleted ? .orange : .green)
                                }
                            }
                            .onDelete(perform: deleteItem)
                            .onMove(perform: moveItem)
                        }
                    }
                }
                // Поиск по названию задачи
                .searchable(text: $searchText, prompt: "Найти задачу")
                .navigationTitle("Расписание")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isAddingTask = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                // Отображение информационного блока (система достижений)
                AchievementView(completedCount: completedCount)
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(isPresented: $isAddingTask, addTaskAction: addTask)
            }
            .sheet(item: $editingItemIndex) { index in
                EditTaskView(scheduleItem: $scheduleItems[index])
            }
            .alert("Поздравляем!", isPresented: $showAchievementAlert, actions: {
                Button("ОК", role: .cancel) {}
            }, message: {
                Text("Вы выполнили 5 задач! Отличная работа!")
            })
        }
    }
    
    // Отфильтрованный и отсортированный список задач (по времени начала)
    var filteredTasks: [UserScheduleItem] {
        let filtered: [UserScheduleItem]
        if searchText.isEmpty {
            filtered = scheduleItems
        } else {
            filtered = scheduleItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        return filtered.sorted { $0.startTime < $1.startTime }
    }
    
    // Удаление задачи с анимацией
    func deleteItem(at offsets: IndexSet) {
        withAnimation {
            scheduleItems.remove(atOffsets: offsets)
        }
    }
    
    // Перемещение задачи (drag & drop)
    func moveItem(from source: IndexSet, to destination: Int) {
        withAnimation {
            scheduleItems.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    // Функция добавления новой задачи
    func addTask(title: String, start: Date, end: Date, notes: String?, repeatInterval: RepeatInterval) {
        guard start < end else { return }
        let newItem = UserScheduleItem(title: title,
                                       startTime: start,
                                       endTime: end,
                                       notes: notes,
                                       repeatInterval: repeatInterval)
        withAnimation {
            scheduleItems.append(newItem)
        }
    }
    
    // Переключение состояния выполнения задачи с анимацией
    func toggleTaskCompletion(at index: Int) {
        scheduleItems[index].isCompleted.toggle()
        if scheduleItems[index].isCompleted {
            completedCount += 1
            // Если достигнуто 5 выполненных задач, показываем оповещение
            if completedCount == 5 {
                showAchievementAlert = true
            }
        } else {
            completedCount = max(0, completedCount - 1)
        }
        
        // Если задача имеет повтор, добавляем следующее её вхождение
        if scheduleItems[index].isCompleted && scheduleItems[index].repeatInterval != .none {
            let nextTask = nextOccurrence(for: scheduleItems[index])
            withAnimation {
                scheduleItems.append(nextTask)
            }
        }
    }
    
    // Вычисление следующего повторения задачи
    func nextOccurrence(for task: UserScheduleItem) -> UserScheduleItem {
        let calendar = Calendar.current
        var newStart = task.startTime, newEnd = task.endTime
        switch task.repeatInterval {
        case .daily:
            newStart = calendar.date(byAdding: .day, value: 1, to: task.startTime) ?? task.startTime
            newEnd = calendar.date(byAdding: .day, value: 1, to: task.endTime) ?? task.endTime
        case .weekly:
            newStart = calendar.date(byAdding: .day, value: 7, to: task.startTime) ?? task.startTime
            newEnd = calendar.date(byAdding: .day, value: 7, to: task.endTime) ?? task.endTime
        case .monthly:
            newStart = calendar.date(byAdding: .month, value: 1, to: task.startTime) ?? task.startTime
            newEnd = calendar.date(byAdding: .month, value: 1, to: task.endTime) ?? task.endTime
        default:
            break
        }
        return UserScheduleItem(title: task.title,
                                startTime: newStart,
                                endTime: newEnd,
                                notes: task.notes,
                                repeatInterval: task.repeatInterval)
    }
}

// Дополнительное представление для анимированного эмодзи «салют»
struct FireworkAnimationView: View {
    @State private var animate = false
    var body: some View {
        Text("🎆")
            .font(.system(size: 50))
            .scaleEffect(animate ? 1.2 : 0.5)
            .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
            .onAppear {
                animate = true
            }
    }
}

// Представление для отображения достижений (счётчика выполненных задач и анимированного эмодзи «салют»)
struct AchievementView: View {
    var completedCount: Int
    var body: some View {
        VStack {
            Text("Выполнено задач: \(completedCount)")
                .font(.headline)
            if completedCount >= 5 {
                // Показываем анимированный эмодзи «салют»
                FireworkAnimationView()
                    .transition(.scale)
            }
        }
        .padding()
    }
}

struct AddTaskView: View {
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var notes: String = ""
    @State private var repeatInterval: RepeatInterval = .none
    
    var addTaskAction: (String, Date, Date, String?, RepeatInterval) -> Void
    
    private var isValid: Bool {
        !title.isEmpty && startTime < endTime
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Новая задача")) {
                    TextField("Название задачи", text: $title)
                    DatePicker("Начало", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $endTime, displayedComponents: .hourAndMinute)
                    if startTime >= endTime {
                        Text("Время начала должно быть меньше времени окончания")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    TextField("Заметки (опционально)", text: $notes)
                }
                Section(header: Text("Повторяемость")) {
                    Picker("Повтор", selection: $repeatInterval) {
                        ForEach(RepeatInterval.allCases) { interval in
                            Text(interval.rawValue).tag(interval)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
                        addTaskAction(title,
                                      startTime,
                                      endTime,
                                      notes.isEmpty ? nil : notes,
                                      repeatInterval)
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

struct EditTaskView: View {
    @Binding var scheduleItem: UserScheduleItem
    @Environment(\.presentationMode) var presentationMode
    
    private var isValid: Bool {
        !scheduleItem.title.isEmpty && scheduleItem.startTime < scheduleItem.endTime
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Редактировать задачу")) {
                    TextField("Название задачи", text: $scheduleItem.title)
                    DatePicker("Начало", selection: $scheduleItem.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Конец", selection: $scheduleItem.endTime, displayedComponents: .hourAndMinute)
                    if scheduleItem.startTime >= scheduleItem.endTime {
                        Text("Время начала должно быть меньше времени окончания")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    TextField("Заметки (опционально)", text: Binding(
                        get: { scheduleItem.notes ?? "" },
                        set: { scheduleItem.notes = $0.isEmpty ? nil : $0 }
                    ))
                }
                Section(header: Text("Настройки задачи")) {
                    Picker("Повтор", selection: $scheduleItem.repeatInterval) {
                        ForEach(RepeatInterval.allCases) { interval in
                            Text(interval.rawValue).tag(interval)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
                    .disabled(!isValid)
                }
            }
        }
    }
}*/
