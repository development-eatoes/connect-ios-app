import Foundation

public struct MenuItem: Identifiable, Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Double
    public let imageUrl: String?
    public let category: String
    public let isAvailable: Bool
    
    public init(
        id: String,
        name: String,
        description: String,
        price: Double,
        imageUrl: String? = nil,
        category: String,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageUrl = imageUrl
        self.category = category
        self.isAvailable = isAvailable
    }
    
    public var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
}

// Category model for grouping menu items
public struct MenuCategory: Identifiable {
    public let id: String
    public let name: String
    public let items: [MenuItem]
    
    public init(id: String, name: String, items: [MenuItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}
