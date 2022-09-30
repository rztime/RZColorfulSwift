//
//  ParagraphStyleRZ.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/11.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class ParagraphStyleRZ<T: AnyObject> {
    public var paragraph = NSMutableParagraphStyle.init()
    
    public init(_ target: T?) {
        and = target
    }
    /// 连接词
    public weak var and: T?
    /// 段落行距
    @discardableResult
    public func lineSpacing(_ space: CGFloat) -> Self {
        paragraph.lineSpacing = space
        return self
    }
    
    /// 段与段之间的间距
    @discardableResult
    public func paragraphSpacingBefore(_ space: CGFloat) -> Self {
        paragraph.paragraphSpacingBefore = space
        return self
    }
    
    /// 段落后面的间距
    @discardableResult
    public func paragraphSpacing(_ space: CGFloat) -> Self {
        paragraph.paragraphSpacing = space
        return self
    }
    
    /// 文本对齐方式
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        paragraph.alignment = alignment
        return self
    }
    
    /// 首行文本缩进
    @discardableResult
    public func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        paragraph.firstLineHeadIndent = indent
        return self
    }
    
    /// 非首行文本缩进
    @discardableResult
    public func headIndent(_ indent: CGFloat) -> Self {
        paragraph.headIndent = indent
        return self
    }
    
    /// 文本缩进
    @discardableResult
    public func tailIndent(_ indent: CGFloat) -> Self {
        paragraph.tailIndent = indent
        return self
    }
    
    /// 文本折行方式
    @discardableResult
    public func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        paragraph.lineBreakMode = mode
        return self
    }
    
    /// 文本最小行距
    @discardableResult
    public func minimumLineHeight(_ height: CGFloat) -> Self {
        paragraph.minimumLineHeight = height
        return self
    }
    
    /// 文本最大行距
    @discardableResult
    public func maximumLineHeight(_ height: CGFloat) -> Self {
        paragraph.maximumLineHeight = height
        return self
    }
    
    /// 文本写入方式，即显示方式，从左至右，或从右到左
    @discardableResult
    public func baseWritingDirection(_ direction: NSWritingDirection) -> Self {
        paragraph.baseWritingDirection = direction
        return self
    }
    
    /// 设置文本行间距是默认间距的倍数
    @discardableResult
    public func lineHeightMultiple(_ multiple: CGFloat) -> Self {
        paragraph.lineHeightMultiple = multiple
        return self
    }
    
    /// 设置每行的最后单词是否截断，在0.0-1.0之间，默认为0.0，越接近1.0单词被截断的可能性越大，
    @discardableResult
    public func hyphenationFactor(_ factor: Float) -> Self {
        paragraph.hyphenationFactor = factor
        return self
    }
    /// 设置textLsit，主要是列表功能
    @discardableResult
    public func textLists(_ list: [NSTextList]) -> Self {
        paragraph.textLists = list
        return self
    }
    /// 未知
    @discardableResult
    public func defaultTabInterval(_ interval: CGFloat) -> Self {
        paragraph.defaultTabInterval = interval
        return self
    }
    
    /// 未知
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ allow: Bool) -> Self {
        if #available(iOS 9.0, *) {
            paragraph.allowsDefaultTighteningForTruncation = allow
        }
        return self
    }
    /// 未知
    @discardableResult
    public func usesDefaultHyphenation(_ hyp: Bool) -> Self {
        if #available(iOS 15.0, *) {
            paragraph.usesDefaultHyphenation = hyp
        }
        return self
    }
}
