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

    private var contentCollectionView: UICollectionView!

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

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = LayoutInfo.interitemSpacing - 1
        collectionViewLayout.minimumInteritemSpacing = LayoutInfo.interitemSpacing - 1
        contentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.backgroundColor = view.backgroundColor
        contentCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        view.addSubview(contentCollectionView)
        contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentCollectionView.topAnchor.constraint(equalTo: topNavigationView.bottomAnchor).isActive = true
        contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        contentCollectionView.collectionViewLayout.invalidateLayout()
    }

}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    enum LayoutInfo {
        static let inset: CGFloat = 8.0
        static let interitemSpacing: CGFloat = 8
        static let numberOfItemsPerRow: Int = 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
        cell.setImageURL(photos[indexPath.item].url)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutInfo.inset * 2, left: LayoutInfo.inset * 2, bottom: 0, right: LayoutInfo.inset * 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.size.width - LayoutInfo.inset * 6) / 3
        return CGSize(width: width, height: width)
    }

}
