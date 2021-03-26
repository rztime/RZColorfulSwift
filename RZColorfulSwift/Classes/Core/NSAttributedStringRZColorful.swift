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
