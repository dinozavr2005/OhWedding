//
//  ImportGuestListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 28.07.2025.
//

import SwiftUI
import Vision
import SwiftData

struct ImportGuestListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var rawText: String = ""
    @State private var showingImagePicker = false
    @State private var imagePickerSource: ImagePicker.Source = .camera
    @State private var showingSourceActionSheet = false

    @State private var showingContactsFlow = false

    let onImport: ([Guest]) -> Void

    private var contactsImporter: ContactsGuestsImporter {
        ContactsGuestsImporter(modelContext: modelContext)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {

                VStack(alignment: .leading, spacing: 6) {
                    Text("Добавьте гостей любым способом:")
                        .font(.footnote.weight(.semibold))
                    Text("• Впишите список в поле ниже")
                    Text("• Или импортируйте по фото / из контактов")
                        .padding(.top, 4)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color.appBackground)
                .cornerRadius(12)
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button {
                        showingSourceActionSheet = true
                    } label: {
                        circleIconButton(systemName: "camera")
                    }
                    .actionSheet(isPresented: $showingSourceActionSheet) {
                        ActionSheet(
                            title: Text("Источник изображения"),
                            buttons: [
                                .default(Text("Камера")) {
                                    imagePickerSource = .camera
                                    showingImagePicker = true
                                },
                                .default(Text("Галерея")) {
                                    imagePickerSource = .photoLibrary
                                    showingImagePicker = true
                                },
                                .cancel()
                            ]
                        )
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(source: imagePickerSource) { image in
                            recognizeText(from: image)
                        }
                    }

                    Button {
                        showingContactsFlow = true
                    } label: {
                        circleIconButton(systemName: "person.crop.circle")
                    }
                    .sheet(isPresented: $showingContactsFlow) {
                        ContactsPickView { picked in
                            do {
                                let guests = try contactsImporter.importGuests(from: picked)
                                onImport(guests)
                                dismiss()
                            } catch {
                                print("❌ Ошибка импорта гостей из контактов: \(error)")
                            }
                        }
                    }
                }
                .padding(.top, 4)

                TextEditor(text: $rawText)
                    .padding()
                    .background(Color.appBackground)
                    .cornerRadius(8)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Импорт списка")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Импорт") {
                    let guests = parseGuests(from: rawText)
                    for guest in guests {
                        modelContext.insert(guest)
                    }
                    do {
                        try modelContext.save()
                        onImport(guests)
                        dismiss()
                    } catch {
                        print("Ошибка при сохранении импортированных гостей: \(error)")
                    }
                }
                .disabled(rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }

    private func circleIconButton(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 22))
            .padding(8)
            .background(Color.appBackground)
            .clipShape(Circle())
    }

    private func parseGuests(from text: String) -> [Guest] {
        let lines = text.components(separatedBy: .newlines)
        var guests: [Guest] = []

        for line in lines {
            // 1) Разбиваем строку по запятым/точкам с запятой
            let parts = line
                .split { $0 == "," || $0 == ";" }
                .map { String($0) }

            for part in parts {
                let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { continue }

                let lower = trimmed.lowercased()
                let attending = !(lower.contains("не придет") || lower.contains("не будет") || lower.contains("отказ"))

                // +1 / +2 / +3 ...
                let regex = try! NSRegularExpression(pattern: "\\+\\d+", options: [])
                let match = regex.firstMatch(
                    in: trimmed,
                    options: [],
                    range: NSRange(location: 0, length: trimmed.utf16.count)
                )

                var plusOne = false
                if let match = match,
                   let range = Range(match.range, in: trimmed),
                   let number = Int(trimmed[range].replacingOccurrences(of: "+", with: "")),
                   number > 0 {
                    plusOne = true
                }

                // Имя — всё до "+" или "("
                let name = trimmed
                    .components(separatedBy: CharacterSet(charactersIn: "+("))
                    .first?
                    .trimmingCharacters(in: .whitespaces) ?? trimmed

                if name.count < 2 { continue }

                guests.append(
                    Guest(
                        name: name,
                        group: "",
                        phone: "",
                        status: attending ? .invited : .declined,
                        plusOne: plusOne,
                        dietaryRestrictions: "",
                        notes: ""
                    )
                )
            }
        }

        return guests
    }

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }

            // 💡 Отфильтруем сразу
            let filtered = recognizedStrings.filter { line in
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)

                // Убираем короткие строки, числа, служебные слова
                guard trimmed.count >= 2 else { return false }
                if trimmed.range(of: #"^\d{1,2}[:\.]\d{1,2}$"#, options: .regularExpression) != nil { return false } // Время
                if trimmed.range(of: #"^[\d\s\+\-\.]+$"#, options: .regularExpression) != nil { return false } // Числа
                let systemWords = ["назад", "готово", "ввод", "пробел", "bl", "ok"]
                if systemWords.contains(trimmed.lowercased()) { return false }

                return true
            }

            let cleanText = filtered.joined(separator: "\n")

            DispatchQueue.main.async {
                self.rawText = cleanText
            }
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ru-RU", "en-US"]
        request.usesLanguageCorrection = true

        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }

}

#Preview {
    ImportGuestListView(onImport: { _ in })
}
