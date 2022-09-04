//
//  RoundedButton.swift
//

import UIKit

class RoundedButton: UIButton {

    private enum Constant {
        static let cornerRadius: CGFloat = 10.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = Constant.cornerRadius
        titleLabel?.font = Stylesheet.FontFace.navigationBold
        setTitleColor(Stylesheet.Color.white, for: .normal)
    }

}
