import UIKit

final class ImageDetailViewModel: NSObject {
    
    let author: String
    let url: String
    init(model: ImageModel) {
        self.author = model.author
        self.url = model.downloadURL
    }
    
}
