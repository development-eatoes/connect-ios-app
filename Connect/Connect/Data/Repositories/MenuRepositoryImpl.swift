import Foundation
import Combine

// MARK: - Menu Repository Implementation
class MenuRepositoryImpl: MenuRepository {
    private let networkService: NetworkServiceProtocol
    private let baseURL: URL
    private var authToken: String?
    
    init(networkService: NetworkServiceProtocol, baseURL: URL, authToken: String? = nil) {
        self.networkService = networkService
        self.baseURL = baseURL
        self.authToken = authToken
    }
    
    // Update auth token
    func updateAuthToken(_ token: String) {
        self.authToken = token
    }
    
    // Fetch menu categories
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error> {
        let endpoint = Endpoint(
            path: "/menu/categories",
            authToken: authToken
        )
        
        return networkService.request(endpoint: endpoint)
    }
    
    // Fetch menu items for a category
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        let endpoint = Endpoint(
            path: "/menu/items",
            queryParameters: ["categoryId": categoryId],
            authToken: authToken
        )
        
        return networkService.request(endpoint: endpoint)
    }
    
    // Fetch detailed info for a menu item
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        let endpoint = Endpoint(
            path: "/menu/items/\(itemId)",
            authToken: authToken
        )
        
        return networkService.request(endpoint: endpoint)
    }
    
    // Toggle favorite status for a menu item
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error> {
        let endpoint = Endpoint(
            path: "/menu/favorites/\(itemId)",
            method: .post,
            body: ["isFavorite": isFavorite],
            authToken: authToken
        )
        
        return networkService.request(endpoint: endpoint)
    }
}

// MARK: - Mock Menu Repository for Development/Testing
#if DEBUG
class MockMenuRepositoryWithData: MenuRepository {
    private let categories: [MenuCategory]
    private let menuItems: [String: [MenuItem]] // Keyed by category ID
    private let menuItemDetails: [String: MenuItemDetail] // Keyed by item ID
    private let delay: TimeInterval
    
    init(delay: TimeInterval = 1.0) {
        self.delay = delay
        
        // Sample categories
        self.categories = [
            MenuCategory(id: "1", name: "Appetizers", image: "appetizer-image", itemCount: 4),
            MenuCategory(id: "2", name: "Main Course", image: "main-course-image", itemCount: 6),
            MenuCategory(id: "3", name: "Desserts", image: "dessert-image", itemCount: 3),
            MenuCategory(id: "4", name: "Beverages", image: "beverage-image", itemCount: 5)
        ]
        
        // Sample menu items grouped by category
        self.menuItems = [
            "1": [
                MenuItem(id: "101", name: "Caesar Salad", description: "Fresh romaine lettuce with creamy dressing", image: "caesar-salad", price: 8.99, categoryId: "1"),
                MenuItem(id: "102", name: "Fried Calamari", description: "Crispy squid rings with dipping sauce", image: "calamari", price: 10.99, categoryId: "1"),
                MenuItem(id: "103", name: "Bruschetta", description: "Toasted bread with tomatoes and basil", image: "bruschetta", price: 7.50, categoryId: "1"),
                MenuItem(id: "104", name: "Spinach Dip", description: "Creamy spinach dip with tortilla chips", image: "spinach-dip", price: 9.50, categoryId: "1")
            ],
            "2": [
                MenuItem(id: "201", name: "Spaghetti Carbonara", description: "Classic pasta with eggs, cheese, and bacon", image: "carbonara", price: 14.99, categoryId: "2"),
                MenuItem(id: "202", name: "Grilled Salmon", description: "Fresh salmon with lemon butter sauce", image: "salmon", price: 18.50, categoryId: "2"),
                MenuItem(id: "203", name: "Chicken Parmesan", description: "Breaded chicken with marinara and mozzarella", image: "chicken-parm", price: 15.99, categoryId: "2"),
                MenuItem(id: "204", name: "Beef Tenderloin", description: "Grilled beef with mushroom sauce", image: "beef", price: 24.99, categoryId: "2"),
                MenuItem(id: "205", name: "Vegetable Stir Fry", description: "Mixed vegetables in savory sauce", image: "stir-fry", price: 13.50, categoryId: "2"),
                MenuItem(id: "206", name: "Margherita Pizza", description: "Classic pizza with tomato sauce and mozzarella", image: "pizza", price: 12.99, categoryId: "2")
            ],
            "3": [
                MenuItem(id: "301", name: "Tiramisu", description: "Italian coffee-flavored dessert", image: "tiramisu", price: 7.99, categoryId: "3"),
                MenuItem(id: "302", name: "Chocolate Lava Cake", description: "Warm cake with molten chocolate center", image: "lava-cake", price: 8.50, categoryId: "3"),
                MenuItem(id: "303", name: "Cheesecake", description: "New York style with berry compote", image: "cheesecake", price: 7.50, categoryId: "3")
            ],
            "4": [
                MenuItem(id: "401", name: "Fresh Orange Juice", description: "Freshly squeezed orange juice", image: "orange-juice", price: 4.50, categoryId: "4"),
                MenuItem(id: "402", name: "Iced Tea", description: "House-brewed black tea with lemon", image: "iced-tea", price: 3.50, categoryId: "4"),
                MenuItem(id: "403", name: "Coffee", description: "Premium roast coffee", image: "coffee", price: 3.99, categoryId: "4"),
                MenuItem(id: "404", name: "Sparkling Water", description: "Chilled sparkling mineral water", image: "sparkling-water", price: 2.99, categoryId: "4"),
                MenuItem(id: "405", name: "Strawberry Smoothie", description: "Fresh strawberries blended with yogurt", image: "smoothie", price: 5.99, categoryId: "4")
            ]
        ]
        
        // Sample menu item details
        var details: [String: MenuItemDetail] = [:]
        
        // Appetizers
        details["101"] = MenuItemDetail(
            id: "101",
            name: "Caesar Salad",
            description: "Fresh romaine lettuce with our homemade creamy Caesar dressing, topped with croutons and parmesan cheese.",
            image: "caesar-salad",
            price: 8.99,
            categoryId: "1",
            ingredients: ["Romaine lettuce", "Parmesan cheese", "Croutons", "Caesar dressing", "Black pepper"],
            nutritionalInfo: NutritionalInfo(calories: 320, protein: 7.5, carbs: 12.0, fat: 28.0, sugar: 2.5, sodium: 720.0),
            allergens: ["Dairy", "Gluten"],
            preparationTime: 10,
            isFavorite: false
        )
        
        // Main Course
        details["201"] = MenuItemDetail(
            id: "201",
            name: "Spaghetti Carbonara",
            description: "Traditional Italian pasta dish with eggs, cheese, pancetta and black pepper. Our carbonara is made with a silky smooth egg-based sauce without cream.",
            image: "carbonara",
            price: 14.99,
            categoryId: "2",
            ingredients: ["Spaghetti pasta", "Eggs", "Pecorino Romano cheese", "Pancetta", "Black pepper", "Salt"],
            nutritionalInfo: NutritionalInfo(calories: 750, protein: 25.0, carbs: 80.0, fat: 35.0, sugar: 3.0, sodium: 950.0),
            allergens: ["Eggs", "Dairy", "Gluten"],
            preparationTime: 20,
            isFavorite: true
        )
        
        // Dessert
        details["301"] = MenuItemDetail(
            id: "301",
            name: "Tiramisu",
            description: "Classic Italian dessert made with layers of coffee-soaked ladyfingers and mascarpone cream, dusted with cocoa powder.",
            image: "tiramisu",
            price: 7.99,
            categoryId: "3",
            ingredients: ["Ladyfingers", "Mascarpone cheese", "Coffee", "Eggs", "Sugar", "Cocoa powder"],
            nutritionalInfo: NutritionalInfo(calories: 420, protein: 6.0, carbs: 45.0, fat: 22.0, sugar: 32.0, sodium: 160.0),
            allergens: ["Eggs", "Dairy", "Gluten"],
            preparationTime: 15,
            isFavorite: false
        )
        
        // Beverage
        details["401"] = MenuItemDetail(
            id: "401",
            name: "Fresh Orange Juice",
            description: "Freshly squeezed orange juice made daily from premium oranges. No added sugar or preservatives.",
            image: "orange-juice",
            price: 4.50,
            categoryId: "4",
            ingredients: ["Fresh oranges"],
            nutritionalInfo: NutritionalInfo(calories: 120, protein: 1.5, carbs: 28.0, fat: 0.5, sugar: 22.0, sodium: 2.0),
            allergens: [],
            preparationTime: 5,
            isFavorite: false
        )
        
        self.menuItemDetails = details
    }
    
    func fetchCategories() -> AnyPublisher<[MenuCategory], Error> {
        return Just(categories)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMenuItems(categoryId: String) -> AnyPublisher<[MenuItem], Error> {
        guard let items = menuItems[categoryId] else {
            return Fail(error: MenuError.invalidCategory)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        return Just(items)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMenuItemDetail(itemId: String) -> AnyPublisher<MenuItemDetail, Error> {
        guard let detail = menuItemDetails[itemId] else {
            return Fail(error: MenuError.invalidMenuItem)
                .delay(for: .seconds(delay), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        return Just(detail)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(itemId: String, isFavorite: Bool) -> AnyPublisher<Bool, Error> {
        return Just(true)
            .delay(for: .seconds(delay), scheduler: RunLoop.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
#endif