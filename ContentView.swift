import SwiftUI

struct ContentView: View {
    @State private var isDarkMode: Bool = false
    @State private var timeFormat: TimeFormat = .twelveHour
    @State private var selectedTimeZone: TimeZone = TimeZone.current
    
    var body: some View {
        TabView {
            FeedbackView()
                .tabItem {
                    Label("Обратная связь", systemImage: "text.bubble")
                }
            
            UserInputView()
                .tabItem {
                    Label("choril", systemImage: "calendar")
                }
            
            SettingsView(
                isDarkMode: $isDarkMode,
                selectedTimeZone: $selectedTimeZone
            )
            .tabItem {
                Label("Настройки", systemImage: "gear")
            }
        }
        .onAppear {
            applyTheme()
        }
        .onChange(of: isDarkMode) { _ in
            applyTheme()
        }
    }
    
    private func applyTheme() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        scene.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}

