import SwiftUI

public struct RemoteImage: View {
    private let url: URL?
    private let contentMode: ContentMode
    private let placeholder: AnyView?
    
    @State private var image: UIImage?
    @State private var isLoading: Bool = false
    @State private var error: Error?
    
    public init(
        url: URL?,
        contentMode: ContentMode = .fill,
        placeholder: AnyView? = nil
    ) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = placeholder
    }
    
    public init(
        urlString: String?,
        contentMode: ContentMode = .fill,
        placeholder: AnyView? = nil
    ) {
        self.url = URL(string: urlString ?? "")
        self.contentMode = contentMode
        self.placeholder = placeholder
    }
    
    public var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ZStack {
                    if let placeholder = placeholder {
                        placeholder
                    } else {
                        Color.gray.opacity(0.1)
                    }
                    
                    ProgressView()
                }
            } else {
                if let placeholder = placeholder {
                    placeholder
                } else {
                    Color.gray.opacity(0.1)
                }
            }
        }
        .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    self.error = error
                    return
                }
                
                guard let data = data, let loadedImage = UIImage(data: data) else {
                    self.error = NSError(domain: "RemoteImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"])
                    return
                }
                
                self.image = loadedImage
            }
        }.resume()
    }
}

// Preview Helpers
struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RemoteImage(urlString: "https://picsum.photos/id/237/200/300")
                .frame(width: 200, height: 200)
                .cornerRadius(8)
            
            RemoteImage(urlString: "invalid-url")
                .frame(width: 200, height: 200)
                .cornerRadius(8)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}