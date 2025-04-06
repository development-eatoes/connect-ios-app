import Foundation

public struct MenuCategory: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let imageURL: String?
    
    public init(id: String, name: String, description: String? = nil, imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}

public struct MenuResponse: Codable {
    public let success: Bool
    public let categories: [MenuCategory]?
    public let items: [MenuItemResponse]?
    
    public init(success: Bool, categories: [MenuCategory]? = nil, items: [MenuItemResponse]? = nil) {
        self.success = success
        self.categories = categories
        self.items = items
    }
}

public struct MenuItemResponse: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let description: String
    public let price: Double
    public let imageURL: String
    public let isVegetarian: Bool
    public let categoryId: String
    public let nutritionInfo: NutritionInfo?
    
    public init(
        id: String, 
        name: String, 
        description: String, 
        price: Double, 
        imageURL: String, 
        isVegetarian: Bool, 
        categoryId: String,
        nutritionInfo: NutritionInfo? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
        self.isVegetarian = isVegetarian
        self.categoryId = categoryId
        self.nutritionInfo = nutritionInfo
    }
}

public struct NutritionInfo: Codable, Equatable {
    public let calories: Int
    public let protein: String
    public let carbs: String
    public let fat: String
    
    public init(calories: Int, protein: String, carbs: String, fat: String) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}