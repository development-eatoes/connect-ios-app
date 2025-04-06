import Foundation

// MARK: - Menu Category
struct MenuCategory: Identifiable, Codable {
    let id: String
    let name: String
    let image: String
    let itemCount: Int
}

// MARK: - Menu Item
struct MenuItem: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    let price: Double
    let categoryId: String
    var isFavorite: Bool = false
}

// MARK: - Menu Item Detail
struct MenuItemDetail: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    let price: Double
    let categoryId: String
    let ingredients: [String]
    let nutritionalInfo: NutritionalInfo?
    let allergens: [String]
    let preparationTime: Int // in minutes
    let isFavorite: Bool
}

// MARK: - Nutritional Info
struct NutritionalInfo: Codable {
    let calories: Int
    let protein: Double // grams
    let carbs: Double // grams
    let fat: Double // grams
    let sugar: Double // grams
    let sodium: Double // milligrams
}