//
//  WeddingSettingsView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

struct WeddingSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var viewModel: WeddingInfoViewModel

    // локальные стейты (редактируем копию)
    @State private var groomName: String = ""
    @State private var brideName: String = ""
    @State private var weddingDate: Date = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // MARK: - Основная информация
                    VStack(spacing: 16) {
                        Text("ОСНОВНАЯ ИНФОРМАЦИЯ")
                            .font(.manropeBold(size: 13))
                            .foregroundColor(Color(hex: "835F8C"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)

                        TextField("Имя жениха", text: $groomName)
                            .textFieldStyle(CustomTextFieldStyle(cornerRadius: 25))

                        TextField("Имя невесты", text: $brideName)
                            .textFieldStyle(CustomTextFieldStyle(cornerRadius: 25))

                        HStack {
                            Label("Дата свадьбы", systemImage: "calendar")
                                .foregroundColor(Color(hex: "6C5CE7"))
                            Spacer()
                            DatePicker("", selection: $weddingDate, displayedComponents: .date)
                                .labelsHidden()
                        }
                        .padding(.horizontal)
                        .frame(height: 60)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .appBackground()
            .navigationTitle("Настройки свадьбы")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Сохранить") {
                    saveSettings()
                    dismiss()
                }
            )
            .onAppear {
                viewModel.loadInfo(using: context)

                if let info = viewModel.info {
                    groomName = info.groomName
                    brideName = info.brideName
                    weddingDate = info.weddingDate ?? Date()
                }
            }
        }
    }

    private func saveSettings() {
        viewModel.update(
            using: context,
            groom: groomName,
            bride: brideName,
            date: weddingDate
        )
    }
}

// MARK: - Кастомный стиль текстфилдов
struct CustomTextFieldStyle: TextFieldStyle {
    var cornerRadius: CGFloat = 35
    var minHeight: CGFloat = 56

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .frame(minHeight: minHeight)
            .background(Color.white)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WeddingInfo.self, configurations: config)
    let context = container.mainContext

    let testWedding = WeddingInfo(groomName: "Иван", brideName: "Алина")
    context.insert(testWedding)

    return WeddingSettingsView()
        .modelContext(context) // пробрасываем контекст в Environment
}
