//
//  RZColorfulView.swift
//  RZColorfulSwift
//
//  Created by rztime on 2026/6/26.
//

import UIKit

public struct RZColorfulTapCache {
    let attr: NSAttributedString
    let size: CGSize
    // 点击的位置
    let point: CGPoint
    // 点击的range
    let range: NSRange?
    /// 点击位置的属性
    let dict: [NSAttributedString.Key : Any]?
}
open class RZColorfulTextViewHelper: UIView {
    weak var infoView: UIView?
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let v = infoView?.hitTest(point, with: event)
        return v
    }
}
/// 此view会添加在UILabel或者UITextView上，用于监听UILabel或者UITextView的改变，然后实时更新富文本添加的view或者backgroundLayer
open class RZColorfulView: UIView {
    public var tapAction: ColorfulTapActionRZ?
    public weak var target: RZColorfulViewProtocol?
    public var textLayout: TextLayoutRZ?
    public var needReload: Bool = true
    
    public var cache: RZColorfulTapCache?
    
    public var textViewHelper: RZColorfulTextViewHelper?
    deinit {
        NotificationCenter.default.removeObserver(self)
        target?.removeObserver(self, forKeyPath: "text")
        target?.removeObserver(self, forKeyPath: "attributedText")
        target?.removeObserver(self, forKeyPath: "bounds")
        target?.removeObserver(self, forKeyPath: "frame")
    }
    public init(target: RZColorfulViewProtocol) {
        super.init(frame: target.bounds)
        self.layer.masksToBounds = true
        self.target = target
        self.translatesAutoresizingMaskIntoConstraints = false
        target.addObserver(self, forKeyPath: "text", options: [.new], context: nil)
        target.addObserver(self, forKeyPath: "attributedText", options: [.new], context: nil)
        target.addObserver(self, forKeyPath: "bounds", options: [.new, .old], context: nil)
        target.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
        if let target = target as? UITextView {
            NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged), name: UITextView.textDidChangeNotification, object: target)
            /// textView因为一些原因，不能将self直接添加到最顶层，所以这里用一个helper，在helper中hittst来响应self的方法
            target.insertSubview(self, at: 0)
            let v = RZColorfulTextViewHelper.init()
            v.isHidden = true
            v.infoView = self
            target.addSubview(v)
            textViewHelper = v
        } else {
            target.addSubview(self)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapgesureAction(_ :)))
        self.addGestureRecognizer(tap)
    }
    @objc func tapgesureAction(_ sender: UITapGestureRecognizer) {
        guard let attributed = cache?.dict, let range = cache?.range else { return }
        if let value = attributed[.rztapAction] as? String {
            let id = value.removingPercentEncoding ?? value
            tapAction?(self.target, id, range)
        } else if let value = attributed[.link] as? String {
            let id = value.removingPercentEncoding ?? value
            tapAction?(self.target, id, range)
        } else if let value = (attributed[.link] as? URL)?.absoluteString {
            let id = value.removingPercentEncoding ?? value
            tapAction?(self.target, id, range)
        } else if let value = attributed[.rzclicked] as? ColorfulClickedRZ {
            value(self.target, range)
        }
    }
    @objc public func textViewDidChanged() {
        self.needReload = true
        self.setNeedsLayout()
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" || keyPath == "attributedText" {
            self.needReload = true
        } else if keyPath == "bounds" || keyPath == "frame" {
            let old = change?[.oldKey] as? CGRect
            let new = change?[.newKey] as? CGRect
            if old != new {
                self.needReload = true
            }
        }
        self.setNeedsLayout()
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let target = target, self.frame != target.bounds {
            self.frame = target.bounds
            self.needReload = true
        }
        textViewHelper?.frame = self.frame
        if self.needReload {
            self.needReload = false
            self.textLayout = target?.textLayout
            reload()
        }
    }
    func reload() {
        self.subviews.forEach({$0.removeFromSuperview()})
        guard let target = target, let attr = target.attrText, attr.length > 0, self.bounds.size.width > 0, self.bounds.size.height > 0 else { return }
        let textLayout = self.textLayout
        let yoffset = self.yoffset
        func resetCustomeViewFrame() {
            var items: [(NSTextAttachment, NSRange)] = []
            attr.enumerateAttribute(.attachment, in: .init(location: 0, length: attr.length), options: .longestEffectiveRangeNotRequired) { value, range, _ in
                if let value = value as? NSTextAttachment, let _ = value.customView {
                    items.append((value, range))
                }
            }
            guard items.count > 0 else { return }
            items.forEach { [weak self] attach, range in
                if let view = attach.customView, let rect = textLayout?.rect(for: range) {
                    var f = CGRect.init(x: rect.origin.x, y: rect.origin.y + yoffset, width: rect.size.width, height: rect.size.height)
                    f.size = attach.bounds.size
                    view.frame = f
                    self?.addSubview(view)
                }
            }
        }
        func resetBackgroundView() {
            var items: [(ColorfulBackgroundViewRZ, NSRange)] = []
            attr.enumerateAttribute(.rzbackgroundView, in: .init(location: 0, length: attr.length)) { value, range, _ in
                if let value = value as? ColorfulBackgroundViewRZ {
                    items.append((value, range))
                }
            }
            guard items.count > 0 else { return }
            items.forEach { [weak self] background, range in
                if var rects = textLayout?.rects(for: range) {
                    rects = rects.compactMap({ rect -> CGRect in
                        return CGRect.init(x: rect.origin.x, y: rect.origin.y + yoffset, width: rect.size.width, height: rect.size.height)
                    })
                    let views = background(rects)
                    views.forEach { view in
                        self?.addSubview(view)
                    }
                }
            }
        }
        resetCustomeViewFrame()
        resetBackgroundView()
    }
    public func tap(point: CGPoint) -> RZColorfulTapCache? {
        guard let target = target, let attr = target.attrText, attr.length > 0, self.bounds.size.width > 0, self.bounds.size.height > 0 else { return nil }
        if let cache = cache,
           cache.point.diff(point: point, min: 1),
           cache.attr == attr,
           cache.size == target.bounds.size {
            return cache
        }
        let textLayout = self.textLayout
        let yoffset = self.yoffset
        let tappoint = CGPoint.init(x: point.x, y: point.y - yoffset)
        guard let index = textLayout?.characterIndex(at: tappoint) else {
            return nil
        }
        let attributed = attr.attributes(at: index, longestEffectiveRange: nil, in: .init(location: index, length: 1))
        cache = {
            if let _ = attributed[.rzclicked] {
                return .init(attr: attr, size: target.bounds.size, point: point, range: .init(location: index, length: 1), dict: attributed)
            }
            if (attributed[.rztapAction] != nil || attributed[.link] != nil) && self.tapAction != nil {
                return .init(attr: attr, size: target.bounds.size, point: point, range: .init(location: index, length: 1), dict: attributed)
            }
            return .init(attr: attr, size: target.bounds.size, point: point, range: .init(location: index, length: 1), dict: nil)
        }()
        return cache
    }
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let v = super.hitTest(point, with: event), v != self {
            return v
        }
        if let _ = tap(point: point)?.dict {
            return self
        }
        return nil
    }
}
public extension RZColorfulView {
    var yoffset: CGFloat {
        if let t = self.target as? UITextView {
            return t.contentInset.top + t.textContainerInset.top
        }
        guard let textLayout = self.textLayout else { return 0 }
        let textContainer = self.bounds
        let usedRect = textLayout.usedRect()
        var yoffset = (textContainer.size.height - usedRect.size.height) / 2
        yoffset = max(0, yoffset)
        return yoffset
    }
}

extension CGPoint {
    /// 误差是否小于d
    func diff(point: CGPoint, min d: CGFloat) -> Bool {
        let dx = abs(self.x - point.x)
        let dy = abs(self.y - point.y)
        if dx > d || dy > d {
            return false
        }
        return true
    }
}
