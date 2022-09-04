import NVActivityIndicatorView
import UIKit

enum ActivityIndicatorSize {
    static let big: CGSize = CGSize(width: 60, height: 60)
    static let small: CGSize = CGSize(width: 40, height: 40)
}

class ActivityIndicatorView: UIView {

    var color: UIColor {
        get {
            return indicator.color
        }
        set {
            progressLabel.textColor = newValue
            indicator.color = newValue
        }
    }

    private var indicator: NVActivityIndicatorView!
    private var indicatorSizeWidth: NSLayoutConstraint!
    private var indicatorSizeHeight: NSLayoutConstraint!
    private var internalIsHidden: Bool = true
    private var progressLabel: UILabel = UILabel()
    private var progressLabelOffset: NSLayoutConstraint?

    private var indicatorContainer: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var text: String? {
        get {
            return progressLabel.text
        }
        set {
            progressLabelOffset?.constant = (newValue?.isEmpty ?? true) ? 0 : 20
            progressLabel.text = newValue
        }
    }

    var indicatorSize: CGSize {
        get {
            return CGSize(width: indicatorSizeWidth.constant, height: indicatorSizeHeight.constant)
        }
        set {
            indicatorSizeWidth.constant = newValue.width
            indicatorSizeHeight.constant = newValue.height
        }
    }

    func setHidden(_ hidden: Bool, animated: Bool) {
        guard internalIsHidden != hidden || !animated else {
            return
        }
        internalIsHidden = hidden
        let actualAlpha: CGFloat = hidden ? 0.0 : 1.0
        if animated {
            if !hidden {
                isHidden = false
                if !indicator.isAnimating {
                    indicator.startAnimating()
                }
            }
            UIView.animate(withDuration: 0.2,
                           delay: 0.0,
                           options: [.curveEaseInOut, .beginFromCurrentState],
                           animations: {
                            self.alpha = actualAlpha
            }, completion: { (_) in
                if self.internalIsHidden && hidden {
                    self.indicator.stopAnimating()
                    self.isHidden = hidden
                }
            })
        } else {
            isHidden = hidden
            alpha = actualAlpha
            if hidden {
                indicator.stopAnimating()
            } else {
                indicator.startAnimating()
            }
        }
    }

    private func setup() {
        isHidden = true
        internalIsHidden = true
        alpha = 0.0
        clipsToBounds = true
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let indicatorFrame: CGRect = CGRect(origin: CGPoint.zero, size: ActivityIndicatorSize.big)
        indicatorContainer.frame = indicatorFrame
        indicatorContainer.clipsToBounds = false
        indicatorContainer.backgroundColor = UIColor.clear
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorContainer)
        indicatorContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true

        indicator = NVActivityIndicatorView(frame: indicatorFrame,
                                            type: .ballRotateChase,
                                            color: Stylesheet.Color.exploreButton,
                                            padding: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicatorSizeHeight = indicator.heightAnchor.constraint(equalToConstant: indicatorFrame.size.height)
        indicatorSizeWidth = indicator.widthAnchor.constraint(equalToConstant: indicatorFrame.size.width)
        indicatorSizeHeight.isActive = true
        indicatorSizeWidth.isActive = true
        indicatorContainer.addSubview(indicator)
        indicator.topAnchor.constraint(equalTo: indicatorContainer.topAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor).isActive = true
        indicator.leadingAnchor.constraint(greaterThanOrEqualTo: indicatorContainer.leadingAnchor).isActive = true
        indicatorContainer.trailingAnchor.constraint(greaterThanOrEqualTo: indicator.trailingAnchor).isActive = true

        progressLabel.textColor = indicator.color
        progressLabel.font = Stylesheet.FontFace.terminal18
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainer.addSubview(progressLabel)
        progressLabel.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor).isActive = true
        progressLabelOffset = progressLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 0)
        progressLabelOffset?.isActive = true
        indicatorContainer.bottomAnchor.constraint(equalTo: progressLabel.bottomAnchor).isActive = true
        progressLabel.leadingAnchor.constraint(greaterThanOrEqualTo: indicatorContainer.leadingAnchor).isActive = true
        indicatorContainer.trailingAnchor.constraint(greaterThanOrEqualTo: progressLabel.trailingAnchor).isActive = true
    }
}
