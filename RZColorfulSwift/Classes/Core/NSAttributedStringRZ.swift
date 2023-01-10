//
//  NSAttributedString+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NSAttributedString 设置富文本的属性
public extension RZColorfulSwiftBase where T: NSAttributedString {
    /// 富文本 归纳
    static func colorfulConfer(confer: ColorfulBlockRZ) -> NSAttributedString? {
        let connferrer = ColorfulConferrerRZ.init()
        confer(connferrer)
        return connferrer.confer()
    }
    /// 追加
    func attributedStringByAppend(attributedString: NSAttributedString) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(attributedString: self.rz)
        attr.append(attributedString)
        return NSAttributedString.init(attributedString: attr)
    }
    /// 给富文本添加属性
    func colorfulAttr(attr: ColorfulAttrBlockRZ) -> NSAttributedString? {
        let attrx = TextAttributeRZ.init(attributedText: self.rz)
        attr(attrx)
        return attrx.package(nil, nil)
    }
    /// 获取NSAttributeString的图片
    func images() -> [UIImage] {
        var arrays: [UIImage] = []
        self.rz.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, self.rz.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range, stop) -> Void  in
            if let attach = value as? NSTextAttachment {
                if let image = attach.image {
                    arrays.append(image)
                } else if let data = attach.fileWrapper?.regularFileContents, let image = UIImage.init(data: data) {
                    arrays.append(image)
                }
            }
        }
        return arrays
    }
    
    /**
     固定宽度，计算高
     @param width 固定宽度
     */
    func sizeWithConditionWidth(width: Float) -> CGSize {
        var size = self.sizeWithCondition(size: CGSize.init(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude))
        size.width = CGFloat(width)
        return size
    }
    /**
     固定高度，计算宽
     @param height 固定高度
     */
    func sizeWithConditionHeight(height: Float) -> CGSize {
        var size = self.sizeWithCondition(size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat(height)))
        size.height = CGFloat(height)
        return size
    }
    /**
     计算富文本的size
     如需计算高度 size = CGSizeMake(300, CGFLOAT_MAX)
     如需计算宽度 size = CGSizeMake(CGFLOAT_MAX, 18)
     
     @param size 约定的size，以宽高做条件，定宽时，计算得到高度（此时忽略宽度）
     定高时，计算得到宽度 （此时忽略高度）
     @return <#return value description#>
     */
    func sizeWithCondition(size: CGSize) -> CGSize {
        let rect = self.rz.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        return rect.size
    }
}
public extension RZColorfulSwiftBase where T: NSAttributedString {
    /// 给text 标记属性（如对关键字进行标红显示）
    func markText(_ text: String?, attribute: [NSAttributedString.Key: Any]) -> NSAttributedString {
        guard let keyword = text, !keyword.isEmpty else { return self.rz }
        let attr = NSMutableAttributedString.init(attributedString: self.rz)
        let text = self.rz.string as NSString
        var range = NSRange.init(location: 0, length: text.length)
        while range.length > 0 {
            let r = text.range(of: keyword, range: range)
            if r.location != NSNotFound {
                attr.addAttributes(attribute, range: r)
                range = .init(location: r.upperBound, length: range.upperBound - r.upperBound)
            } else {
                break
            }
        }
        return attr
    }
    /// 将self的属性设置到text上
    func copyAttributeToText(_ text: String) -> NSAttributedString {
        let dict = self.rz.attributes(at: 0, effectiveRange: nil)
        return NSAttributedString.init(string: text, attributes: dict)
    }
}
public extension RZColorfulSwiftBase where T: NSAttributedString {
    // 判断attributedString的内容，在label显示的话，是否超过line行数
    func moreThan(line: Int, maxWidth: CGFloat) -> Bool {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = self.rz
        let tempSize = CGSize.init(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let allHeight = label.textRect(forBounds: .init(origin: .zero, size: tempSize), limitedToNumberOfLines: 0).height
        let lineHeight = label.textRect(forBounds: .init(origin: .zero, size: tempSize), limitedToNumberOfLines: line).height
        return ceil(allHeight) > ceil(lineHeight)
    }
    /// 通过限制宽度，行数，获取内容，
    /// 如果未超过 line 行数，返回原字符串
    /// 超过行数，折叠时，将追加showAllText(如显示全文)， 全部展开时，显示showFoldText(如收起)
    /// - Parameters:
    ///   - maxline: 最大显示的行数,
    ///   - maxWidth: 最大显示宽度
    ///   - isFold: 当前是否折叠
    ///   - showAllText: 如 “...显示全文” fold = true时，将追加在字符串后
    ///   - showFoldText: 如 “收起全文” flod = FALSE，表示已全部展开，将追加在后边
    /// - Returns: 字符串
    func attributedStringBy(maxline: Int, maxWidth: CGFloat, isFold: Bool, showAllText: NSAttributedString?, showFoldText: NSAttributedString?) -> NSAttributedString? {
        if self.rz.length == 0 || maxline == 0 {
            return self.rz
        }
        if !self.moreThan(line: maxline, maxWidth: maxWidth) {
            return self.rz
        }
        if !isFold {
            let attr = NSMutableAttributedString.init(attributedString: self.rz)
            if let showFoldText = showFoldText {
                attr.append(showFoldText)
            }
            return attr 
        }
        let showAll = showAllText ?? .init()
        var (min, max) = (0, self.rz.length)
        var end: Int = 0
        while true {
            end = (min + max) / 2
            let sub = self.rz.attributedSubstring(from: .init(location: 0, length: end))
            let tempAttr = NSMutableAttributedString.init(attributedString: sub)
            tempAttr.append(showAll)
            let more = tempAttr.rz.moreThan(line: maxline, maxWidth: maxWidth)
            if more {
                max = end
            } else {
                min = end
            }
            let tempEnd = (min + max) / 2
            if tempEnd == end {
                return tempAttr
            }
        }
    }
    
    /// 对富文本进行截断处理
    /// - Parameters:
    ///   - maxline: 设置超过多少截断
    ///   - maxWidth: 显示的最大宽度
    ///   - lineBreakMode: 截断方式
    ///   - placeHolder: 截断时占位的"..."文字
    func attributedStringBy(maxline: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) -> NSAttributedString? {
        if self.rz.length == 0 || maxline == 0 {
            return self.rz
        }
        if !self.moreThan(line: maxline, maxWidth: maxWidth) {
            return self.rz
        }
  
        let holder = placeHolder ?? .init()
        var (min, max) = (0, self.rz.length)
        var end: Int = 0
        while true {
            end = (min + max) / 2
            let sub = self.rz.attributedSubstring(from: .init(location: 0, length: end))
            let tempAttr = NSMutableAttributedString.init(attributedString: sub)
            switch lineBreakMode {
            case .byWordWrapping, .byCharWrapping, .byClipping:
                break
            case .byTruncatingHead:
                tempAttr.insert(holder, at: 0)
            case .byTruncatingTail:
                tempAttr.append(holder)
            case .byTruncatingMiddle:
                tempAttr.insert(holder, at: Int(tempAttr.length / 2))
            @unknown default:
                break
            }
            let more = tempAttr.rz.moreThan(line: maxline, maxWidth: maxWidth)
            if more {
                max = end
            } else {
                min = end
            }
            let tempEnd = (min + max) / 2
            if tempEnd == end {
                return tempAttr
            }
        }
    }
}

public extension NSAttributedString {
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConfer(confer: ColorfulBlockRZ) instead")
    static func rz_colorfulConfer(confer: ColorfulBlockRZ) -> NSAttributedString? {
        return self.rz.colorfulConfer(confer: confer)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.attributedStringByAppend(attributedString: NSAttributedString) instead")
    func attributedStringByAppend(attributedString: NSAttributedString) -> NSAttributedString {
        return self.rz.attributedStringByAppend(attributedString: attributedString)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulAttr(attr: ColorfulAttrBlockRZ) instead")
    func rz_colorfulAttr(attr: ColorfulAttrBlockRZ) -> NSAttributedString? {
        return self.rz.colorfulAttr(attr: attr)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.images() instead")
    func rz_images() -> [UIImage] {
        return self.rz.images()
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.sizeWithConditionWidth(width: width) instead")
    func sizeWithConditionWidth(width: Float) -> CGSize {
        return self.rz.sizeWithConditionWidth(width: width)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.sizeWithConditionHeight(height: height) instead")
    func sizeWithConditionHeight(height: Float) -> CGSize {
        return self.rz.sizeWithConditionHeight(height: height)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.sizeWithCondition(size: size) instead")
    func sizeWithCondition(size: CGSize) -> CGSize {
        return self.rz.sizeWithCondition(size: size)
    }
}
// MARK: - NSMutableAttributedString 直接添加富文本的属性
public extension RZColorfulSwiftBase where T: NSMutableAttributedString {
    /// 给富文本添加属性
    func colorfulAttrAppend(attr: ColorfulAttrBlockRZ) {
        let attrx = TextAttributeRZ.init(attributedText: self.rz)
        attr(attrx)
        attrx.package(self.rz)
    }
}
public extension NSMutableAttributedString {
    /// 给富文本添加属性
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulAttrAppend(attr: ColorfulAttrBlockRZ) instead")
    func rz_colorfulAttrAppend(attr: ColorfulAttrBlockRZ) {
        self.rz.colorfulAttrAppend(attr: attr)
    }
}
