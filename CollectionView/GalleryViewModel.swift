import UIKit

final class GalleryViewModel: NSObject {
    
    var isDataFetched =  ViewModelBinder(false)
    var imageGallery = [ImageModel]() {
        didSet {
            isDataFetched.value = imageGallery.count > 0
        }
    }
    func fetchImages() {
        guard let url = URL(string: "https://picsum.photos/v2/list") else {return}
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data,
               let imageGallery = try? JSONDecoder().decode(ImageGallery.self, from: data) {
                self.imageGallery = imageGallery
            }
        })
        task.resume()
    }
    
    func getImageCount() -> Int {
        return self.imageGallery.count
    }
    func getImageURLAtIndex(index: Int) -> String {
        
        return self.imageGallery[index].downloadURL
    }
    
    func getImageTitleAtIndex(index: Int) -> String {
        
        return self.imageGallery[index].author
    }
    
    func getImageDetailViewModelAtIndex(index: Int) -> ImageDetailViewModel {
        
        return ImageDetailViewModel(model: self.imageGallery[index])
    }
}
