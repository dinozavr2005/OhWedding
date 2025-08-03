//
//  GuestListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

enum GuestViewSegment: String, CaseIterable {
    case list = "Список"
    case seating = "Рассадка"
}

struct GuestListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = GuestViewModel()

    @State private var showingAddGuest = false
    @State private var showingImportView = false
    @State private var showingAddTable = false
    @State private var showingSeatingDragView = false

    @State private var selectedGuest: Guest?
    @State private var selectedTable: SeatingTable?
    @State private var selectedSegment: GuestViewSegment = .list

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedSegment) {
                ForEach(GuestViewSegment.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if selectedSegment == .list {
                guestListSection
            } else {
                seatingSection
            }
        }
        .navigationTitle("Гости")
        .onAppear {
            viewModel.loadGuests(using: modelContext)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if selectedSegment == .list {
                    Button {
                        showingAddGuest = true
                    } label: {
                        Image(systemName: "person.badge.plus")
                    }
                    Button {
                        showingImportView = true
                    } label: {
                        Image(systemName: "list.bullet.rectangle")
                    }
                } else {
                    Button {
                        showingAddTable = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    Button {
                        showingSeatingDragView = true
                    } label: {
                        Image(systemName: "square.grid.3x2")
                    }
                }
            }
        }
        // Sheets
        .sheet(isPresented: $showingAddGuest) {
            AddGuestView(viewModel: viewModel)
        }
        .sheet(item: $selectedGuest) { guest in
            GuestDetailView(guest: guest) { updatedGuest in
                viewModel.updateGuest(using: modelContext, guest: updatedGuest) { _ in }
            }
        }
        .sheet(isPresented: $showingImportView) {
            ImportGuestListView { guests in
                viewModel.addGuests(using: modelContext, guests: guests)
            }
        }
        .sheet(isPresented: $showingAddTable) {
            AddTableView(availableGuests: viewModel.unassignedGuests) {
                viewModel.addTable($0)
            }
        }
        .sheet(item: $selectedTable) { table in
            EditTableView(
                table: table,
                availableGuests: viewModel.availableGuests(for: table)
            ) {
                viewModel.updateTable($0)
            }
        }
        .sheet(isPresented: $showingSeatingDragView) {
            SeatingDragView(
                guests: viewModel.unassignedGuests,
                tables: $viewModel.tables,
                onUpdate: { }
            )
        }
    }

    private var guestListSection: some View {
        VStack(spacing: 0) {
            TextField("Поиск гостей", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .padding(.bottom, 8)

            List {
                Section {
                    HStack {
                        statItem(title: "Всего гостей", value: viewModel.totalGuests)
                        Spacer()
                        statItem(title: "Подтвердили", value: viewModel.confirmedGuests, color: .green)
                    }
                    .padding(.vertical, 8)
                }

                Section {
                    ForEach(viewModel.filteredGuests) { guest in
                        GuestRow(guest: guest)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedGuest = guest
                            }
                    }
                    .onDelete { offsets in
                        offsets
                            .map { viewModel.filteredGuests[$0] }
                            .forEach { viewModel.deleteGuest(using: modelContext, guest: $0) }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    private var seatingSection: some View {
        List {
            Section {
                HStack {
                    statItem(title: "Всего столов", value: viewModel.totalTables)
                    Spacer()
                    statItem(title: "Без места", value: viewModel.unassignedGuestsCount, color: .orange)
                }
                .padding(.vertical, 8)
            }

            Section(header: Text("Столы")) {
                ForEach(viewModel.tables) { table in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(table.name)
                                .font(.headline)
                            Text("\(table.guests.count) из \(table.capacity)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(table.shape.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTable = table
                    }
                }
                .onDelete { offsets in
                    offsets
                        .map { viewModel.tables[$0] }
                        .forEach(viewModel.deleteTable)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func statItem(title: String, value: Int, color: Color = .primary) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(value)")
                .font(.title2).bold()
                .foregroundColor(color)
        }
    }
}


#Preview {
    NavigationView {
        GuestListView()
            .environmentObject(AppModel.shared)
    }
}
