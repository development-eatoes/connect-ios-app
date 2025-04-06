import SwiftUI

struct MenuHomeView: View {
    @State private var selectedCategory: String? = nil
    
    // Menu categories
    private let categories = [
        ("Food Menu", "https://images.unsplash.com/photo-1625937286074-9ca519f7d9dc?ixlib=rb-4.0.3"),
        ("Hard drinks", "https://images.unsplash.com/photo-1608885898957-a26745315d04?ixlib=rb-4.0.3"),
        ("Party Menu", "https://images.unsplash.com/photo-1502872364588-894d7d6ddfab?ixlib=rb-4.0.3"),
        ("Short Hot Menu", "https://images.unsplash.com/photo-1612528443702-f6741f70a049?ixlib=rb-4.0.3")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Banner notification
                    bannerNotification
                    
                    // Header image
                    headerImage
                    
                    VStack(spacing: 24) {
                        // Featured card
                        featuredCard
                        
                        // Upcoming events section
                        upcomingEventsSection
                        
                        // Exclusively yours
                        exclusiveItemsSection
                        
                        // Categories section
                        categoriesSection
                    }
                    .padding()
                    
                    // Footer area
                    footerSection
                    
                    // Tab bar
                    tabBar
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
            .background(Color.black.opacity(0.9))
            .fullScreenCover(item: $selectedCategory) { category in
                MenuCategoryView(categoryName: category)
            }
        }
    }
    
    private var bannerNotification: some View {
        Text("This is a test channel announcement to view your promos!")
            .font(.caption)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .foregroundColor(.black)
    }
    
    private var headerImage: some View {
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544148103-0773bf10d330?ixlib=rb-4.0.3")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .clipped()
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 220)
        }
    }
    
    private var featuredCard: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("SEE YOUR FAVOURITE BURGER")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Pickup at your table")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Button(action: {
                    // Order action
                }) {
                    Text("ORDER NOW")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(6)
                }
                .padding(.top, 4)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .cornerRadius(12)
        }
        .shadow(radius: 3)
    }
    
    private var upcomingEventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Events")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                }
                .cornerRadius(12, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bollywood")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Dec 02")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Buy now action
                    }) {
                        Text("Buy Now")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(6)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6).opacity(0.2))
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
            }
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            // Carousel dots
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == 0 ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: index == 0 ? 20 : 8, height: 8)
                        .animation(.spring(), value: index)
                }
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var exclusiveItemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exclusively yours")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    exclusiveItemCard(
                        name: "Chicken Burger",
                        subtitle: "Crispy & juicy",
                        imageURL: "https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-4.0.3"
                    )
                    
                    exclusiveItemCard(
                        name: "French Fries",
                        subtitle: "Crispy & salty",
                        imageURL: "https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?ixlib=rb-4.0.3"
                    )
                    
                    exclusiveItemCard(
                        name: "Pepperoni Pizza",
                        subtitle: "Hot & spicy",
                        imageURL: "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3"
                    )
                }
                .padding(.bottom, 4)
            }
        }
    }
    
    private func exclusiveItemCard(name: String, subtitle: String, imageURL: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 100)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 140, height: 100)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemGray6).opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 2)
        .frame(width: 140)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(categories, id: \.0) { category in
                    categoryCard(name: category.0, imageURL: category.1)
                        .onTapGesture {
                            selectedCategory = category.0
                        }
                }
            }
            
            Button(action: {
                // View more action
            }) {
                HStack {
                    Text("View more")
                        .foregroundColor(.blue)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private func categoryCard(name: String, imageURL: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 140)
                    .cornerRadius(12)
            }
            
            Text(name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(12)
        }
        .aspectRatio(1.1, contentMode: .fill)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var footerSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .foregroundColor(.gray)
                    
                    Text("Iron Hill Bengaluru")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Popular Junction, Bengaluru, Pizza Pan Rd")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 150)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: {
                        // Edit profile action
                    }) {
                        Text("Edit Profile")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        // Buy gift action
                    }) {
                        Text("Buy Gift")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }
                .padding(.top, 16)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.5))
        }
    }
    
    private var tabBar: some View {
        HStack {
            tabItem(icon: "house.fill", label: "Menu", isSelected: true)
            tabItem(icon: "fork.knife", label: "Reserve Table", isSelected: false)
            tabItem(icon: "gift", label: "Buy Gift Now", isSelected: false)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.8))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .top
        )
    }
    
    private func tabItem(icon: String, label: String, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.caption2)
        }
        .foregroundColor(isSelected ? .blue : .gray)
        .frame(maxWidth: .infinity)
    }
}

// Helper for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MenuHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MenuHomeView()
            .preferredColorScheme(.dark)
    }
}