import SwiftUI
import PhotosUI

struct WeddingSettingsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var groomName: String = ""
    @State private var brideName: String = ""
    @State private var weddingDate: Date = Date()
    @State private var selectedItem: PhotosPickerItem?
    @State private var weddingImage: Image?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Имя жениха", text: $groomName)
                    TextField("Имя невесты", text: $brideName)
                    DatePicker("Дата свадьбы", selection: $weddingDate, displayedComponents: .date)
                }
                
                Section(header: Text("Фото")) {
                    HStack {
                        Spacer()
                        VStack {
                            if let weddingImage {
                                weddingImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            } else if let savedImage = viewModel.weddingImage {
                                Image(uiImage: savedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            
                            PhotosPicker(selection: $selectedItem,
                                       matching: .images) {
                                Text("Выбрать фото")
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 8)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Настройки свадьбы")
            .navigationBarItems(
                leading: Button("Отмена") {
                    dismiss()
                },
                trailing: Button("Сохранить") {
                    saveSettings()
                    dismiss()
                }
            )
            .onAppear {
                loadCurrentSettings()
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        weddingImage = Image(uiImage: uiImage)
                        viewModel.updateWeddingImage(uiImage)
                    }
                }
            }
        }
    }
    
    private func loadCurrentSettings() {
        groomName = viewModel.groomName
        brideName = viewModel.brideName
        weddingDate = viewModel.weddingDate
        if let savedImage = viewModel.weddingImage {
            weddingImage = Image(uiImage: savedImage)
        }
    }
    
    private func saveSettings() {
        viewModel.updateGroomName(groomName)
        viewModel.updateBrideName(brideName)
        viewModel.updateWeddingDate(weddingDate)
    }
}

#Preview {
    WeddingSettingsView(viewModel: HomeViewModel())
} 
