//
//  UITextView+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 对TextView的富文本的支持
public extension RZColorfulSwiftBase where T: UITextView {
    /// 设置富文本 （原内容将被清空）
    func colorfulConfer(confer: ColorfulBlockRZ?) {
        self.rz.attributedText = nil
        self.colorfulConferInsetToLocation(0, confer)
    }
    
    /// 在指定位置插入富文本
    func colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append: ColorfulBlockRZ?) {
        var location = 0
        switch position {
        case .Default, .Cursor:
            location = self.getCursorLocation()
        case .Header:
            location = 0
        case .End:
            location = self.getEndLocation()
        }
        self.colorfulConferInsetToLocation(location, append)
    }
    
    /// 在指定位置处加入富文本
    func colorfulConferInsetToLocation(_ location: Int, _ confer: ColorfulBlockRZ?) {
        guard let confer = confer else { return }
        guard let conferrerColorful = NSAttributedString.rz.colorfulConfer(confer: confer), conferrerColorful.length > 0 else { return }
        let originAttr = self.rz.attributedText ?? NSAttributedString.init()
        let attr = NSMutableAttributedString.init(attributedString: originAttr)
        var loc = max(location, 0)
        loc = min(location, attr.length)
        attr.insert(conferrerColorful, at: loc)
        self.rz.attributedText = attr
    }
    // 尾部的位置
    func getEndLocation() -> Int {
        return self.rz.attributedText?.length ?? 0
    }
    // 光标的位置
    func getCursorLocation() -> Int {
        return self.rz.selectedRange.location
    }
    
    // 给UItextView添加点击属性时，点击的事件的回调，
    // 默认 return false  （true时，将打开浏览器）
    func didTapTextView(rzdidTapTextView: @escaping RZDidTapTextView) {
        self.rz.didTapTextView = rzdidTapTextView
    }
    /// 获取range文本所在的位置
    func rectFor(range: NSRange?) -> CGRect? {
        guard let range = range else {
            return nil
        }
        let textView = self.rz
        let beginning = textView.beginningOfDocument
        guard let star = textView.position(from: beginning, offset: range.location),
              let end = textView.position(from: star, offset: range.length),
              let textRange = textView.textRange(from: star, to: end) else { return .zero }
        return textView.firstRect(for: textRange)
    }
    /// 获取range对应的frames
    func rectsFor(range: NSRange?) -> [CGRect] {
        guard let range = range else {
            return []
        }
        let textView = self.rz
        let beginning = textView.beginningOfDocument
        guard let star = textView.position(from: beginning, offset: range.location),
              let end = textView.position(from: star, offset: range.length),
              let textRange = textView.textRange(from: star, to: end) else { return [] }
        let res = textView.selectionRects(for: textRange)
        return res.map { $0.rect }
    }
}
// MARK: - 对TextView的富文本的支持
public extension UITextView {
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConfer(confer: confer) instead")
    func rz_colorfulConfer(confer: ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConfer(confer: confer)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConferInsetTo(position: position, append) instead")
    func rz_colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append: ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConferInsetTo(position: position, append)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConferInsetToLocation(location, confer) instead")
    func rz_colorfulConferInsetToLocation(_ location: Int, _ confer: ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConferInsetToLocation(location, confer)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.getEndLocation() instead")
    func getEndLocation() -> Int {
        self.rz.getEndLocation()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.getCursorLocation() instead")
    func getCursorLocation() -> Int {
        return self.rz.getCursorLocation()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.didTapTextView(rzdidTapTextView: rzdidTapTextView) instead")
    func rzDidTapTextView(rzdidTapTextView: @escaping RZDidTapTextView) {
        self.rz.didTapTextView(rzdidTapTextView: rzdidTapTextView)
    }
}

// 添加的辅助属性，非主动使用方法
internal extension UITextView {
    private struct RZPropertyKey {
        static let rzHelperKey = UnsafeRawPointer.init(bitPattern: "rzHelperKey".hashValue)
        static let rzDidTapTextViewKey = UnsafeRawPointer.init(bitPattern: "rzDidTapTextViewKey".hashValue)
    }
    private var rzHelper: TapActionHelperRZ? {
        set {
            objc_setAssociatedObject(self, UITextView.RZPropertyKey.rzHelperKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let rzh = objc_getAssociatedObject(self, UITextView.RZPropertyKey.rzHelperKey!) as? TapActionHelperRZ {
                return rzh
            }
            return nil
        }
    }
    // 点击事件
    var didTapTextView : RZDidTapTextView? {
        set {
            objc_setAssociatedObject(self, UITextView.RZPropertyKey.rzDidTapTextViewKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.rzHelper = TapActionHelperRZ.init(self)
        }
        get {
            if let rzdtv = objc_getAssociatedObject(self, UITextView.RZPropertyKey.rzDidTapTextViewKey!) as? RZDidTapTextView {
                return rzdtv
            }
            return nil
        }
    }
}
