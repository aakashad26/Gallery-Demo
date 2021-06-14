import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    var imageDetailViewModel: ImageDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageinfo()
        // Do any additional setup after loading the view.
    }
    
    private func configureImageinfo() {
        guard let validViewModel = imageDetailViewModel else {return}
        if let downloadURL = URL(string: validViewModel.url) {
            imageView.downloaded(from: downloadURL)
        }
        
        labelName.text = validViewModel.author
        labelDescription.text = validViewModel.url
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
