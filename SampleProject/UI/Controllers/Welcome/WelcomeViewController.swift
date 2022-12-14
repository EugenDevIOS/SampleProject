//
//  WelcomeViewController.swift
// 

import Shakuro_iOS_Toolbox
import UIKit

class WelcomeViewController: UIViewController {

    private enum LayoutInfo {
        static let topConstraint = UIScreen.main.bounds.height / 812.0 * 167.0
    }

    private let contentScrollView: UIScrollView = UIScrollView()
    private let contentStackView: UIStackView = UIStackView()
    private let contentView: UIView = UIView()

    private let cameraInputContainerView = InputContainerView()
    private let dateInputContainerView = DateInputContainerView()

    private let exploreButton: RoundedButton = RoundedButton()

    private let activityIndicatorView: ActivityIndicatorView = ActivityIndicatorView()
    private var keyboardHandler: KeyboardHandler?

    private var interactor: WelcomeInteractor!

    private let backgroundImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Stylesheet.Color.background
        navigationController?.navigationBar.titleTextAttributes = [.font: Stylesheet.FontFace.navigationBold,
                                                                   .foregroundColor: Stylesheet.Color.black]
        title = NSLocalizedString("Select Camera and Date", comment: "")

        interactor = WelcomeInteractor(output: self, taskManager: SampleTaskManager())

        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.frame = view.bounds
        view.addSubview(backgroundImage)

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.keyboardDismissMode = .interactive
        view.addSubview(contentScrollView)
        contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollView.addSubview(contentView)
        let heightAnchor = contentView.heightAnchor.constraint(equalToConstant: 0)
        heightAnchor.priority = UILayoutPriority(1)
        heightAnchor.isActive = true
        contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: LayoutInfo.topConstraint).isActive = true
        contentView.bottomAnchor.constraint(lessThanOrEqualTo: contentScrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor).isActive = true

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.spacing = 16.0
        contentStackView.alignment = .fill
        contentView.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0).isActive = true
        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        cameraInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        cameraInputContainerView.setTitle(NSLocalizedString("Rover Camera", comment: ""))
        cameraInputContainerView.inputField.showDoneButton = true
        cameraInputContainerView.inputField.setImage(UIImage(named: "dropdown"))
        cameraInputContainerView.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        cameraInputContainerView.inputField.setItems(WelcomeInteractor.CameraType.allCases)

        dateInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        dateInputContainerView.setTitle(NSLocalizedString("Date", comment: ""))
        dateInputContainerView.inputField.showDoneButton = true
        dateInputContainerView.inputField.setImage(UIImage(named: "calendar"))
        dateInputContainerView.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        [cameraInputContainerView, dateInputContainerView].forEach({
            contentStackView.addArrangedSubview($0)
        })

        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        exploreButton.setTitle(NSLocalizedString("Explore", comment: ""), for: .normal)
        exploreButton.backgroundColor = Stylesheet.Color.exploreButton
        exploreButton.addTarget(self, action: #selector(exploreButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(exploreButton)
        exploreButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 40.0).isActive = true
        exploreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0).isActive = true
        exploreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0).isActive = true
        exploreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        exploreButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityIndicatorView.isHidden = true

        keyboardHandler = KeyboardHandler(enableCurveHack: false, heightDidChange: { [weak self] (change: KeyboardHandler.KeyboardChange) in
            guard let strongSelf = self else {
                return
            }
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: change.newHeight, right: 0.0)
            UIView.animateKeyframes(
                withDuration: change.animationDuration,
                delay: 0.0,
                animations: {
                    strongSelf.contentScrollView.contentInset = contentInsets
                },
                completion: nil)
        })
        interactor.getCuriosityInfo()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler?.isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler?.isActive = false
    }

}

// MARK: - WelcomeInteractorOutput

extension WelcomeViewController: WelcomeInteractorOutput {

    func willSendServerRequest() {
        activityIndicatorView.setHidden(false, animated: true)
    }

    func interactor(_ interactor: WelcomeInteractor, loadedInfo: RoverInfo) {
        activityIndicatorView.setHidden(true, animated: true)
        dateInputContainerView.inputField.setDates(minDate: loadedInfo.landingDate, maxDate: loadedInfo.maxDate)
    }

    func interactor(_ interactor: WelcomeInteractor, loadedPhotos: [RoverPhoto]) {
        activityIndicatorView.setHidden(true, animated: true)
        guard !loadedPhotos.isEmpty,
              let selectedDate = dateInputContainerView.inputField.selectedDate,
              let selectedCamera: WelcomeInteractor.CameraType = cameraInputContainerView.inputField.getSelectedItem() else {
            showAlert(with: NSLocalizedString("Unfortunately no photos were found, try changing the date or camera", comment: ""))
            return
        }
        let viewController = PhotosViewController.instantiateViewController(option: PhotosViewController.Option(photos: loadedPhotos,
                                                                                                                selectedDate: selectedDate,
                                                                                                                selectedCamera: selectedCamera))
        navigationController?.pushViewController(viewController, animated: true)
    }

    func interactor(_ interactor: WelcomeInteractor, didReceiveResponseWithError error: AppError?) {
        activityIndicatorView.setHidden(true, animated: true)
        guard let actualError = error else {
            return
        }
        showError(actualError)
    }

}

// MARK: - Private

private extension WelcomeViewController {

    func showAlert(with text: String) {
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                   style: .default)
        let controller = UIAlertController(title: "Ooops",
                                           message: text,
                                           preferredStyle: .alert)
        controller.addAction(action)
        present(controller, animated: true)
    }

    func showError(_ error: AppError) {
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                   style: .default)
        let controller = UIAlertController(title: error.errorTitle(),
                                           message: error.errorDescription(),
                                           preferredStyle: .alert)
        controller.addAction(action)
        present(controller, animated: true)
    }

    @objc func exploreButtonTapped(_ sender: UIButton) {
        guard let selectedDate = dateInputContainerView.inputField.selectedDate,
              let selectedCamera: WelcomeInteractor.CameraType = cameraInputContainerView.inputField.getSelectedItem() else {
            return
        }
        interactor.getCuriosityPhotos(info: RoverPhotosSearchInfo(date: selectedDate,
                                                                  camera: selectedCamera))
    }

}
