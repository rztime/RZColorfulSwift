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

public extension NSAttributedString.Key {
    /// 仅UILabel有效，添加label文本上文字点击事件的回调
    static let rztapLabel: NSAttributedString.Key = NSAttributedString.Key(rawValue: "RZTapActionByLabel")
}

public class TextAttributeRZ {
    // 书写方向
    public enum WriteDirectionRZ {
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
    
    private var _paragraphStyle : ParagraphStyleRZ<TextAttributeRZ>?
    private var _shadow : ShadowStyleRZ<TextAttributeRZ>?
    
    public init(_ text: String? = nil, attributedText:NSAttributedString? = nil) {
        self.text = text
        self.attributedText = attributedText
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
    /// 字体
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        attributeDict[.font] = font
        return self
    }
    /// 字体颜色
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        attributeDict[.foregroundColor] = color
        return self
    }
    /// 字体所在区域背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        attributeDict[.backgroundColor] = color
        return self
    }
    /// 设置连体字，value = 0,没有连体， =1，有连体
    @discardableResult
    func ligature(_ ligature: NSNumber?) -> Self {
        attributeDict[.ligature] = ligature
        return self
    }
    /// 字间距 >0 加宽  < 0减小间距
    @discardableResult
    func kern(_ kern: NSNumber?) -> Self {
        attributeDict[.kern] = kern
        return self
    }
    /**
     删除线
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func strikethroughStyle(_ style: NSUnderlineStyle?) -> Self {
        attributeDict[.strikethroughStyle] = style?.rawValue
        return self
    }
    /// 删除线颜色
    @discardableResult
    func strikethroughColor(_ color: UIColor?) -> Self {
        attributeDict[.strikethroughColor] = color
        return self
    }
    /**
     下划线样式  取值参照删除线，位置不同罢了
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func underlineStyle(_ style: NSUnderlineStyle?) -> Self {
        attributeDict[.underlineStyle] = style?.rawValue
        return self
    }
    /// 下划线颜色
    @discardableResult
    func underlineColor(_ color: UIColor?) -> Self {
        attributeDict[.underlineColor] = color
        return self
    }
    /// 描边的颜色
    @discardableResult
    func strokeColor(_ color: UIColor?) -> Self {
        attributeDict[.strokeColor] = color
        return self
    }
    /// 描边的笔画宽度 为3时，空心  负值填充效果，正值中空效果
    @discardableResult
    func strokeWidth(_ width: NSNumber?) -> Self {
        attributeDict[.strokeWidth] = width
        return self
    }
    
    /// 给文本添加链接，并且可点击跳转浏览器打开  仅UITextView点击有效
    @discardableResult
    func link(_ link: URL?) -> Self {
        attributeDict[.link] = link
        return self
    }
    /// 给文本添加点击事件的id
    @discardableResult
    func tapAction(_ actionId: String?) -> Self {
        attributeDict[.link] = actionId?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return self
    }
    /// 给文本添加点击事件的id, 仅UILabel有效，需要实现label.rz.tapAction方法
    @discardableResult
    func tapActionByLable(_ actionId: String?) -> Self {
        attributeDict[.rztapLabel] = actionId?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return self
    }
    /// 基准线偏移值
    @discardableResult
    func baselineOffset(_ offset: NSNumber?) -> Self {
        attributeDict[.baselineOffset] = offset
        return self
    }
    /// 倾斜
    @discardableResult
    func obliqueness(_ obliqueness: NSNumber?) -> Self {
        attributeDict[.obliqueness] = obliqueness
        return self
    }
    /// 扩张，即拉伸文字 >0 拉伸 <0压缩
    @discardableResult
    func expansion(_ expansion: NSNumber?) -> Self {
        attributeDict[.expansion] = expansion
        return self
    }

    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    func writingDirection(_ direction:TextAttributeRZ.WriteDirectionRZ) -> Self {
        attributeDict[.writingDirection] = [direction.rawValue()]
        return self
    }
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func verticalGlyphForm(_ form: NSNumber?) -> Self {
        attributeDict[.verticalGlyphForm] = form
        return self
    }
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func textEffect(_ effect: NSAttributedString.TextEffectStyle) -> Self {
        attributeDict[.textEffect] = effect
        return self
    }

    @discardableResult
    /// 添加自定义的key value
    func custom(key: NSAttributedString.Key, value: Any?) -> Self {
        attributeDict[key] = value
        return self
    }
}
@available(iOS 15.0, *)
public extension TextAttributeRZ {
    @discardableResult
    func inlinePresentationIntent(_ inlinePresentationIntent: InlinePresentationIntent?) -> Self {
        attributeDict[.inlinePresentationIntent] = inlinePresentationIntent
        return self
    }
    @discardableResult
    func alternateDescription(_ alternateDescription: Any?) -> Self {
        attributeDict[.alternateDescription] = alternateDescription
        return self
    }
    @discardableResult
    func imageURL(_ imageURL: Any?) -> Self {
        attributeDict[.imageURL] = imageURL
        return self
    }
    
    @discardableResult
    func languageIdentifier(_ languageIdentifier: Any?) -> Self {
        attributeDict[.languageIdentifier] = languageIdentifier
        return self
    }
    @discardableResult
    func replacementIndex(_ replacementIndex: Any?) -> Self {
        attributeDict[.replacementIndex] = replacementIndex
        return self
    }
    @discardableResult
    func morphology(_ morphology: Any?) -> Self {
        attributeDict[.morphology] = morphology
        return self
    }
    
    @discardableResult
    func inflectionRule(_ inflectionRule: Any?) -> Self {
        attributeDict[.inflectionRule] = inflectionRule
        return self
    }
    
    @discardableResult
    func inflectionAlternative(_ inflectionAlternative: Any?) -> Self {
        attributeDict[.inflectionAlternative] = inflectionAlternative
        return self
    }
    
    @discardableResult
    func presentationIntentAttributeName(_ presentationIntentAttributeName: Any?) -> Self {
        attributeDict[.presentationIntentAttributeName] = presentationIntentAttributeName
        return self
    }
}
public extension TextAttributeRZ {
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .strikethroughStyle(_ style: NSUnderlineStyle?) instead")
    func strikethroughStyle(_ style: NSNumber?) -> Self {
        attributeDict[.strikethroughStyle] = style
        return self
    }
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .underlineStyle(_ style: NSUnderlineStyle?) instead")
    func underlineStyle(_ underlineStyle: NSNumber?) -> Self {
        attributeDict[.underlineStyle] = underlineStyle
        return self
    }
    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .writingDirection(_ direction:TextAttributeRZ.WriteDirectionRZ) instead")
    func writingDirection(_ writingDirection: [NSNumber]?) -> Self {
        attributeDict[.writingDirection] = writingDirection
        return self
    }
}
