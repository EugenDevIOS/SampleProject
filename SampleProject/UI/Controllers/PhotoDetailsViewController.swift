//
//  PhotoDetailsViewController.swift
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    struct Option {
        let imageIdentifier: String
        let image: UIImage
    }

    static func instantiateViewController(option: PhotoDetailsViewController.Option) -> PhotoDetailsViewController {
        let viewController = PhotoDetailsViewController()
        viewController.imageIdentifier = option.imageIdentifier
        viewController.image = option.image
        return viewController
    }

    let zoomImageView: ZoomImageView = ZoomImageView()

    private let photoNavigationView: PhotoDetailsNavigationViewContainer = PhotoDetailsNavigationViewContainer()

    private var imageIdentifier: String = ""
    private var image: UIImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Stylesheet.Color.black
        navigationController?.isNavigationBarHidden = true
        photoNavigationView.translatesAutoresizingMaskIntoConstraints = false
        photoNavigationView.backgroundColor = view.backgroundColor
        view.addSubview(photoNavigationView)
        photoNavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoNavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoNavigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoNavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46.0).isActive = true
        photoNavigationView.navigationView.backButtonPressed = { [weak self] in
            guard let actualSelf = self else {
                return
            }
            actualSelf.dismiss(animated: true)
        }
        photoNavigationView.navigationView.shareButtonPressed = { [weak self] in
            guard let actualSelf = self else {
                return
            }
            actualSelf.sharePhoto()
        }

        zoomImageView.layer.masksToBounds = true
        zoomImageView.layer.cornerRadius = 8.0
        zoomImageView.contentMode = .scaleAspectFill
        zoomImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zoomImageView)
        zoomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        zoomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        zoomImageView.topAnchor.constraint(equalTo: photoNavigationView.bottomAnchor, constant: 16.0).isActive = true
        zoomImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34.0).isActive = true
        photoNavigationView.navigationView.setup(subtitle: imageIdentifier)
        zoomImageView.image = image
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private

    private func sharePhoto() {
        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(viewController, animated: true)
    }

}
