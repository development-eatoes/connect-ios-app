import Foundation
import Combine

// MARK: - Menu Category
struct MenuCategory: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let image: String
    let itemCount: Int
    
    static func == (lhs: MenuCategory, rhs: MenuCategory) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Menu Item
struct MenuItem: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let description: String
    let image: String
    let price: Double
    let categoryId: String
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
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
    let preparationTime: Int
    let isFavorite: Bool
}

// MARK: - Nutritional Info
struct NutritionalInfo: Codable {
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let sugar: Double
    let sodium: Double
}

// MARK: - Menu Repository Protocol
protocol MenuRepository {
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error>
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error>
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error>
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error>
}

// MARK: - Menu Errors
enum MenuError: Error, LocalizedError {
    case invalidCategory
    case invalidMenuItem
    case networkError
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCategory:
            return "Unable to find the requested category"
        case .invalidMenuItem:
            return "Unable to find the requested menu item"
        case .networkError:
            return "Network error. Please check your internet connection"
        case .serverError(let message):
            return message
        case .unknown:
            return "An unexpected error occurred"
        }
    }
}