import Foundation
import SwiftUI

struct MenuItem: Identifiable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    var isVegetarian: Bool
    var category: String
}

extension MenuItem: Equatable {}

// Make MenuItem work with the fullScreenCover presentation
extension MenuItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}