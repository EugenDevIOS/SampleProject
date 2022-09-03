//
//  PhotosViewController.swift
//

import UIKit

class PhotosViewController: UIViewController {

    struct Option {
        let photos: [RoverPhoto]
        let selectedDate: Date
        let selectedCamera: WelcomeInteractor.CameraType
    }

    private let topNavigationView: TopNavigationViewContainer = TopNavigationViewContainer()

    private var photos: [RoverPhoto] = []
    private var selectedDate: Date?
    private var selectedCamera: WelcomeInteractor.CameraType?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static func instantiateViewController(option: PhotosViewController.Option) -> PhotosViewController {
        let viewController = PhotosViewController()
        viewController.photos = option.photos
        viewController.selectedDate = option.selectedDate
        viewController.selectedCamera = option.selectedCamera
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Stylesheet.Color.background
        navigationController?.isNavigationBarHidden = true
        topNavigationView.backgroundColor = view.backgroundColor
        topNavigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topNavigationView)
        topNavigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topNavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46.0).isActive = true
        let titleAttr: [NSAttributedString.Key: Any] = [
            .font: Stylesheet.FontFace.navigationBold,
            .foregroundColor: Stylesheet.Color.black
        ]
        let subtitleAttr: [NSAttributedString.Key: Any] = [
            .font: Stylesheet.FontFace.terminal14,
            .foregroundColor: Stylesheet.Color.black
        ]
        let title = NSAttributedString(string: selectedCamera?.localizedName ?? "", attributes: titleAttr)
        let subtitle = NSAttributedString(string: dateFormatter.string(from: selectedDate ?? Date()), attributes: subtitleAttr)
        topNavigationView.navigationView.setup(title, subtitle: subtitle, backButtonImage: UIImage(named: "back"))
        topNavigationView.navigationView.backButtonPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

}
