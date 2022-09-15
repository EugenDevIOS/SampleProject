//
//  PhotoCollectionViewCell.swift
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    var photoImageView: UIImageView = UIImageView()
    var image: UIImage? {
        return photoImageView.image
    }

    static let identifier: String = "PhotoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Public

    func setImageURL(_ url: URL?) {
        if let currentURL = url {
            photoImageView.setImageWithURL(currentURL, placeholderImage: UIImage(named: "placeholder"))
        } else {
            photoImageView.cancelImageLoad(UIImage(named: "placeholder"))
        }
    }

    // MARK: - Private

    private func setup() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8.0

        photoImageView.contentMode = .scaleAspectFill
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

}
