//
//  InputAccessoryView.swift
//

import UIKit

final class InputAccessoryView: UIView {

    private enum LayoutInfo {
        static let heightAnchor: CGFloat = 40.0
    }

    var activationButtonPressed: (() -> Void)?

    private let activationButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setActionButtonTitle(_ title: String) {
        activationButton.setTitle(title, for: .normal)
    }

    private func setup() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
        frame.size.height = LayoutInfo.heightAnchor
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.frame = bounds
        addSubview(effectView)

        activationButton.setTitleColor(UIColor.black, for: .normal)
        activationButton.translatesAutoresizingMaskIntoConstraints = false
        activationButton.titleLabel?.font = Stylesheet.FontFace.terminal14
        addSubview(activationButton)
        activationButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        activationButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        activationButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        activationButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40.0).isActive = true
        activationButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        activationButton.addTarget(self, action: #selector(activationButtonPressed(_:)), for: .touchUpInside)
    }

    @objc private func activationButtonPressed(_ sender: UIButton) {
        activationButtonPressed?()
    }

}
