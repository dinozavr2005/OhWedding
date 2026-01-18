//
//  GuestListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct GuestListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = GuestViewModel()

    @State private var showingAddGuest = false
    @State private var showingImportView = false

    @State private var selectedGuest: Guest?
    @State private var navigateToSeating = false

    var body: some View {
        VStack(spacing: 0) {
            guestListSection
        }
        .navigationTitle("Гости")
        .appBackground()
        .onAppear {
            viewModel.loadGuests(using: modelContext)
            viewModel.loadTables(using: modelContext)
        }
        .background(
            NavigationLink(isActive: $navigateToSeating) {
                SeatingTablesView(viewModel: viewModel)
            } label: { EmptyView() }
                .hidden()
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddGuest = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
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
    }

    private var guestListSection: some View {
        VStack(spacing: 0) {
            // Top actions
            HStack(spacing: 12) {
                Button {
                    navigateToSeating = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "square.grid.3x2")
                        Text("Рассадка")
                            .font(.manropeBold(size: 17))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(PrimaryActionButtonStyle())

                Button {
                    showingImportView = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Импорт")
                            .font(.manropeBold(size: 17))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                }
                .buttonStyle(SecondaryActionButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 12)

            // Search
            SearchBar(placeholder: "Поиск гостей", text: $viewModel.searchText)
                .padding(.horizontal)
                .padding(.bottom, 8)

            List {
                StatCardsRow(
                    total: viewModel.totalGuestsWithPlusOne,
                    confirmed: viewModel.confirmedGuestsWithPlusOne
                )
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                ForEach(viewModel.filteredGuests) { guest in
                    GuestRow(
                        guest: guest,
                        onStatusTap: {
                            viewModel.updateGuest(using: modelContext, guest: guest) {
                                $0.status = $0.status.next()
                            }
                        }
                    )
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
            .contentMargins(.top, 0, for: .scrollContent)
            .listStyle(.automatic)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        GuestListView()
            .environmentObject(AppModel.shared)
    }
}
