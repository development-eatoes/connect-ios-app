import SwiftUI

struct MenuHomeView: View {
    @StateObject var viewModel: MenuViewModel
    @State private var navigateToCategory: MenuCategory?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // App Bar
                HStack {
                    Text("Connect Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        // Profile action
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 2)
                
                // Categories Grid
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                    } else if viewModel.categories.isEmpty {
                        EmptyStateView(message: "No categories available")
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(
                                    destination: CategoryDetailView(
                                        viewModel: viewModel,
                                        category: category
                                    ),
                                    tag: category,
                                    selection: $navigateToCategory
                                ) {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadCategories()
            }
            .alert(item: Binding<MenuError?>(
                get: { viewModel.errorMessage.map { MenuError(message: $0) } },
                set: { _ in viewModel.errorMessage = nil }
            )) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct MenuError: Identifiable {
    let id = UUID()
    let message: String
}

struct CategoryCard: View {
    let category: MenuCategory
    
    var body: some View {
        VStack {
            RemoteImage(
                url: category.imageURL,
                placeholder: category.name
            )
            .frame(height: 120)
            .cornerRadius(8)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 8)
                .padding(.bottom, 4)
                .multilineTextAlignment(.center)
            
            Text("\(category.items.count) items")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4)
    }
}

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}