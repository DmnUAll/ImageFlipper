import UIKit

// MARK: - MainViewDelegate protocol
protocol MainViewDelegate: AnyObject {

    func rotateLeft()
    func rotateRight()
    func mirrorHorizontally()
    func mirrorVertically()
}

// MARK: - MainView
final class MainView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: MainViewDelegate?

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var rotateLeftButton: UIButton = {
        makeButton(withIcon: "rotate.left", andAction: #selector(rotateLeftTapped))
    }()

    private lazy var rotateRightButton: UIButton = {
        makeButton(withIcon: "rotate.right", andAction: #selector(rotateRightTapped))
    }()

    private lazy var mirrorHorizontallyButton: UIButton = {
        makeButton(withIcon: "trapezoid.and.line.vertical", andAction: #selector(mirrorHorizontallyTapped))
    }()

    private lazy var mirrorVerticallyButton: UIButton = {
        makeButton(withIcon: "trapezoid.and.line.horizontal", andAction: #selector(mirrorVerticallyTapped))
    }()

    private lazy var buttonsStackView: UIStackView = {
        makeStackView(withAxis: .horizontal, andDistribution: .fillEqually)
    }()

    private lazy var mainStackView: UIStackView = {
        makeStackView(withAxis: .vertical, alignment: .center)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension MainView {

    @objc private func rotateLeftTapped() {
        delegate?.rotateLeft()
    }

    @objc private func rotateRightTapped() {
        delegate?.rotateRight()
    }

    @objc private func mirrorHorizontallyTapped() {
        delegate?.mirrorHorizontally()
    }

    @objc private func mirrorVerticallyTapped() {
        delegate?.mirrorVertically()
    }

    private func addSubviews() {
        buttonsStackView.addArrangedSubview(rotateLeftButton)
        buttonsStackView.addArrangedSubview(rotateRightButton)
        buttonsStackView.addArrangedSubview(mirrorHorizontallyButton)
        buttonsStackView.addArrangedSubview(mirrorVerticallyButton)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(activityIndicator)
        addSubview(mainStackView)
        addSubview(buttonsStackView)
    }

    private func setupConstraints() {
        let constraints = [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            mainStackView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -6),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeButton(withIcon iconName: String, andAction action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24), forImageIn: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tintColor = .white
        return button
    }

    private func makeStackView(withAxis axis: NSLayoutConstraint.Axis,
                               alignment: UIStackView.Alignment = .fill,
                               andDistribution distribution: UIStackView.Distribution = .fill
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.toAutolayout()
        stackView.axis = axis
        stackView.spacing = 8
        stackView.alignment = alignment
        stackView.distribution = distribution
        return stackView
    }
}
