//
//  RZTextAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public protocol RZAttributePackage {
    func package(_ para: NSMutableParagraphStyle?, _ sha: NSShadow?) -> NSAttributedString?
}

public class RZTextAttribute {
    // 书写方向
    public enum RZWriteDirection {
        case LRE
        case LRO
        case RLE
        case RLO
        
        func rawValue() -> Int {
            var e: Int = 0
            var o: Int = 0
            if #available(iOS 9.0, *) {
                e = NSWritingDirectionFormatType.embedding.rawValue
                o = NSWritingDirectionFormatType.override.rawValue
            } else {
                e = NSTextWritingDirection.embedding.rawValue
                o = NSTextWritingDirection.override.rawValue
            }
            var value: Int?
            switch self {
            case .LRE:
                value = NSWritingDirection.leftToRight.rawValue | e
            case .LRO:
                value = NSWritingDirection.leftToRight.rawValue | o
            case .RLE:
                value = NSWritingDirection.rightToLeft.rawValue | e
            case .RLO:
                value = NSWritingDirection.rightToLeft.rawValue | o
            }
            return value ?? 0
        }
    }
    private var text : String?
    private var attributedText: NSAttributedString?
    private var attributeDict: [NSAttributedString.Key : Any] = [:]
    
    private var _paragraphStyle : RZParagraphStyle<RZTextAttribute>?
    private var _shadow : RZShadowStyle<RZTextAttribute>?
    
    public init(_ text: String? = nil, attributedText:NSAttributedString? = nil) {
        self.text = text
        self.attributedText = attributedText
    } 
}
extension RZTextAttribute: RZAttributePackage {
    public func package(_ para: NSMutableParagraphStyle?, _ sha: NSShadow?) -> NSAttributedString? {
        var attr: NSMutableAttributedString?
        if let text = self.text {
            attr = .init(string: text)
        }
        if let a = attributedText {
            attr = .init(attributedString: a)
        }
        if let p = (_paragraphStyle?.paragraph ?? para)?.copy() {
            attributeDict[.paragraphStyle] = p
        }
        if let sha = (_shadow?.shadow ?? sha)?.copy() {
            attributeDict[.shadow] = sha
        }
        attr?.addAttributes(attributeDict, range: .init(location: 0, length: attr?.length ?? 0))
        attributeDict.removeAll()
        return attr
    }
    public func package(_ attr: NSMutableAttributedString?) {
        if let p = (_paragraphStyle?.paragraph)?.copy() {
            attributeDict[.paragraphStyle] = p
        }
        if let sha = (_shadow?.shadow)?.copy() {
            attributeDict[.shadow] = sha
        }
        attr?.addAttributes(attributeDict, range: .init(location: 0, length: attr?.length ?? 0))
        attributeDict.removeAll()
    }
}
// MARK 可使用的方法
public extension RZTextAttribute { 
    /// 段落
    var paragraphStyle: RZParagraphStyle<RZTextAttribute>? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZParagraphStyle.init(self)
            }
            return _paragraphStyle
        }
    }
    /// 阴影
    var shadow: RZShadowStyle<RZTextAttribute>? {
        get {
            if _shadow == nil {
                _shadow = RZShadowStyle.init(self)
            }
            return _shadow
        }
    }
    /// 字体
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        attributeDict[.font] = font
        return self
    }
    /// 字体颜色
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        attributeDict[.foregroundColor] = color
        return self
    }
    /// 字体所在区域背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        attributeDict[.backgroundColor] = color
        return self
    }
    /// 设置连体字，value = 0,没有连体， =1，有连体
    @discardableResult
    func ligature(_ ligature: NSNumber) -> Self {
        attributeDict[.ligature] = ligature
        return self
    }
    /// 字间距 >0 加宽  < 0减小间距
    @discardableResult
    func kern(_ kern: NSNumber) -> Self {
        attributeDict[.kern] = kern
        return self
    }
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .strikethroughStyle(_ strikethroughStyle: NSNumber) instead")
    func strikethroughStyle(_ strikethroughStyle: NSNumber) -> Self {
        attributeDict[.strikethroughStyle] = strikethroughStyle
        return self
    }
    /**
     删除线
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func strikethroughStyle(_ strikethroughStyle: NSUnderlineStyle) -> Self {
        attributeDict[.strikethroughStyle] = strikethroughStyle.rawValue
        return self
    }
    /// 删除线颜色
    @discardableResult
    func strikethroughColor(_ strikethroughColor: UIColor) -> Self {
        attributeDict[.strikethroughColor] = strikethroughColor
        return self
    }
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .underlineStyle(_ underlineStyle: NSUnderlineStyle) instead")
    func underlineStyle(_ underlineStyle: NSNumber) -> Self {
        attributeDict[.underlineStyle] = underlineStyle
        return self
    }
    /**
     下划线样式  取值参照删除线，位置不同罢了
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> Self {
        attributeDict[.underlineStyle] = underlineStyle.rawValue
        return self
    }
    /// 下划线颜色
    @discardableResult
    func underlineColor(_ underlineColor: UIColor) -> Self {
        attributeDict[.underlineColor] = underlineColor
        return self
    }
    /// 描边的颜色
    @discardableResult
    func strokeColor(_ strokeColor: UIColor) -> Self {
        attributeDict[.strokeColor] = strokeColor
        return self
    }
    /// 描边的笔画宽度 为3时，空心  负值填充效果，正值中空效果
    @discardableResult
    func strokeWidth(_ strokeWidth: NSNumber) -> Self {
        attributeDict[.strokeWidth] = strokeWidth
        return self
    }
    
    /// 给文本添加链接，并且可点击跳转浏览器打开  仅UITextView点击有效
    @discardableResult
    func link(_ link: NSURL) -> Self {
        attributeDict[.link] = link
        return self
    }
    /// 给文本添加点击事件的id
    @discardableResult
    func tapAction(_ action: String) -> Self {
        attributeDict[.link] = NSURL.init(string: action)
        return self
    }
    /// 基准线偏移值
    @discardableResult
    func baselineOffset(_ baselineOffset: NSNumber) -> Self {
        attributeDict[.baselineOffset] = baselineOffset
        return self
    }
    /// 倾斜
    @discardableResult
    func obliqueness(_ obliqueness: NSNumber) -> Self {
        attributeDict[.obliqueness] = obliqueness
        return self
    }
    /// 扩张，即拉伸文字 >0 拉伸 <0压缩
    @discardableResult
    func expansion(_ expansion: NSNumber) -> Self {
        attributeDict[.expansion] = expansion
        return self
    }
    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .writingDirection(_ writingDirection:RZWriteDirection) instead")
    func writingDirection(_ writingDirection: [NSNumber]) -> Self {
        attributeDict[.writingDirection] = writingDirection
        return self
    }
    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    func writingDirection(_ writingDirection:RZTextAttribute.RZWriteDirection) -> Self {
        attributeDict[.writingDirection] = [writingDirection.rawValue()]
        return self
    }
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func verticalGlyphForm(_ verticalGlyphForm: NSNumber) -> Self {
        attributeDict[.verticalGlyphForm] = verticalGlyphForm
        return self
    }
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func textEffect(_ textEffect: NSAttributedString.TextEffectStyle) -> Self {
        attributeDict[.textEffect] = textEffect
        return self
    }
}
