import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/Components/ChecklistCell.swift", line: 1)
import SwiftUI

struct ChecklistCell: View {
    let title: String
    let completedCount: Int
    let totalCount: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: __designTimeInteger("#13246_0", fallback: 16)) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(__designTimeInteger("#13246_1", fallback: 2))
            
            Spacer()
            
            HStack {
                Text("\(completedCount)/\(totalCount)")
                    .font(.system(size: __designTimeInteger("#13246_2", fallback: 28), weight: .bold))
                    .foregroundColor(color)
                
                Spacer()
                
                Image(systemName: __designTimeString("#13246_3", fallback: "chevron.right"))
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(__designTimeInteger("#13246_4", fallback: 20))
        .frame(height: __designTimeInteger("#13246_5", fallback: 160))
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: __designTimeInteger("#13246_6", fallback: 15))
                .fill(Color.white)
                .shadow(radius: __designTimeInteger("#13246_7", fallback: 3))
        )
    }
}

#Preview {
    ChecklistCell(
        title: __designTimeString("#13246_8", fallback: "Рекомендации"),
        completedCount: __designTimeInteger("#13246_9", fallback: 5),
        totalCount: __designTimeInteger("#13246_10", fallback: 10),
        color: .blue
    )
    .padding()
    .background(Color.gray.opacity(__designTimeFloat("#13246_11", fallback: 0.1)))
} 
