//
//  GuestListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct GuestListView: View {
    @StateObject private var viewModel = GuestViewModel()
    @State private var showingAddGuest = false
    @State private var selectedGuest: Guest?
    @State private var showingImportView = false

    var body: some View {
        List {
            // Guest summary
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Всего гостей")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.totalGuests)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Подтвердили")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(viewModel.confirmedGuests)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 8)
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
        .searchable(text: $viewModel.searchText, prompt: "Поиск гостей")
        .navigationTitle("Гости")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showingAddGuest = true }) {
                    Image(systemName: "person.badge.plus")
                }

                Button(action: { showingImportView = true }) {
                    Image(systemName: "list.bullet.rectangle")
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
        .sheet(isPresented: $showingImportView) {
            ImportGuestListView { importedGuests in
                importedGuests.forEach { viewModel.addGuest($0) }
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
                    Image(systemName: "phone")
                        .foregroundColor(.blue)
                    Text(guest.phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            StatusBadge(status: guest.status)
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: GuestStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
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
                Section(header: Text("Основная информация")) {
                    TextField("Имя", text: $name)
                    TextField("Телефон", text: $phone)
                    TextField("Email", text: $email)
                }

                Section(header: Text("Дополнительно")) {
                    Toggle("+1", isOn: $plusOne)
                    TextField("Ограничения в питании", text: $dietaryRestrictions)
                }
            }
            .navigationTitle("Новый гость")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Добавить") {
                    let guest = Guest(
                        name: name,
                        email: email,
                        group: "",               // Если не используется, оставляем пустым
                        phone: phone,
                        status: .invited,
                        plusOne: plusOne,
                        dietaryRestrictions: dietaryRestrictions,
                        notes: ""                // Если нет заметок, оставляем пустым
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
                Section(header: Text("Статус")) {
                    Picker("Статус", selection: $editedGuest.status) {
                        ForEach(GuestStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section(header: Text("Контактная информация")) {
                    TextField("Имя", text: $editedGuest.name)
                    TextField("Телефон", text: $editedGuest.phone)
                    TextField("Email", text: $editedGuest.email)
                }
                
                Section(header: Text("Дополнительно")) {
                    Toggle("+1", isOn: $editedGuest.plusOne)
                    TextField("Ограничения в питании", text: $editedGuest.dietaryRestrictions)
                }
            }
            .navigationTitle("Информация о госте")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Сохранить") {
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
