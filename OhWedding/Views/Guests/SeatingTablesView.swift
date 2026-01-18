//
//  SeatingTablesView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 27.12.2025.
//

import SwiftUI

struct SeatingTablesView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: GuestViewModel

    @State private var showingAddTable = false
    @State private var showingSeatingDragView = false
    @State private var selectedTable: SeatingTable?

    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    StatCard(
                        icon: "square.grid.2x2",
                        iconColor: Color(red: 0.52, green: 0.47, blue: 0.73),
                        title: "Всего столов",
                        value: viewModel.totalTables
                    )

                    StatCard(
                        icon: "person.2",
                        iconColor: .orange,
                        title: "Без места",
                        value: viewModel.unassignedGuestsCountWithPlusOne
                    )
                }
                .padding(.vertical, 4)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }

            Section(header: Text("Столы")) {
                ForEach(viewModel.tables) { table in
                    let occupied = table.guests.reduce(0) { $0 + ($1.plusOne ? 2 : 1) }

                    HStack {
                        VStack(alignment: .leading) {
                            Text(table.name)
                                .font(.headline)
                            Text("\(occupied) из \(table.capacity)")
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
                        .forEach { viewModel.deleteTable(using: modelContext, table: $0) }
                }
            }
        }
        .listStyle(.insetGrouped)
        .appBackground()
        .navigationTitle("Рассадка")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showingSeatingDragView = true
                } label: {
                    Image(systemName: "square.grid.3x2")
                }

                Button {
                    showingAddTable = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTable) {
            AddTableView(availableGuests: viewModel.unassignedGuests) { name, capacity, shape, selected in
                viewModel.addTable(
                    using: modelContext,
                    name: name,
                    capacity: capacity,
                    shape: shape,
                    guests: selected
                )
            }
        }
        .sheet(item: $selectedTable) { table in
            EditTableView(
                table: table,
                availableGuests: viewModel.availableGuests(for: table)
            ) { name, capacity, shape, newGuests in
                viewModel.updateTable(
                    using: modelContext,
                    table: table,
                    name: name,
                    capacity: capacity,
                    shape: shape,
                    newGuests: newGuests
                )
            }
        }
        .sheet(isPresented: $showingSeatingDragView) {
            SeatingDragView(
                guests: viewModel.guests,
                tables: $viewModel.tables,
                onUpdate: { }
            )
        }
        .onAppear {
            viewModel.loadTables(using: modelContext)
        }
    }
}

#Preview {
    NavigationStack {
        SeatingTablesView(viewModel: GuestViewModel())
    }
}
