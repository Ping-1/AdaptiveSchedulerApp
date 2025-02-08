//
//  FeedbackView.swift
//  AdaptiveSchedulerApp
//
//  Created by Yedil on 01.02.2025.
//

import SwiftUI

struct FeedbackView: View {
    @State private var feedbackText = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Оставьте свои комментарии и пожелания")
                    .font(.headline)
                TextEditor(text: $feedbackText)
                    .border(Color.gray, width: 1)
                    .padding(.horizontal)
                    .frame(height: 200)
                Button("Отправить обратную связь") {
                    // Здесь можно сохранить обратную связь или отправить её на сервер
                    print("Обратная связь: \(feedbackText)")
                    feedbackText = ""
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            .navigationTitle("Обратная связь")
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
