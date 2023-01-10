//
//  LabelFoldRZ.swift
//  RZColorfulSwift
//
//  Created by rztime on 2022/1/11.
//

import UIKit

public extension UILabel {
    fileprivate struct RZLabelDraw {
        static var rz_labelTextRectKey = "rz_labelTextRectKey"
    }
    // 用于记录文本绘制的区域，label绘制的文本，将在此区域居中绘制
    var drawTextRect: CGRect {
        set {
            objc_setAssociatedObject(self, &RZLabelDraw.rz_labelTextRectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &RZLabelDraw.rz_labelTextRectKey) as? CGRect) ?? .zero
        }
    }
    // 单例，用于交换drawText方法
    static let rz_swizzledSelector: Bool = {
        UILabel.hookMethnod()
        return true
    }()
     
    private class func hookMethnod() {
        let ori = #selector(UILabel.drawText(in:))
        let sw = #selector(UILabel.rz_drawText(in:))
        guard let om = class_getInstanceMethod(self, ori), let sm = class_getInstanceMethod(self, sw) else { return }
        let didAddMethod = class_addMethod(self, ori, method_getImplementation(sm), method_getTypeEncoding(sm))
        if didAddMethod {
            class_replaceMethod(self, sw, method_getImplementation(om), method_getTypeEncoding(om))
        } else {
            method_exchangeImplementations(om, sm)
        }
    }
    @objc private func rz_drawText(in rect: CGRect) {
        self.rz_drawText(in: rect)
        self.drawTextRect = rect
    }
}

class LabelFoldHeler: UIView {
    private var textView: UITextView?
    private var tap: ((UILabel, String, NSRange) -> Void)?
    func lazyInitTextView(size: CGSize) {
        if textView != nil {
            textView?.systemLayoutSizeFitting(size)
            return
        }
        let textView = UITextView.init(frame: .init(origin: .zero, size: size))
        textView.alpha = 0 
        textView.contentInset = .zero
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.linkTextAttributes = [:]
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView = textView
    }
    private weak var target: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView?.frame = self.bounds
    }
    init(target: UILabel, tapAction: ((UILabel, String, NSRange) -> Void)?) {
        super.init(frame: .zero)
        self.target = target
        self.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :)))
        self.addGestureRecognizer(tap)
        self.tap = tapAction
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let (res, textLink, range) = self.tapPoint(point: point)
        if res, let t = target {
            self.tap?(t, textLink, range)
        }
    }
    
    func tapPoint(point: CGPoint) -> (Bool, String, NSRange) {
        guard let label = target else {
            return (false, "", .init(location: 0, length: 0))
        }
        var point = point
        let textRect = label.drawTextRect
        let rect = label.textRect(forBounds: textRect, limitedToNumberOfLines: 0)
        let offsetY = (textRect.height - rect.height) / 2.0 + textRect.origin.y
        point.y -= offsetY
        point.x -= textRect.origin.x
        lazyInitTextView(size: textRect.size)
        textView?.attributedText = label.attributedText
        var flag = false
        var textLink = ""
        var textRange: NSRange = .init(location: 0, length: 0)
        label.attributedText?.enumerateAttribute(.rztapLabel, in: .init(location: 0, length: label.attributedText?.length ?? 0), options: .longestEffectiveRangeNotRequired, using: { [weak self] (link, range, stop) in
            guard let self = self else {
                stop.initialize(to: true)
                return
            }
            guard let link = link else {
                return
            }
            var obj = ""
            if link is String {
                obj = link as! String
            } else if link is URL {
                obj = (link as! URL).absoluteString
            }
            if let rects = self.textView?.rz.rectsFor(range: range), let _ = rects.first(where: {$0.contains(point)}) {
                flag = true
                textLink = obj
                textRange = range
                stop.initialize(to: true)
            }
        })
        return (flag, textLink, textRange)
    }
    
    /// 重写，在点击事件中，只有点击到显示全文或者收起时，才响应，避免如在列表中，点击展开或者点击列表其他区域，响应列表点击事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let (res, _, _) = self.tapPoint(point: point)
        if res {
            return self
        }
        return nil
    }
}
