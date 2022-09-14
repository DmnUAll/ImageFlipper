//
//  ViewController.swift
//  ImageFlipper
//
//  Created by Илья Валито on 13.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let imagePicker = UIImagePickerController()
    private var isRotated = false
    private var isMirrored = false
    
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var editButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction private func getImageTapped(_ sender: UIBarButtonItem) {
        
        if sender.tag == 0 {
            imagePicker.sourceType = .photoLibrary
        } else {
            imagePicker.sourceType = .camera
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func rotateLeftTapped() {
        imageView.image = imageView.image?.rotateLeft()
    }
    
    @IBAction private func rotateRightTapped() {
        imageView.image = imageView.image?.rotateRight()
    }
    
    @IBAction private func mirrorVerticallyTapped() {
        imageView.image = imageView.image?.flipVertically()
    }
    
    @IBAction private func mirrorHorizontallyTapped() {
        imageView.image = imageView.image?.flipHorizontally()
    }
    
    @IBAction private func imageFromWebTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Load image from web", message: "Please enter a valid url link to an image:", preferredStyle: .alert)
        
        var textField = UITextField()
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Enter URL"
            textField = alertTextField
        }
        
        let loadAction = UIAlertAction(title: "Load", style: .default) { _ in
            
            guard let link = textField.text else { return }
            
            guard let url = URL(string: link) else { return }
            
            self.imageView.isHidden = true
            self.activityIndicator.startAnimating()
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                        self.imageView.isHidden = false
                        self.activityIndicator.stopAnimating()
                        self.enableButtons()
                    }
                }
            }
        }
        alertController.addAction(loadAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @IBAction private func shareTapped(_ sender: UIBarButtonItem) {
        let image = imageView.image!
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func enableButtons() {
        shareButton.isEnabled = true
        for button in editButtons {
            button.isEnabled = true
        }
    }
}

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            enableButtons()
        }
        imagePicker.dismiss(animated: true)
    }
}

extension MainViewController: UINavigationControllerDelegate {
}

extension UIImage {
    func rotateLeft() -> UIImage? {
        switch self.imageOrientation {
                case .right:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .up)
                case .down:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
                case .left:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
                default:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
            }
    }
    
    func rotateRight() -> UIImage? {
        switch self.imageOrientation {
                case .right:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
                case .down:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
                case .left:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .up)
                default:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
            }
    }
    
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func flipVertically() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

