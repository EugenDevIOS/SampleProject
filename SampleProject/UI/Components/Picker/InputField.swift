//
//  InputView.swift
//

import UIKit

class InputField: UIView {

    var showDoneButton: Bool = false {
        didSet {
            guard oldValue != showDoneButton else {
                return
            }
            if showDoneButton {
                let doneView = InputAccessoryView()
                doneView.setActionButtonTitle(NSLocalizedString("Done", comment: ""))
                doneView.activationButtonPressed = { [weak self] in
                    self?.inputField.resignFirstResponder()
                }
                inputField.inputAccessoryView = doneView
            } else {
                inputField.inputAccessoryView = nil
            }
        }
    }

    private let inputField: UITextField = UITextField()
    private let arrowIconImageView: UIImageView = UIImageView()
    private let inputPickerView: UIPickerView = UIPickerView()
    private let activationButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        arrowIconImageView.image = image
    }

    private func setup() {
        backgroundColor = Stylesheet.Color.white.withAlphaComponent(0.5)
        clipsToBounds = true
        layer.cornerRadius = 10.0

        activationButton.isExclusiveTouch = true
        activationButton.backgroundColor = UIColor.clear
        activationButton.frame = bounds
        activationButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(activationButton)
        activationButton.addTarget(self, action: #selector(activationButtonPressed(_:)), for: .touchDown)

        inputField.font = Stylesheet.FontFace.terminal18
        inputField.placeholder = NSLocalizedString("Choose", comment: "")
        inputField.borderStyle = .none
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.keyboardAppearance = .dark
        inputField.tintColor = UIColor.clear
        inputField.inputView = inputPickerView
        addSubview(inputField)
        inputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        inputField.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        inputField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true

        arrowIconImageView.contentMode = .scaleAspectFit
        arrowIconImageView.clipsToBounds = true
        arrowIconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowIconImageView)
        arrowIconImageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        arrowIconImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        arrowIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        arrowIconImageView.leadingAnchor.constraint(equalTo: inputField.trailingAnchor, constant: 4.0).isActive = true
    }

    @objc private func activationButtonPressed(_ sender: UIButton) {
        guard !inputField.isFirstResponder else {
            return
        }
        _ = inputField.becomeFirstResponder()
    }

}

// MARK: - UITextFieldDelegate

extension InputField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

}
