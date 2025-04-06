import SwiftUI
import Combine

public class MenuViewModel: ObservableObject {
    @Published public var categories: [MenuCategory] = []
    @Published public var isLoading: Bool = false
    @Published public var error: String? = nil
    
    private let fetchMenuUseCase: FetchMenuUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(fetchMenuUseCase: FetchMenuUseCase) {
        self.fetchMenuUseCase = fetchMenuUseCase
    }
    
    public func fetchMenu() {
        isLoading = true
        error = nil
        
        fetchMenuUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.error = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] menuItems in
                    self?.processMenuItems(menuItems)
                }
            )
            .store(in: &cancellables)
    }
    
    private func processMenuItems(_ items: [MenuItem]) {
        // Group items by category
        let grouped = Dictionary(grouping: items, by: { $0.category })
        
        // Create categories
        self.categories = grouped.map { (key, items) in
            MenuCategory(id: key, name: key, items: items)
        }.sorted(by: { $0.name < $1.name })
    }
}
