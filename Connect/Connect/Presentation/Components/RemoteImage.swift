import SwiftUI

struct RemoteImage: View {
    let url: String
    let placeholder: String
    
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ZStack {
                Color(.systemGray6)
                
                if isLoading {
                    ProgressView()
                } else if hasError {
                    Text(placeholder)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        isLoading = true
        hasError = false
        
        guard let imageURL = URL(string: url) else {
            isLoading = false
            hasError = true
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let data = data, let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                } else {
                    hasError = true
                }
            }
        }.resume()
    }
}