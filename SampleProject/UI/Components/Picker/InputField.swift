//
//  InputView.swift
//

import UIKit

protocol PickerInputItem {
    var title: String {get}
}

class InputField: UIView {

    enum Constant {
        static let rowHeight: CGFloat = 36
    }

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
                    self?.doneButtonPressed?()
                }
                inputField.inputAccessoryView = doneView
            } else {
                inputField.inputAccessoryView = nil
            }
        }
    }

    var doneButtonPressed: (() -> Void)?
    var valueChanged: (() -> Void)?

    private let inputField: UITextField = UITextField()
    private let arrowIconImageView: UIImageView = UIImageView()
    private let inputPickerView: UIPickerView = UIPickerView()
    private let activationButton: UIButton = UIButton()

    private var content: [[PickerInputItem]] = []

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

    func setItems(_ items: [PickerInputItem], shouldUpdateValue: Bool = true) {
        content.removeAll()
        content.append(items)
        inputPickerView.reloadAllComponents()
        if !items.isEmpty {
            inputPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        if shouldUpdateValue {
            updateValue()
        }
    }

    func getSelectedItem<T>() -> T? {
        guard !content.isEmpty else {
            return nil
        }
        if content.count > 1 {
            return nil
        } else {
            let row = inputPickerView.selectedRow(inComponent: 0)
            return row >= 0 ? content[0][row] as? T : nil
        }
    }

}

// MARK: - UIPickerViewDelegate

extension InputField: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return content.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return content[component].count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: content[component][row].title,
                                  attributes: [.font: Stylesheet.FontFace.terminal18, .foregroundColor: Stylesheet.Color.white])
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constant.rowHeight
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateValue()
    }

}

// MARK: - Private

private extension InputField {

    func updateValue() {
        let oldText = inputField.text
        defer {
            if oldText != inputField.text {
                valueChanged?()
            }
        }
        guard !content.isEmpty else {
            inputField.text = ""
            return
        }
        if content.count > 1 {
            // not implemented
        } else {
            let row = inputPickerView.selectedRow(inComponent: 0)
            if row >= 0 {
                inputField.text = content[0][row].title
            } else {
                inputField.text = ""
            }
        }
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

        inputPickerView.delegate = self
        inputPickerView.dataSource = self

        inputField.font = Stylesheet.FontFace.terminal18
        inputField.textColor = Stylesheet.Color.black
        inputField.borderStyle = .none
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
