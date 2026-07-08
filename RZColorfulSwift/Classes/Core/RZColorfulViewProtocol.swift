//
//  RZColorfulCustomViewProtocol.swift
//  RZColorfulSwift
//
//  Created by rztime on 2026/6/30.
//

import UIKit
/// 让UILabel、UITextView支持添加自定义视图
/// 原理：将自定义视图当做附件NSAttachment，并绑定到NSAttachment的customView上
/// 在UILabel、UITextView上添加一个RZColorfulCustomView，
/// 在view里监听文本改变/视图改变后，去layoutsubviews，在内部通过textKit计算出NSAttachment对应的位置，在该位置设置自定义视图
public protocol RZColorfulViewProtocol where Self: UIView {
    /// 激活Colorful功能(添加的自定义view、backgroundLayer, backgroundView的功能)
    @discardableResult
    func activeColorful(enable: Bool) -> RZColorfulView?
    
    var textLayout: TextLayoutRZ? { get set }
    
    var attrText: NSAttributedString? { get }
}
extension RZColorfulViewProtocol {
    @discardableResult
    public func activeColorful(enable: Bool = true) -> RZColorfulView? {
        if !enable {
            self.subviews.forEach { v in
                if v.isKind(of: RZColorfulView.self) {
                    v.removeFromSuperview()
                }
            }
        } else {
            if let v = self.subviews.first(where: {$0.isKind(of: RZColorfulView.self)}) as? RZColorfulView {
                return v
            }
            self.isUserInteractionEnabled = true
            let v = RZColorfulView.init(target: self)
            if let tv = self as? UITextView {
                tv.rz.disableLink()
                tv.rz.disableAttachment()
            }
            return v
        }
        return nil
    }
}
private var labelTextLayout: UInt8 = 1
extension UILabel: RZColorfulViewProtocol {
    public var attrText: NSAttributedString? {
        return self.attributedText
    }
    public var textLayout: TextLayoutRZ? {
        get {
            var textLayout = objc_getAssociatedObject(self, &labelTextLayout) as? TextLayoutRZ
            if textLayout == nil {
                let tl = TextLayoutRZ.init(attributedText: .init(), size: self.bounds.size)
                self.textLayout = tl
                textLayout = tl
            }
            if let t = self.attributedText, t.length > 0 {
                textLayout?.updateBy(self)
                return textLayout
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &labelTextLayout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
private var textViewTextLayout: UInt8 = 1
extension UITextView: RZColorfulViewProtocol {
    public var attrText: NSAttributedString? {
        return self.attributedText
    }
    public var textLayout: TextLayoutRZ? {
        get {
            var textLayout = objc_getAssociatedObject(self, &textViewTextLayout) as? TextLayoutRZ
            if textLayout == nil {
                let tl = TextLayoutRZ.init(textView: self)
                self.textLayout = tl
                textLayout = tl
            }
            if let t = self.attributedText, t.length > 0 {
                return textLayout
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &textViewTextLayout, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
