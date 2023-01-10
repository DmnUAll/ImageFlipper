import UIKit

// MARK: - NavigationPresenter
final class NavigationPresenter {

    // MARK: - Properties and Initializers
    private var navigationController: NavigationController?

    init(navigationController: NavigationController? = nil) {
        self.navigationController = navigationController
    }
}

// MARK: - Helpers
extension NavigationPresenter {

    func showShareOptions(forImage image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = navigationController?.view
        activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook ]
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    func showWebOptions(forViewController viewController: MainController) {
        let alertController = UIAlertController(title: "Load image from web",
                                                message: "Please enter a valid url link to an image:",
                                                preferredStyle: .alert)
        var textField = UITextField()
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Enter URL"
            textField = alertTextField
        }
        let loadAction = UIAlertAction(title: "Load", style: .default) { _ in
            guard let link = textField.text,
                  let url = URL(string: link) else { return }
            viewController.hideUI()
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        viewController.setImage(UIImage(data: data))
                        viewController.showUI()
                        self.navigationController?.enableShareButton()
                    }
                }
            }
        }
        alertController.addAction(loadAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true)
    }
}
