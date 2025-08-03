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

    let onImport: ([Guest]) -> Void

    var body: some View {
        NavigationView {
            VStack {
                Button {
                    showingSourceActionSheet = true
                } label: {
                    Image(systemName: "camera")
                        .font(.system(size: 22))
                        .padding(8)
                        .background(Color(UIColor.tertiarySystemFill))
                        .clipShape(Circle())
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

                TextEditor(text: $rawText)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()

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
                        print("❌ Ошибка при сохранении импортированных гостей: \(error)")
                    }
                }
                .disabled(rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
        }
    }

    private func parseGuests(from text: String) -> [Guest] {
        let lines = text.components(separatedBy: .newlines)
        var guests: [Guest] = []

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }

            let lower = trimmed.lowercased()
            let attending = !(lower.contains("не придет") || lower.contains("не будет") || lower.contains("отказ"))

            let regex = try! NSRegularExpression(pattern: "\\+\\d+", options: [])
            let match = regex.firstMatch(in: trimmed, options: [], range: NSRange(location: 0, length: trimmed.utf16.count))

            var plusOne = false
            if let match = match,
               let range = Range(match.range, in: trimmed),
               let number = Int(trimmed[range].replacingOccurrences(of: "+", with: "")),
               number > 0 {
                plusOne = true
            }

            let name = trimmed.components(separatedBy: CharacterSet(charactersIn: "+(")).first?.trimmingCharacters(in: .whitespaces) ?? trimmed

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
