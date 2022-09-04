//
//  InputContainerView.swift
//

import UIKit

class InputContainerView: UIView {

    let inputField: InputField = InputField()
    private let titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    private func setup() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = Stylesheet.FontFace.terminal14
        titleLabel.textColor = Stylesheet.Color.black
        addSubview(titleLabel)
        let topAnchor = topAnchor.constraint(equalTo: topAnchor)
        topAnchor.priority = UILayoutPriority(999)
        topAnchor.isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true

        inputField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputField)
        inputField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        inputField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7.0).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        inputField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
