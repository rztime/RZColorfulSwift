//
//  TextAttributeRZ.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public protocol AttributePackageRZ {
    func package(_ para: NSMutableParagraphStyle?, _ sha: NSShadow?) -> NSAttributedString?
}
/// 可设置的富文本方法请查看AttributeKeyRZ
public class TextAttributeRZ: AttributeKeyRZ {
    private var text : String?
    private var attributedText: NSAttributedString?
    private var _paragraphStyle : ParagraphStyleRZ<TextAttributeRZ>?
    private var _shadow : ShadowStyleRZ<TextAttributeRZ>?
    
    public init(_ text: String? = nil, attributedText:NSAttributedString? = nil) {
        self.text = text
        self.attributedText = attributedText
    }
}
// MARK 可使用的方法
public extension TextAttributeRZ {
    /// 段落
    var paragraphStyle: ParagraphStyleRZ<TextAttributeRZ>? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = ParagraphStyleRZ.init(self)
            }
            return _paragraphStyle
        }
    }
    /// 阴影
    var shadow: ShadowStyleRZ<TextAttributeRZ>? {
        get {
            if _shadow == nil {
                _shadow = ShadowStyleRZ.init(self)
            }
            return _shadow
        }
    }
}
extension TextAttributeRZ: AttributePackageRZ {
    public func package(_ para: NSMutableParagraphStyle?, _ sha: NSShadow?) -> NSAttributedString? {
        var attr: NSMutableAttributedString?
        if let text = self.text {
            attr = .init(string: text)
        }
        if let a = attributedText {
            attr = .init(attributedString: a)
        }
        if let p = (_paragraphStyle?.paragraph ?? para) {
            if let p = p as? RZMutableParagraphStyle {
                attributeDict[.paragraphStyle] = RZMutableParagraphStyle.copyWith(p)
            } else {
                attributeDict[.paragraphStyle] = p
            }
        }
        if let sha = (_shadow?.shadow ?? sha)?.copy() {
            attributeDict[.shadow] = sha
        }
        attr?.addAttributes(attributeDict, range: .init(location: 0, length: attr?.length ?? 0))
        attributeDict.removeAll()
        return attr
    }
    public func package(_ attr: NSMutableAttributedString?) {
        if let p = (_paragraphStyle?.paragraph) {
            attributeDict[.paragraphStyle] = RZMutableParagraphStyle.copyWith(p)
        }
        if let sha = (_shadow?.shadow)?.copy() {
            attributeDict[.shadow] = sha
        }
        attr?.addAttributes(attributeDict, range: .init(location: 0, length: attr?.length ?? 0))
        attributeDict.removeAll()
    }
}
