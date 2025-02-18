//
//  AttributeKeyRZ.swift
//  RZColorfulSwift
//
//  Created by rztime on 2025/2/12.
//

import UIKit
import Foundation
public extension NSAttributedString.Key {
    /// 仅UILabel有效，添加label文本上文字点击事件的回调
    static let rztapLabel: NSAttributedString.Key = NSAttributedString.Key(rawValue: "RZTapActionByLabel")
}
/// 富文本属性，附件和文本，都可以设置相关的属性，TextAttributeRZ、ImageAttributeRZ继承于此
public class AttributeKeyRZ {
    /// 用于记录属性
    public var attributeDict: [NSAttributedString.Key : Any] = [:]
}
// MARK: - 具体实现
public extension AttributeKeyRZ {
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
    /// 给文本添加链接，并且可点击跳转浏览器打开  仅UITextView点击有效
    @discardableResult
    func url(_ link: URL?) -> Self {
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
    @discardableResult
    func writingDirection(_ direction: WriteDirectionRZ?) -> Self {
        if let d = direction {
            attributeDict[.writingDirection] = [d.rawValue()]
        } else {
            attributeDict[.writingDirection] = nil
        }
        return self
    }
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func verticalGlyphForm(_ form: NSNumber?) -> Self {
        attributeDict[.verticalGlyphForm] = form
        return self
    }
    @discardableResult
    func textEffect(_ effect: NSAttributedString.TextEffectStyle?) -> Self {
        attributeDict[.textEffect] = effect
        return self
    }
    /// 添加自定义的key value
    @discardableResult
    func custom(key: NSAttributedString.Key, value: Any?) -> Self {
        attributeDict[key] = value
        return self
    }
}
@available(iOS 14.0, *)
public extension AttributeKeyRZ {
    /// 和kern类似，设置字间距
    @discardableResult
    func tracking(_ tracking: NSNumber?) -> Self {
        attributeDict[.tracking] = tracking
        return self
    }
}
@available(iOS 15.0, *)
public extension AttributeKeyRZ {
    /// 指定文本的展示意图
    @discardableResult
    func inlinePresentationIntent(_ inlinePresentationIntent: InlinePresentationIntent?) -> Self {
        if let v = inlinePresentationIntent?.rawValue {
            attributeDict[.inlinePresentationIntent] = NSNumber(value: v)
        } else {
            attributeDict[.inlinePresentationIntent] = nil
        }
        return self
    }
    /// 替代描述alter
    @discardableResult
    func alternateDescription(_ desc: String?) -> Self {
        attributeDict[.alternateDescription] = desc
        return self
    }
    /// 与文本关联的图片的 URL
    @discardableResult
    func imageURL(_ imageURL: URL?) -> Self {
        attributeDict[.imageURL] = imageURL
        return self
    }
    /// 标识文本的语言 如 zh-Hans
    @discardableResult
    func languageIdentifier(_ languageIdentifier: String?) -> Self {
        attributeDict[.languageIdentifier] = languageIdentifier
        return self
    }
    /// 文本替换的索引
    @discardableResult
    func replacementIndex(_ replacementIndex: Int?) -> Self {
        attributeDict[.replacementIndex] = replacementIndex
        return self
    }
    /// 语法形态
    @discardableResult
    func morphology(_ morphology: Morphology?) -> Self {
        attributeDict[.morphology] = morphology
        return self
    }
    /// 变形规则，可搭配morphology使用
    @discardableResult
    func inflectionRule(_ inflectionRule: InflectionRule?) -> Self {
        attributeDict[.inflectionRule] = inflectionRule
        return self
    }
    /// 指定替代的变体形式
    @discardableResult
    func inflectionAlternative(_ inflectionAlternative: String?) -> Self {
        attributeDict[.inflectionAlternative] = inflectionAlternative
        return self
    }
    /// 标记文本的语义意图
    @discardableResult
    func presentationIntentAttributeName(_ presentationIntentAttributeName: PresentationIntent?) -> Self {
        attributeDict[.presentationIntentAttributeName] = presentationIntentAttributeName
        return self
    }
}

@available(iOS 16.0, *)
public extension AttributeKeyRZ {
    // markdown位置相关
    @discardableResult
    func markdownSourcePosition(_ markdownSourcePosition: Any?) -> Self {
        attributeDict[.markdownSourcePosition] = markdownSourcePosition
        return self
    }
}

@available(iOS 17.0, *)
public extension AttributeKeyRZ {
    @discardableResult
    func agreeWithArgument(_ agreeWithArgument: Any?) -> Self {
        attributeDict[.agreeWithArgument] = agreeWithArgument
        return self
    }
    @discardableResult
    func agreeWithConcept(_ agreeWithConcept: Any?) -> Self {
        attributeDict[.agreeWithConcept] = agreeWithConcept
        return self
    }
    @discardableResult
    func referentConcept(_ referentConcept: Any?) -> Self {
        attributeDict[.referentConcept] = referentConcept
        return self
    }
}

@available(iOS 18.0, *)
public extension AttributeKeyRZ {
    @discardableResult
    func localizedNumberFormat(_ format: Any?) -> Self {
        attributeDict[.localizedNumberFormat] = format
        return self
    }
}

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
