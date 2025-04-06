import SwiftUI

struct MenuItemDetailView: View {
    let itemDetail: MenuItemDetail
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with image
                headerSection
                
                // Main content
                VStack(alignment: .leading, spacing: 24) {
                    // Title and price
                    titleSection
                    
                    // Description
                    descriptionSection
                    
                    // Ingredients
                    ingredientsSection
                    
                    // Nutritional information
                    if let nutritionalInfo = itemDetail.nutritionalInfo {
                        nutritionalInfoSection(nutritionalInfo)
                    }
                    
                    // Allergens
                    allergensSection
                    
                    // Preparation time
                    preparationTimeSection
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Would implement toggle favorite here
                }) {
                    Image(systemName: itemDetail.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(itemDetail.isFavorite ? .red : .gray)
                        .font(.title3)
                }
            }
        }
    }
    
    // Header section with image
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // This is a placeholder for the image
            // In a real app, use AsyncImage or SDWebImageSwiftUI
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 250)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                )
                .edgesIgnoringSafeArea(.top)
            
            // Price tag overlay
            Text("$\(String(format: "%.2f", itemDetail.price))")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.blue)
                )
                .foregroundColor(.white)
                .offset(y: 20)
        }
    }
    
    // Title section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(itemDetail.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 16)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                
                Text("\(itemDetail.preparationTime) min preparation time")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // Description section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
            
            Text(itemDetail.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    // Ingredients section
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(itemDetail.ingredients, id: \.self) { ingredient in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                        
                        Text(ingredient)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // Nutritional information section
    private func nutritionalInfoSection(_ nutritionalInfo: NutritionalInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nutritional Information")
                .font(.headline)
            
            HStack {
                // Nutrients in a grid layout
                VStack(alignment: .leading, spacing: 12) {
                    NutrientRow(name: "Calories", value: "\(nutritionalInfo.calories) kcal")
                    NutrientRow(name: "Protein", value: "\(nutritionalInfo.protein)g")
                    NutrientRow(name: "Carbs", value: "\(nutritionalInfo.carbs)g")
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    NutrientRow(name: "Fat", value: "\(nutritionalInfo.fat)g")
                    NutrientRow(name: "Sugar", value: "\(nutritionalInfo.sugar)g")
                    NutrientRow(name: "Sodium", value: "\(nutritionalInfo.sodium)mg")
                }
            }
        }
    }
    
    // Allergens section
    private var allergensSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Allergens")
                .font(.headline)
            
            if itemDetail.allergens.isEmpty {
                Text("No allergens listed")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                HStack {
                    ForEach(itemDetail.allergens, id: \.self) { allergen in
                        Text(allergen)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.red.opacity(0.1))
                            )
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    // Preparation time section
    private var preparationTimeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preparation Time")
                .font(.headline)
            
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text("\(itemDetail.preparationTime) minutes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 24)
        }
    }
}

// Helper view for nutritional information rows
struct NutrientRow: View {
    let name: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 70, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#if DEBUG
struct MenuItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuItemDetailView(
                itemDetail: MenuItemDetail(
                    id: "1",
                    name: "Margherita Pizza",
                    description: "Classic Italian pizza with tomato sauce, mozzarella, fresh basil, salt, and extra-virgin olive oil.",
                    image: "",
                    price: 12.99,
                    categoryId: "1",
                    ingredients: ["Tomato sauce", "Mozzarella cheese", "Fresh basil", "Olive oil", "Salt"],
                    nutritionalInfo: NutritionalInfo(
                        calories: 850,
                        protein: 15.0,
                        carbs: 90.0,
                        fat: 40.0,
                        sugar: 8.0,
                        sodium: 1200.0
                    ),
                    allergens: ["Dairy", "Gluten"],
                    preparationTime: 15,
                    isFavorite: true
                )
            )
        }
    }
}
#endif