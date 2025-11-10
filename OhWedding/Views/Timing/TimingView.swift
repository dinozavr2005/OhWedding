//
//  TimingView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI


struct TimingView: View {
    @StateObject private var viewModel = TimingViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.blocks) { block in
                    VStack(spacing: 12) {
                        TimingBlockView(block: block, viewModel: viewModel)

                        if viewModel.isEditing {
                            Button {
                                withAnimation {
                                    viewModel.addBlock()
                                }
                            } label: {
                                Label("Добавить блок", systemImage: "plus.circle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.top, 4)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("Тайминг дня")
        .toolbar {
            Button(viewModel.isEditing ? "Готово" : "Редактировать") {
                withAnimation(.easeInOut) {
                    viewModel.isEditing.toggle()
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    NavigationView {
        TimingView()
    }
}
