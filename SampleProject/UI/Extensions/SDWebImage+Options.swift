//
//  SDWebImage+Options.swift
//

import SDWebImage
import UIKit

extension UIImageView {

    enum Constant {
        static let defaultSDWebImageOptopns: SDWebImageOptions = [.retryFailed, .continueInBackground, .handleCookies]
    }

    private struct AssociatedKey {
        static var currentImageURL = "App.UIImageView.currentImageURL"
    }

    private var currentImageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.currentImageURL) as? URL
        }
        set(url) {
            objc_setAssociatedObject(self, &AssociatedKey.currentImageURL, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImageWithURL(_ url: URL,
                         placeholderImage: UIImage?,
                         transition: Bool = true,
                         options: SDWebImageOptions = Constant.defaultSDWebImageOptopns,
                         completion: ((_ error: Error?) -> Void)? = nil) {
        if sd_imageTransition == nil {
            sd_imageTransition = SDWebImageTransition.fade
            sd_imageTransition?.duration = 0.1
        }
        if currentImageURL == nil || currentImageURL != url {
            currentImageURL = url
            sd_setImage(with: url, placeholderImage: placeholderImage, options: options, completed: { [weak self] (image, error, _, _) in
                if let actualSelf = self, actualSelf.currentImageURL == url, (image == nil || error != nil) {
                    actualSelf.currentImageURL = nil
                }
                completion?(error)
            })
        } else {
            completion?(nil)
        }
    }

    func cancelImageLoad(_ placeholder: UIImage? = nil) {
        layer.removeAllAnimations()
        currentImageURL = nil
        sd_cancelCurrentImageLoad()
        image = placeholder
    }

}
