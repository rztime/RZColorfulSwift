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
public extension NSAttributedString {
    /// 富文本 归纳
    static func rz_colorfulConfer(confer: ColorfulBlock) -> NSAttributedString? {
        let connferrer = RZColorfulConferrer.init()
        confer(connferrer)
        return connferrer.confer()
    }
    /// 追加
    func attributedStringByAppend(attributedString: NSAttributedString) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(attributedString: self)
        attr.append(attributedString)
        return NSAttributedString.init(attributedString: attr)
    }
    /// 给富文本添加属性
    func rz_colorfulAttr(attr: ColorfulAttrBlock) -> NSAttributedString? {
        let attrx = RZTextAttribute.init(attributedText: self)
        attr(attrx)
        return attrx.package(nil, nil)
    }
}
// MARK: - NSMutableAttributedString 直接添加富文本的属性
public extension NSMutableAttributedString {
    /// 给富文本添加属性
    func rz_colorfulAttrAppend(attr: ColorfulAttrBlock) {
        let attrx = RZTextAttribute.init(attributedText: self)
        attr(attrx)
        attrx.package(self)
    }
}

// MARK: - NSAttributedString 富文本与html之间的互换关联
public extension NSAttributedString {
    func rz_images() -> [UIImage] {
        var arrays: [UIImage] = []
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, self.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range, stop) -> Void  in
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
}
 
// MARK: - NSAttributedString 富文本的计算
public extension NSAttributedString {
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
        let rect = self.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        return rect.size
    }
}
