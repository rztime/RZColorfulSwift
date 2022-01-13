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

public extension RZColorfulSwiftBase where T: UILabel {
    
    /// 设置富文本（超过行数后，自动追加“展开” “收起”）
    /// - Parameters:
    ///   - attributedString: 原文
    ///   - maxLine: 最大显示行数
    ///   - maxWidth: 最大显示宽度，这个宽度用于计算文本行
    ///   - isFold: 当前是否折叠
    ///   - showAllText: 超过了行数之后，折叠状态显示的文本 如”展开“  需要给文本设置rztapLabel属性
    ///   - showFoldText: 超过行数之后，全部展开状态显示的文本  如”收起“  需要给文本设置rztapLabel属性
    ///   根据 tapAction返回的tapActionId, 可判断点击的是展开还是收起
    func set(attributedString: NSAttributedString?, maxLine: Int, maxWidth: CGFloat, isFold: Bool, showAllText: NSAttributedString?, showFoldText: NSAttributedString?) {
        self.rz.numberOfLines = 0
        guard let attr = attributedString, attr.length != 0 else {
            self.rz.attributedText = nil
            return
        } 
        self.rz.attributedText = attr.rz.attributedStringBy(maxline: maxLine, maxWidth: maxWidth, isFold: isFold, showAllText: showAllText, showFoldText: showFoldText)
    }
    
    /// 给UILabel添加富文本点击事件，给NSAttributedString添加".rztapLabel"属性即可
    func tapAction(_ tapAction:((_ label: UILabel, _ tapActionId: String, _ range: NSRange) -> Void)?) {
        let label = self.rz
        label.isUserInteractionEnabled = true
        var v: LabelFoldHeler? = self.rz.subviews.first(where: {$0.isKind(of: LabelFoldHeler.self)}) as? LabelFoldHeler
        if v == nil {
            _ = UILabel.rz_swizzledSelector
            v = .init(target: self.rz, tapAction: { label, text, range in
                tapAction?(label, text, range)
            })
            guard let v = v else { return }
            self.rz.addSubview(v)
            let v1 = v
            let left = NSLayoutConstraint.init(item: v1, attribute: .left, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint.init(item: v1, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint.init(item: v1, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint.init(item: v1, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
            label.addConstraints([left, top, right, bottom])
        }
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
            if let rect = self.textView?.rz.rectFor(range: range) {
                if rect.contains(point) {
                    flag = true
                    textLink = obj
                    textRange = range
                    stop.initialize(to: true)
                }
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
