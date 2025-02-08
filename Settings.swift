//
//  Settings.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 02.02.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    @Binding var selectedTimeZone: TimeZone
    @AppStorage("timeFormat") private var timeFormat: TimeFormat = .twentyFourHour

    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Настройки темы")) {
                    Toggle(isOn: $isDarkMode) {
                        Text("Темная тема")
                    }
                }
                
                Section(header: Text("Формат времени")) {
                    Picker("Выберите формат", selection: $timeFormat) {
                        Text("12-часовой").tag(TimeFormat.twelveHour)
                        Text("24-часовой").tag(TimeFormat.twentyFourHour)
                        }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Часовой пояс")) {
                    Picker("Часовой пояс", selection: $selectedTimeZone) {
                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { identifier in
                            Text(identifier)
                        }
                    }
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

enum TimeFormat: String, Identifiable, CaseIterable {
    case twelveHour = "12-hour"
    case twentyFourHour = "24-hour"
    
    var id: String { self.rawValue }
}

