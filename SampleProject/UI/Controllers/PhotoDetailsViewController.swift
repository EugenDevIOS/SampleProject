//
//  PhotoDetailsViewController.swift
//

import UIKit

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
    private let photoImageView: UIImageView = UIImageView()

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

        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 8.0
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        photoImageView.topAnchor.constraint(equalTo: photoNavigationView.bottomAnchor, constant: 16.0).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -34.0).isActive = true

        if let actualPhoto = photo {
            photoNavigationView.navigationView.setup(subtitle: "\(actualPhoto.identifier)")
            photoImageView.setImageWithURL(actualPhoto.url, placeholderImage: UIImage(named: "placeholder"))
        }
    }

}
