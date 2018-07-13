//
//  RZImageAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

class RZImageAttribute: NSObject {
    var image: UIImage?
    
    let imageAttchment = NSTextAttachment.init()
    private var attributeDict = NSMutableDictionary.init()
    
    func package(_ para: NSMutableParagraphStyle?) -> NSAttributedString? {
        if image == nil {
            return nil;
        }
        self.imageAttchment.image = image;
        let attr = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: imageAttchment))
        
        if _paragraphStyle != nil {
            attr.addAttributes([NSAttributedStringKey.paragraphStyle: _paragraphStyle!.paragraph], range: NSRange.init(location: 0, length: attr.string.count))
        } else if para != nil {
            attr.addAttributes([NSAttributedStringKey.paragraphStyle: para!], range: NSRange.init(location: 0, length: attr.string.count))
        }
        return attr
    }
    
    // 设置段落样式
    private var _paragraphStyle : RZImageParagraphStyle?
    var paragraphStyle : RZImageParagraphStyle? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZImageParagraphStyle.init()
                _paragraphStyle?.and = self
            }
            return _paragraphStyle
        }
    }
    
    /// 图片大小和位置，y轴为正，图片上移
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.imageAttchment.bounds = bounds
        return self
    }
}
