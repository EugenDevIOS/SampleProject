//
//  UIScrollView+Helpers.swift
//

import UIKit

extension UIScrollView {

    func scrollToView(_ descendantView: UIView, extend: CGFloat, animated: Bool) {
        var scrollrect: CGRect = convert(descendantView.bounds, from: descendantView)
        scrollrect.size.height += extend
        scrollRectToVisible(scrollrect, animated: true) // to avoid animation glitch
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollRectToVisible(scrollrect, animated: false)
            })
        } else {
            scrollRectToVisible(scrollrect, animated: false)
        }
    }

}
