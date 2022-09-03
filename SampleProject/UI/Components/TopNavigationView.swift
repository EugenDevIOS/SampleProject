//
//  TopNavigationView.swift
//

import UIKit

class TopNavigationView: UIView {

    private let containerView: UIView = UIView()
    private let contentStackView: UIStackView = UIStackView()

    private let backButton: UIButton = UIButton()
    private let titleLabel: UILabel = UILabel()
    private let subtitleLabel: UILabel = UILabel()

    var backButtonPressed: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 46.0).isActive = true

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        containerView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        backButton.setContentHuggingPriority(UILayoutPriority(255.0), for: .horizontal)

        let placeholderView = UIView()
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.backgroundColor = UIColor.clear
        containerView.addSubview(placeholderView)
        placeholderView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        placeholderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        placeholderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        placeholderView.widthAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        containerView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: placeholderView.leadingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        [titleLabel, subtitleLabel].forEach({ (title) in
            title.backgroundColor = UIColor.clear
            title.textAlignment = .center
            title.setContentHuggingPriority(UILayoutPriority(251.0), for: .horizontal)
            contentStackView.addArrangedSubview(title)
        })

    }

    func setup(_ title: NSAttributedString, subtitle: NSAttributedString?, backButtonImage: UIImage?) {
        titleLabel.attributedText = title
        backButton.setImage(backButtonImage, for: .normal)
        guard let actualSubtitle = subtitle else {
            subtitleLabel.attributedText = nil
            subtitleLabel.isHidden = true
            return
        }
        subtitleLabel.attributedText = actualSubtitle
        subtitleLabel.isHidden = false
    }

    @objc private func backButtonPressed(_ sender: Any) {
        backButtonPressed?()
    }

}

class TopNavigationViewContainer: UIView {

    let navigationView: TopNavigationView = TopNavigationView()

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
