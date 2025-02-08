//
//  User Input View.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 02.02.2025.
//

import SwiftUI

// MARK: - Вью с анимированными пузырьками

struct BubblesView: View {
    @State private var showBubbles = false

    var body: some View {
        ZStack {
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 90))
                .overlay(
                    Text("Nice")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                )
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? -25 : 0))
                .animation(Animation.easeInOut(duration: 3).delay(0.5), value: showBubbles)
            
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 100))
                .overlay(
                    Text("Flawless")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                )
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .animation(Animation.easeOut(duration: 3).delay(0.4), value: showBubbles)
            
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 72))
                .overlay(
                    Text("Super")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                )
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .animation(Animation.easeIn(duration: 3).delay(0.3), value: showBubbles)
            
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 64))
                .overlay(
                    Text("Wow")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                )
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? -25 : 0))
                .animation(Animation.easeInOut(duration: 3).delay(0.2), value: showBubbles)
            
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 72))
                .overlay(
                    Text("Yepee")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom)
                )
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? 25 : 0))
                .animation(Animation.easeOut(duration: 3).delay(0.1), value: showBubbles)
        }
        .foregroundStyle(
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.blue]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .onAppear {
            showBubbles = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showBubbles = false
                }
            }
        }
    }
}

// MARK: - Основной функционал расписания

enum RepeatInterval: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case none = "Нет"
    case daily = "Ежедневно"
    case weekly = "Еженедельно"
    case monthly = "Ежемесячно"
}

extension Int: Identifiable {
    public var id: Int { self }
}

struct UserScheduleItem: Identifiable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var notes: String?
    
    var isCompleted: Bool = false
    var repeatInterval: RepeatInterval = .none
}

struct UserInputView: View {
    // Настройки и данные расписания
    @State private var wakeUpTime = Date()
    @State private var sleepTime = Date()
    @State private var scheduleItems: [UserScheduleItem] = []
    
    // Флаги для добавления/редактирования задачи
    @State private var isAddingTask = false
    @State private var editingItemIndex: Int? = nil
    
    // Строка поиска
    @State private var searchText: String = ""
    
    // Счётчик выполненных задач
    @State private var completedCount: Int = 0
    
    // Форматтер времени
    static let timeFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.timeStyle = .short
       return formatter
    }()
    
    // Фильтрация задач по поисковой строке
    var filteredTasks: [UserScheduleItem] {
        if searchText.isEmpty {
            return scheduleItems
        } else {
            return scheduleItems.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Добавляем новое состояние для редактирования:
    @State private var editingTask: UserScheduleItem? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Основное окно со списком задач
                Form {
                    Section(header: Text("Настройки")) {
                        DatePicker("Время подъёма", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        DatePicker("Время отхода ко сну", selection: $sleepTime, displayedComponents: .hourAndMinute)
                    }
                    
                    Section(header: Text("Расписание")) {
                        if filteredTasks.isEmpty {
                            Text("Расписание пока пусто.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(filteredTasks.indices, id: \.self) { index in
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
                                        editingTask = task
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
                .searchable(text: $searchText)
                
                // Если выполнено 5 и более задач, отображаем анимированное окно
                if completedCount >= 5 {
                    BubblesView()
                        .frame(width: 200, height: 300)
                        .allowsHitTesting(false)
                        .transition(.scale)
                        .animation(.easeInOut, value: completedCount)
                }
            }
            .navigationTitle("Расписание")
            // Добавляем счётчик задач и кнопку добавления в навигационную панель
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Выполнено: \(completedCount)")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingTask) {
                AddTaskView(isPresented: $isAddingTask) { title, start, end, notes, repeatInterval in
                    addTask(title, start, end, notes: notes, repeatInterval: repeatInterval)
                }
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(scheduleItem: bindingForTask(task))
            }
        }
    }
    
    // MARK: - Функции обработки задач
    
    func addTask(_ title: String, _ start: Date, _ end: Date, notes: String?, repeatInterval: RepeatInterval) {
        let newTask = UserScheduleItem(title: title,
                                       startTime: start,
                                       endTime: end,
                                       notes: notes,
                                       repeatInterval: repeatInterval)
        withAnimation {
            scheduleItems.append(newTask)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        withAnimation {
            scheduleItems.remove(atOffsets: offsets)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        withAnimation {
            scheduleItems.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    // Переключение состояния выполнения задачи
    func toggleTaskCompletion(at index: Int) {
        scheduleItems[index].isCompleted.toggle()
        if scheduleItems[index].isCompleted {
            completedCount += 1
            // Если задача повторяется, создаём следующее её вхождение
            if scheduleItems[index].repeatInterval != .none {
                let nextTask = nextOccurrence(for: scheduleItems[index])
                withAnimation {
                    scheduleItems.append(nextTask)
                }
            }
        } else {
            completedCount = max(0, completedCount - 1)
        }
    }
    
    // Рассчитываем следующее повторение задачи
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
    
    // Добавляем вспомогательную функцию для получения привязки к задаче
    func bindingForTask(_ task: UserScheduleItem) -> Binding<UserScheduleItem> {
        guard let index = scheduleItems.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Задача не найдена")
        }
        return $scheduleItems[index]
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
}

struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView()
    }
}
