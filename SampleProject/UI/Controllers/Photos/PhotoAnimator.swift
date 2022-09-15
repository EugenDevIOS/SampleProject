//
//  PhotoAnimator.swift
//

import UIKit

final class PhotoAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private enum Constants {
        static let duration: CGFloat = 0.5
        static let cornerRadius: CGFloat = 8.0
    }

    private let presentationType: PresentationType
    private let firstViewController: PhotosViewController
    private let secondViewController: PhotoDetailsViewController
    private let cellImageViewRect: CGRect

    private var selectedCellImageViewSnapshot: UIView

    init?(presentationType: PresentationType, firstViewController: PhotosViewController, secondViewController: PhotoDetailsViewController, selectedCellImageViewSnapshot: UIView) {
        self.presentationType = presentationType
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot

        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let selectedCell = firstViewController.selectedCell else {
            return nil
        }
        cellImageViewRect = selectedCell.photoImageView.convert(selectedCell.photoImageView.bounds, to: window)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = secondViewController.view else {
            transitionContext.completeTransition(false)
            return
        }

        toView.frame = containerView.bounds
        containerView.addSubview(toView)

        guard let selectedCell = firstViewController.selectedCell,
              let window = firstViewController.view.window ?? secondViewController.view.window,
              let cellImageViewSnapshot = selectedCell.photoImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageViewSnapshot = secondViewController.zoomImageView.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(true)
            return
        }

        let isPresenting = presentationType.isPresenting

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor

        if isPresenting {
            selectedCellImageViewSnapshot = cellImageViewSnapshot
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }

        toView.alpha = 0
        [backgroundView, selectedCellImageViewSnapshot, controllerImageViewSnapshot].forEach({ containerView.addSubview($0) })

        let controllerImageViewRect = secondViewController.zoomImageView.convert(secondViewController.zoomImageView.bounds, to: window)
        let centerImageViewRect = CGRect(x: controllerImageViewRect.midX / 2,
                                         y: controllerImageViewRect.midY / 2,
                                         width: controllerImageViewRect.size.width / 2,
                                         height: controllerImageViewRect.size.height / 2)
        [selectedCellImageViewSnapshot, controllerImageViewSnapshot].forEach({
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
            $0.layer.cornerRadius = isPresenting ? Constants.cornerRadius : 0
            $0.layer.masksToBounds = true
        })

        UIView.animateKeyframes(withDuration: Constants.duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
            if isPresenting {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                    self.selectedCellImageViewSnapshot.frame = centerImageViewRect
                    controllerImageViewSnapshot.frame = centerImageViewRect
                    fadeView.alpha = 1.0

                    [controllerImageViewSnapshot, self.selectedCellImageViewSnapshot].forEach {
                        $0.layer.cornerRadius = 0
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 1) {
                    self.selectedCellImageViewSnapshot.frame = controllerImageViewRect
                    controllerImageViewSnapshot.frame = controllerImageViewRect
                    fadeView.alpha = 1
                }
            } else {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.selectedCellImageViewSnapshot.frame = self.cellImageViewRect
                    controllerImageViewSnapshot.frame = self.cellImageViewRect
                    fadeView.alpha = 0

                    [controllerImageViewSnapshot, self.selectedCellImageViewSnapshot].forEach {
                        $0.layer.cornerRadius = Constants.cornerRadius
                    }
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageViewSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageViewSnapshot.removeFromSuperview()
            backgroundView.removeFromSuperview()
            toView.alpha = 1

            transitionContext.completeTransition(true)
        })
    }

}

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}
