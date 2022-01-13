//
//  UITextField+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit
// MARK: - 对TextField的富文本支持
public extension RZColorfulSwiftBase where T: UITextField {
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
        let attr = NSMutableAttributedString.init(attributedString:originAttr)
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
        return self.selectedRange().location
    }
    func selectedRange() -> NSRange {
        let beginning = self.rz.beginningOfDocument
        let selectedRange = self.rz.selectedTextRange
        let selectionStart = selectedRange?.start ?? UITextPosition.init()
        let selectionEnd = selectedRange?.end ?? UITextPosition.init()
        let location = self.rz.offset(from: beginning, to: selectionStart)
        let length = self.rz.offset(from: selectionStart, to: selectionEnd)
        return NSRange.init(location: location, length: length)
    }
    func setSelectedRange(range: NSRange) {
        let beginning = self.rz.beginningOfDocument
        let startPosition = self.rz.position(from: beginning, offset: range.location) ?? UITextPosition.init()
        let endPosition = self.rz.position(from: beginning, offset: range.location + range.length) ?? UITextPosition.init()
        let selectionRange = self.rz.textRange(from: startPosition, to: endPosition)
        self.rz.selectedTextRange = selectionRange
    }
}
//MARK: 替换成textField.rz.colorful.....
public extension UITextField {
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
        return self.rz.getEndLocation()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.getCursorLocation() instead")
    func getCursorLocation() -> Int {
        return self.rz.getCursorLocation()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.selectedRange() instead")
    func rz_selectedRange() -> NSRange {
        return self.rz.selectedRange()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.setSelectedRange(range: range) instead")
    func rz_setSelectedRange(range: NSRange) -> Void {
        self.rz.setSelectedRange(range: range)
    }
}
