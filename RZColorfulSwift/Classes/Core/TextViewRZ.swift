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
        if location == 0 {
            self.rz.attributedText = conferrerColorful
            return
        }
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

public extension RZColorfulSwiftBase where T: UITextView {
    
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
        guard let attr = attributedString, attr.length != 0 else {
            self.rz.attributedText = nil
            return
        }
        self.rz.attributedText = attr.rz.attributedStringBy(maxline: maxLine, maxWidth: maxWidth, isFold: isFold, showAllText: showAllText, showFoldText: showFoldText)
    }
    
    /// 设置富文本
    /// - Parameters:
    ///   - attributedString: 富文本
    ///   - maxLine: 最多行数
    ///   - maxWidth: 最大宽度
    ///   - lineBreakMode: 截取方式
    ///   - placeHolder: 超过后，截断的地方占位文本
    func set(attributedString: NSAttributedString?, maxLine: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) {
        guard let attr = attributedString, attr.length != 0 else {
            self.rz.attributedText = nil
            return
        }
        self.rz.attributedText = attr.rz.attributedStringBy(maxline: maxLine, maxWidth: maxWidth, lineBreakMode: lineBreakMode, placeHolder: placeHolder)
    }
    /// 给UITextView添加富文本点击事件，给NSAttributedString添加".rztapLabel"属性即可
    /// 注意：lineBreakMode只能为0或者1，否则内部TextKit计算属性文本位置可能出错
    func tapAction(_ tapAction:((_ sender: Any, _ tapActionId: String, _ range: NSRange) -> Void)?) {
        let v = self.rz.activeColorful()
        v?.tapAction = tapAction
    }
    func disableLink(_ disable: Bool = true) {
        self.rz.rzhelper.disablelink = true
    }
    func disableAttachment(_ disable: Bool = true) {
        self.rz.rzhelper.disableAttachment = true
    }
}
private nonisolated(unsafe) var rzTextViewHelperkey : UInt8 = 1
public extension UITextView {
    var rzhelper: RZTextViewHelper {
        set {
            objc_setAssociatedObject(self, &rzTextViewHelperkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let helper = objc_getAssociatedObject(self, &rzTextViewHelperkey) as? RZTextViewHelper {
                return helper
            }
            let helper = RZTextViewHelper.init()
            self.delegate = helper
            self.rzhelper = helper
            return helper
        }
    }
}
public class RZTextViewHelper: NSObject, UITextViewDelegate {
    public var disablelink = false
    public var disableAttachment = false

    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !disablelink
    }
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !disableAttachment
    }    
}

