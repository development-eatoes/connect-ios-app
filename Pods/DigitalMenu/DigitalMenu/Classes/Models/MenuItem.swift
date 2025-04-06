import Foundation
import NetworkLayer

public struct MenuItem: Identifiable, Equatable {
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
    
    public init(from response: MenuItemResponse) {
        self.id = response.id
        self.name = response.name
        self.description = response.description
        self.price = response.price
        self.imageURL = response.imageURL
        self.isVegetarian = response.isVegetarian
        self.categoryId = response.categoryId
        self.nutritionInfo = response.nutritionInfo
    }
}

// Extension for creating a demo menu item for previews
public extension MenuItem {
    static var sample: MenuItem {
        MenuItem(
            id: "1",
            name: "Margherita Pizza",
            description: "Classic Italian pizza with fresh tomato sauce, mozzarella, and basil leaves",
            price: 12.99,
            imageURL: "https://images.unsplash.com/photo-1513104890138-7c749659a591",
            isVegetarian: true,
            categoryId: "pizza",
            nutritionInfo: NutritionInfo(
                calories: 820,
                protein: "24g",
                carbs: "87g",
                fat: "32g"
            )
        )
    }
}