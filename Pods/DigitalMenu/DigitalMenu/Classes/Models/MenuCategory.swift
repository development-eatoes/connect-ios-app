import Foundation
import NetworkLayer

public struct MenuCategory: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let imageURL: String?
    
    public init(
        id: String,
        name: String,
        description: String? = nil,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
    
    public init(from response: MenuLayer.MenuCategory) {
        self.id = response.id
        self.name = response.name
        self.description = response.description
        self.imageURL = response.imageURL
    }
}

// Extension for creating a demo menu category for previews
public extension MenuCategory {
    static var samples: [MenuCategory] {
        [
            MenuCategory(
                id: "pizza",
                name: "Pizza",
                description: "Handcrafted pizzas with the freshest ingredients",
                imageURL: "https://images.unsplash.com/photo-1513104890138-7c749659a591"
            ),
            MenuCategory(
                id: "pasta",
                name: "Pasta",
                description: "Authentic Italian pasta dishes",
                imageURL: "https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb"
            ),
            MenuCategory(
                id: "desserts",
                name: "Desserts",
                description: "Sweet treats to end your meal",
                imageURL: "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e"
            )
        ]
    }
}