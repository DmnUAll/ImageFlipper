import UIKit

// MARK: - MainController
final class MainController: UIViewController {

    // MARK: - Properties and Initializers
    lazy var mainView: MainView = {
        let view = MainView()
        return view
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(mainView)
        setupConstraints()
        mainView.delegate = self
    }
}

// MARK: - Helpers
extension MainController {

    private func setupConstraints() {
        let constraints = [
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setImage(_ image: UIImage?) {
        mainView.imageView.image = image
    }

    func hideUI() {
        mainView.imageView.isHidden = true
        mainView.activityIndicator.startAnimating()
    }

    func showUI() {
        mainView.imageView.isHidden = false
        mainView.activityIndicator.stopAnimating()
    }
}

// MARK: - MainViewDelegate
extension MainController: MainViewDelegate {

    func rotateLeft() {
        setImage(mainView.imageView.image?.rotateLeft())
    }

    func rotateRight() {
        setImage(mainView.imageView.image?.rotateRight())
    }

    func mirrorHorizontally() {
        setImage(mainView.imageView.image?.flipHorizontally())
    }

    func mirrorVertically() {
        setImage(mainView.imageView.image?.flipVertically())
    }
}
