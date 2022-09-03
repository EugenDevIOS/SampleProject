//
//  DateInputField.swift
//

import UIKit

class DateInputField: UIView {

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

    private(set) var selectedDate: Date? = Date()

    private let inputField: UITextField = UITextField()
    private let arrowIconImageView: UIImageView = UIImageView()
    private let datePickerView: UIDatePicker = UIDatePicker()
    private let activationButton: UIButton = UIButton()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

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

}

// MARK: - UITextFieldDelegate

extension DateInputField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }

}

// MARK: - Private

private extension DateInputField {

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

        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        inputField.font = Stylesheet.FontFace.terminal18
        inputField.placeholder = NSLocalizedString("Choose", comment: "")
        inputField.borderStyle = .none
        inputField.delegate = self
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.keyboardAppearance = .dark
        inputField.tintColor = UIColor.clear
        inputField.inputView = datePickerView
        inputField.text = dateFormatter.string(from: Date())
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

    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        inputField.text = dateFormatter.string(from: sender.date)
    }

}
