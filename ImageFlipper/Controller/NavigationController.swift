import UIKit

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    private var presenter: NavigationPresenter?
    private let imagePicker = UIImagePickerController()

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController()
        presenter = NavigationPresenter(navigationController: self)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NavigationController {

    @objc private func shareTapped() {
        guard let viewController = self.viewControllers.first as? MainController,
              let image = viewController.mainView.imageView.image else { return }
        presenter?.showShareOptions(forImage: image)
    }

    @objc private func webTapped() {
        guard let viewController = self.viewControllers.first as? MainController else { return }
        presenter?.showWebOptions(forViewController: viewController)
    }

    @objc private func galleryTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @objc private func cameraTapped() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    private func configureNavigationController() {
        navigationBar.tintColor = .white
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                          style: .plain,
                                          target: nil,
                                          action: #selector(shareTapped))
        shareButton.isEnabled = false
        let webButton = UIBarButtonItem(image: UIImage(systemName: "globe"),
                                        style: .plain,
                                        target: nil,
                                        action: #selector(webTapped))
        let galleryButton = UIBarButtonItem(image: UIImage(systemName: "photo"),
                                            style: .plain,
                                            target: nil,
                                            action: #selector(galleryTapped))
        let cameraButton = UIBarButtonItem(image: UIImage(systemName: "camera"),
                                           style: .plain,
                                           target: nil,
                                           action: #selector(cameraTapped))
        navigationBar.topItem?.rightBarButtonItems = [cameraButton, galleryButton, webButton, shareButton]
    }

    func enableShareButton() {
        navigationBar.topItem?.rightBarButtonItems?[3].isEnabled = true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension NavigationController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let viewController = self.viewControllers.first as? MainController else { return }
            viewController.setImage(userPickedImage)
            enableShareButton()
        }
        imagePicker.dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationController: UINavigationControllerDelegate {
}
