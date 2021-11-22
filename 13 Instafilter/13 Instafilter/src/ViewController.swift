import CoreImage
import UIKit

class ViewController: UIViewController {
    let availableFilters = [
        "CIBumpDistortion",
        "CIGaussianBlur",
        "CIPixellate",
        "CISepiaTone",
        "CITwirlDistortion",
        "CIUnsharpMask",
        "CIVignette",
    ]

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!

    var currentImage: UIImage!

    var context: CIContext!
    var currentFilter: CIFilter!

    @IBAction func changeFilter(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)

        availableFilters.forEach { filter in
            alertController.addAction(UIAlertAction(title: filter, style: .default, handler: setFilter))
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    @IBAction func save(_ sender: Any) {
    }

    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(importPicture)
        )

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        //currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        guard let cgimg = context.createCGImage(image, from: image.extent) else { return }
        let processedImage = UIImage(cgImage: cgimg)
        imageView.image = processedImage
    }

    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        currentImage = image
        //imageView.image = image

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}
