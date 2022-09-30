//
//  ViewRZ.swift
//  RZColorfulSwift
//
//  Created by rztime on 2021/3/26.
//

import UIKit
/// 给UIView添加手势点击事件
public extension RZColorfulSwiftBase where T: UIView {
    /// 给UIView添加手势点击事件
    func tap(_ handler:@escaping ((UIView) -> Void)) {
        self.tap(1, 1, handler)
    }
    /// 给UIView添手势加点击事件
    func tap(_ numberOfTouches: Int, _ numberOfTaps: Int, _ handler:@escaping ((UIView) -> Void)) {
        self.rz.tap(numberOfTouches, numberOfTaps, handler)
    }
}

// MARK: - 给view添加点击事件
fileprivate extension UIView {
    struct UIViewPerpotyName {
        static var taphandlerKey = "rz_colorful_taphandlerKey"
    }

    var taphandler :((UIView) -> Void)? {
        set {
            objc_setAssociatedObject(self, &UIViewPerpotyName.taphandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIViewPerpotyName.taphandlerKey) as? ((UIView) -> Void)
        }
    }
    @objc func rztapAction(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            self.taphandler?(self)
        }
    }
    func tap(_ handler:@escaping ((UIView) -> Void)) {
        self.tap(1, 1, handler)
    }

    func tap(_ numberOfTouches: Int, _ numberOfTaps: Int, _ handler:@escaping ((UIView) -> Void)) {
        let tapges = UITapGestureRecognizer()
        tapges.numberOfTouchesRequired = numberOfTouches
        tapges.numberOfTapsRequired = numberOfTaps
        self.gestureRecognizers?.forEach({ (obj) in
            self.removeGestureRecognizer(obj)
        })
        tapges.addTarget(self, action: #selector(rztapAction(_:)))
        self.addGestureRecognizer(tapges)
        self.taphandler = handler
        self.isUserInteractionEnabled = true
    }
}
