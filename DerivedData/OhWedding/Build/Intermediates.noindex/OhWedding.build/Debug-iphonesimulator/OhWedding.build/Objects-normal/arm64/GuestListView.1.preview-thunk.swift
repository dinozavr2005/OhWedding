import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/GuestListView.swift", line: 1)
import SwiftUI

struct GuestListView: View {
    @StateObject private var viewModel = GuestViewModel()
    @State private var showingAddGuest = false
    @State private var selectedGuest: Guest?
    
    var body: some View {
        List {
            // Guest summary
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text(__designTimeString("#9876_0", fallback: "Всего гостей"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.totalGuests)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(__designTimeString("#9876_1", fallback: "Подтвердили"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.confirmedGuests)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, __designTimeInteger("#9876_2", fallback: 8))
            }
            
            // Guests list
            Section {
                ForEach(viewModel.filteredGuests) { guest in
                    GuestRow(guest: guest)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedGuest = guest
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let guest = viewModel.filteredGuests[index]
                        viewModel.deleteGuest(guest)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: __designTimeString("#9876_3", fallback: "Поиск гостей"))
        .navigationTitle(__designTimeString("#9876_4", fallback: "Гости"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGuest = __designTimeBoolean("#9876_5", fallback: true) }) {
                    Image(systemName: __designTimeString("#9876_6", fallback: "person.badge.plus"))
                }
            }
        }
        .sheet(isPresented: $showingAddGuest) {
            AddGuestView { guest in
                viewModel.addGuest(guest)
            }
        }
        .sheet(item: $selectedGuest) { guest in
            GuestDetailView(guest: guest) { updatedGuest in
                viewModel.updateGuest(updatedGuest)
            }
        }
    }
}

struct GuestRow: View {
    let guest: Guest
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(guest.name)
                    .font(.headline)
                
                HStack {
                    Image(systemName: __designTimeString("#9876_7", fallback: "phone"))
                        .foregroundColor(.blue)
                    Text(guest.phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            StatusBadge(status: guest.status)
        }
        .padding(.vertical, __designTimeInteger("#9876_8", fallback: 4))
    }
}

struct StatusBadge: View {
    let status: GuestStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, __designTimeInteger("#9876_9", fallback: 8))
            .padding(.vertical, __designTimeInteger("#9876_10", fallback: 4))
            .background(status.color.opacity(__designTimeFloat("#9876_11", fallback: 0.2)))
            .foregroundColor(status.color)
            .cornerRadius(__designTimeInteger("#9876_12", fallback: 8))
    }
}

struct AddGuestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var plusOne = false
    @State private var dietaryRestrictions = ""

    // onAdd возвращает созданного гостя
    let onAdd: (Guest) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(__designTimeString("#9876_13", fallback: "Основная информация"))) {
                    TextField(__designTimeString("#9876_14", fallback: "Имя"), text: $name)
                    TextField(__designTimeString("#9876_15", fallback: "Телефон"), text: $phone)
                    TextField(__designTimeString("#9876_16", fallback: "Email"), text: $email)
                }

                Section(header: Text(__designTimeString("#9876_17", fallback: "Дополнительно"))) {
                    Toggle(__designTimeString("#9876_18", fallback: "+1"), isOn: $plusOne)
                    TextField(__designTimeString("#9876_19", fallback: "Ограничения в питании"), text: $dietaryRestrictions)
                }
            }
            .navigationTitle(__designTimeString("#9876_20", fallback: "Новый гость"))
            .navigationBarItems(
                leading: Button(__designTimeString("#9876_21", fallback: "Отмена")) { dismiss() },
                trailing: Button(__designTimeString("#9876_22", fallback: "Добавить")) {
                    let guest = Guest(
                        name: name,
                        email: email,
                        group: __designTimeString("#9876_23", fallback: ""),               // Если не используется, оставляем пустым
                        phone: phone,
                        status: .invited,
                        plusOne: plusOne,
                        dietaryRestrictions: dietaryRestrictions,
                        notes: __designTimeString("#9876_24", fallback: "")                // Если нет заметок, оставляем пустым
                    )
                    onAdd(guest)
                    dismiss()
                }
                .disabled(name.isEmpty || phone.isEmpty)
            )
        }
    }
}

struct GuestDetailView: View {
    let guest: Guest
    let onUpdate: (Guest) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var editedGuest: Guest
    
    init(guest: Guest, onUpdate: @escaping (Guest) -> Void) {
        self.guest = guest
        self.onUpdate = onUpdate
        _editedGuest = State(initialValue: guest)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(__designTimeString("#9876_25", fallback: "Статус"))) {
                    Picker(__designTimeString("#9876_26", fallback: "Статус"), selection: $editedGuest.status) {
                        ForEach(GuestStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section(header: Text(__designTimeString("#9876_27", fallback: "Контактная информация"))) {
                    TextField(__designTimeString("#9876_28", fallback: "Имя"), text: $editedGuest.name)
                    TextField(__designTimeString("#9876_29", fallback: "Телефон"), text: $editedGuest.phone)
                    TextField(__designTimeString("#9876_30", fallback: "Email"), text: $editedGuest.email)
                }
                
                Section(header: Text(__designTimeString("#9876_31", fallback: "Дополнительно"))) {
                    Toggle(__designTimeString("#9876_32", fallback: "+1"), isOn: $editedGuest.plusOne)
                    TextField(__designTimeString("#9876_33", fallback: "Ограничения в питании"), text: $editedGuest.dietaryRestrictions)
                }
            }
            .navigationTitle(__designTimeString("#9876_34", fallback: "Информация о госте"))
            .navigationBarItems(
                leading: Button(__designTimeString("#9876_35", fallback: "Отмена")) { dismiss() },
                trailing: Button(__designTimeString("#9876_36", fallback: "Сохранить")) {
                    onUpdate(editedGuest)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    NavigationView {
        GuestListView()
    }
} 
