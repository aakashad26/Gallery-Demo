import UIKit

class MyCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let imagesViewModel =  GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        imagesViewModel.isDataFetched.bind {[weak self] (isDataAvailable) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        imagesViewModel.fetchImages()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesViewModel.getImageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.textLabel.text =  imagesViewModel.getImageTitleAtIndex(index: indexPath.row)
        let imageString = imagesViewModel.getImageURLAtIndex(index: indexPath.row)
        if let imageURL = URL(string: imageString) {
            cell.imageV.downloaded(from: imageURL)
            
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToImageDetailView(index: indexPath.row)
    }
    
    private func goToImageDetailView(index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let imageDetailController = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController {
            imageDetailController.imageDetailViewModel = imagesViewModel.getImageDetailViewModelAtIndex(index: index)
            self.navigationController!.pushViewController(imageDetailController, animated: true)
            
        }
    }
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 20.0) / 2.0 , height: 150)
    }
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
