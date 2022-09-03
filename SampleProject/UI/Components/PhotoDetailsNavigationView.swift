//
//  PhotoDetailsNavigationView.swift
//

import UIKit

class PhotoDetailsNavigationView: UIView {

    private let containerView: UIView = UIView()
    private let contentStackView: UIStackView = UIStackView()

    private let backButton: UIButton = UIButton()
    private let shareButton: UIButton = UIButton()
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()

    var backButtonPressed: (() -> Void)?
    var shareButtonPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = Stylesheet.Color.black
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 46.0).isActive = true

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = UIColor.clear
        backButton.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = Stylesheet.Color.white
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        backButton.setContentHuggingPriority(UILayoutPriority(255.0), for: .horizontal)

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = UIColor.clear
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.tintColor = Stylesheet.Color.white
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(shareButton)
        shareButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        containerView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        titleLabel.text = NSLocalizedString("Photo ID", comment: "")
        titleLabel.font = Stylesheet.FontFace.terminal14
        subtitleLabel.font = Stylesheet.FontFace.navigationBold
        [titleLabel, subtitleLabel].forEach({ (title) in
            title.backgroundColor = UIColor.clear
            title.textColor = Stylesheet.Color.white
            title.textAlignment = .center
            title.setContentHuggingPriority(UILayoutPriority(251.0), for: .horizontal)
            contentStackView.addArrangedSubview(title)
        })

    }

    func setup(subtitle: String) {
        subtitleLabel.text = subtitle
    }

    @objc private func backButtonPressed(_ sender: Any) {
        backButtonPressed?()
    }

    @objc private func shareButtonPressed(_ sender: Any) {
        shareButtonPressed?()
    }

}

class PhotoDetailsNavigationViewContainer: UIView {

    let navigationView: PhotoDetailsNavigationView = PhotoDetailsNavigationView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        navigationView.frame = bounds
        navigationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationView.translatesAutoresizingMaskIntoConstraints = true
        backgroundColor = navigationView.backgroundColor
        addSubview(navigationView)
    }

}
