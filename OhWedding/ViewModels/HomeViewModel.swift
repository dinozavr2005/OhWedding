import Foundation
import UIKit

class HomeViewModel: ObservableObject {
    @Published var weddingDate: Date = Date()
    @Published var groomName: String = ""
    @Published var brideName: String = ""
    @Published var weddingImage: UIImage?
    
    var weddingTitle: String {
        if !groomName.isEmpty && !brideName.isEmpty {
            return "\(groomName) & \(brideName)"
        } else {
            return "Жених & Невеста"
        }
    }
    
    var daysUntilWedding: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: weddingDate)
        return components.day ?? 0
    }
    
    func updateWeddingDate(_ date: Date) {
        weddingDate = date
    }
    
    func updateGroomName(_ name: String) {
        groomName = name
    }
    
    func updateBrideName(_ name: String) {
        brideName = name
    }
} 
