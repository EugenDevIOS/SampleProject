//
//  PhotoDetailsViewController.swift
//

import UIKit
import ZoomImageView

class PhotoDetailsViewController: UIViewController {

    struct Option {
        let photo: RoverPhoto
    }

    static func instantiateViewController(option: PhotoDetailsViewController.Option) -> PhotoDetailsViewController {
        let viewController = PhotoDetailsViewController()
        viewController.photo = option.photo
        return viewController
    }

    private let photoNavigationView: PhotoDetailsNavigationViewContainer = PhotoDetailsNavigationViewContainer()
    private let zoomImageView: ZoomImageView = ZoomImageView()

    private var photo: RoverPhoto?

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
            actualSelf.navigationController?.popViewController(animated: true)
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

        if let actualPhoto = photo {
            photoNavigationView.navigationView.setup(subtitle: "\(actualPhoto.identifier)")
            zoomImageView.imageView.setImageWithURL(actualPhoto.url, placeholderImage: UIImage(named: "placeholder"))
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Private

    private func sharePhoto() {
        guard let actualPhoto = zoomImageView.image else {
            return
        }
        let viewController = UIActivityViewController(activityItems: [actualPhoto], applicationActivities: nil)
        present(viewController, animated: true)
    }

}
