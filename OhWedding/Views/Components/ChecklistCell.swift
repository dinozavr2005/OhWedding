//
//  ChecklistCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct ChecklistCell: View {
    let title: String
    let completedCount: Int
    let totalCount: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
            
            HStack {
                Text("\(completedCount)/\(totalCount)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 3)
        )
    }
}

#Preview {
    ChecklistCell(
        title: "Рекомендации",
        completedCount: 5,
        totalCount: 10,
        color: .blue
    )
    .padding()
    .background(Color.gray.opacity(0.1))
} 
