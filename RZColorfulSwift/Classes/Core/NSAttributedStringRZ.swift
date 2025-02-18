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
    ///   - maxline: 最大显示的行数,   =0时，不追加折叠展开
    ///   - maxWidth: 最大显示宽度，  =0时，不追加折叠展开
    ///   - isFold: 当前是否折叠
    ///   - showAllText: 如 “...显示全文” fold = true时，将追加在字符串后
    ///   - showFoldText: 如 “收起全文” flod = FALSE，表示已全部展开，将追加在后边
    /// - Returns: 字符串
    func attributedStringBy(maxline: Int, maxWidth: CGFloat, isFold: Bool, showAllText: NSAttributedString?, showFoldText: NSAttributedString?) -> NSAttributedString? {
        guard self.rz.length > 0, maxline > 0, maxWidth > 0 else {
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
        return self.attributedStringBy(maxline: maxline, maxWidth: maxWidth, lineBreakMode: .byTruncatingTail, placeHolder: showAllText)
    }
    /// 对富文本进行截断处理
    /// - Parameters:
    ///   - maxline: 设置超过多少截断
    ///   - maxWidth: 显示的最大宽度
    ///   - lineBreakMode: 截断方式
    ///   - placeHolder: 截断时占位的"..."文字
    func attributedStringBy(maxline: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) -> NSAttributedString? {
        // 检查输入参数是否有效，如果无效则返回原始富文本
        guard self.rz.length > 0, maxline > 0, maxWidth > 0 else {
            return self.rz
        }
        // 如果文本行数未超过最大行数，则返回原始富文本
        if !self.moreThan(line: maxline, maxWidth: maxWidth) {
            return self.rz
        }
        let p = placeHolder ?? .init()
        // 初始化二分查找的左右边界
        var left = 0
        var right = self.rz.length
        var location = 0
        // 最终返回的富文本
        var resultAttr: NSMutableAttributedString?
        switch lineBreakMode {
        case .byWordWrapping, .byCharWrapping, .byClipping, .byTruncatingTail:
            while left <= right {
                location = (left + right) / 2
                let sub = self.rz.attributedSubstring(from: .init(location: 0, length: location))
                let temp = NSMutableAttributedString(attributedString: sub)
                // 如果是尾部截断模式，添加占位符
                if lineBreakMode == .byTruncatingTail {
                    temp.append(p)
                }
                if temp.rz.moreThan(line: maxline, maxWidth: maxWidth) {
                    right = location - 1
                } else {
                    left = location + 1
                    resultAttr = temp
                }
            }
        case .byTruncatingHead:
            while left <= right {
                location = (left + right) / 2
                let sub = self.rz.attributedSubstring(from: .init(location: location, length: self.rz.length - location))
                let temp = NSMutableAttributedString(attributedString: sub)
                // 在开头插入占位符
                temp.insert(p, at: 0)
                if temp.rz.moreThan(line: maxline, maxWidth: maxWidth) {
                    left = location + 1
                } else {
                    right = location - 1
                    resultAttr = temp
                }
            }
        case .byTruncatingMiddle:
            // 将富文本分为左右两部分，一左一右交替二分查找获取截断位置
            /// 当maxline = 1行时，效果不太理想（有好的方法可以反馈一下）
            /// 左边
            var (left_l, left_r) = (0, self.rz.length / 2)
            /// 右边
            var (right_l, right_r) = (self.rz.length / 2, self.rz.length)
            /// 左右mid
            var (left_mid, right_mid) = (0, right_l)
            
            /// 每次计算，双数时计算左侧，单数时计算右侧
            /// 优先截断左侧，当一侧截断位置后未超行，times不变，继续算这一侧，直到这一侧超行之后，在截取另一侧
            /// 即超行之后，才times+=1，
            /// 如times=双数，即左侧，当次未超行时times不变，下一次循环依然会截断左侧，直到超行时，才去截断右侧
            var times = 0
            while (left_l <= left_r || right_l <= right_r) {
                let temp = NSMutableAttributedString.init()
                // 交替计算左侧和右侧的中间位置
                if times % 2 == 0 { /// 算左侧
                    left_mid = (left_l + left_r) / 2
                } else {
                    right_mid = (right_l + right_r) / 2
                }
                let h = self.rz.attributedSubstring(from: .init(location: 0, length: left_mid))
                let e = self.rz.attributedSubstring(from: .init(location: right_mid, length: self.rz.length - right_mid))
                temp.append(h)
                temp.append(p)
                temp.append(e)
                if temp.rz.moreThan(line: maxline, maxWidth: maxWidth) {
                    if times % 2 == 0 { /// 算左侧
                        left_r = left_mid - 1
                    } else {
                        right_l = right_mid + 1
                    }
                    times += 1
                } else {
                    if times % 2 == 0 { /// 算左侧
                        left_l = left_mid + 1
                    } else {
                        right_r = right_mid - 1
                    }
                    /// 左侧已到临界点，则重置times仅算右侧，同理右侧临界点
                    if left_l > left_r {
                        times = 1
                    } else if right_l > right_r {
                        times = 0
                    }
                    resultAttr = temp
                }
            }
        @unknown default:
            return self.rz
        }
        return resultAttr
    }
    /// 头部截断（逆向）从最后一个字反向往前保留最后maxLine行数的文字
    /// - Parameters:
    ///   - maxline: 最大行数
    ///   - maxWidth: 最大宽度
    ///   - lineBreakMode: placeholder插入的方式
    ///   - placeHolder: 截断时占位的"..."文字
    ///   - 区别于方法（A）的byTruncatingHead：func attributedStringBy(maxline: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) -> NSAttributedString?
    ///   - 方法（A）抛弃前半部分，在最前边插入placeholder
    ///   - headxxx抛弃前半部分，然后根据mode再不同位置插入placeholder
    func headTruncatingAttributedStringBy(maxline: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) -> NSAttributedString? {
        guard self.rz.length > 0, maxline > 0, maxWidth > 0 else {
            return self.rz
        }
        if !self.moreThan(line: maxline, maxWidth: maxWidth) {
            return self.rz
        }
        let holder = placeHolder ?? .init()
        var (min, max) = (0, self.rz.length)
        var star: Int = 0
        var result: NSMutableAttributedString?
        while min <= max {
            star = (min + max) / 2
            let sub = self.rz.attributedSubstring(from: .init(location: star, length: self.rz.length - star))
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
            if tempAttr.rz.moreThan(line: maxline, maxWidth: maxWidth) {
                min = star + 1
            } else {
                max = star - 1
                result = tempAttr
            }
        }
        return result
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
