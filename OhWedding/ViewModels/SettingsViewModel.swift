import Foundation
import UIKit

class SettingsViewModel: ObservableObject {
    @Published var weddingDate: Date
    @Published var weddingTitle: String
    @Published var weddingImage: UIImage?
    
    init(weddingDate: Date = Date(), weddingTitle: String = "OH Wedding") {
        self.weddingDate = weddingDate
        self.weddingTitle = weddingTitle
    }
    
    func updateWeddingDate(_ date: Date) {
        weddingDate = date
    }
    
    func updateWeddingTitle(_ title: String) {
        weddingTitle = title
    }
    
    func updateWeddingImage(_ image: UIImage?) {
        weddingImage = image
    }
} 
