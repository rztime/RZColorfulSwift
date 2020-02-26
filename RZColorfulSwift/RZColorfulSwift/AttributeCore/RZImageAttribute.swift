//
//  RZImageAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public enum RZImageAttachmentHorizontalAlign {
    case bottom
    case center
    case top
}

public class RZImageAttribute: NSObject{
    var image: UIImage?  // 图片
    
    let imageAttchment = NSTextAttachment.init()
    var attributeDict = NSMutableDictionary.init()  // 一些其他属性
    
    var _url:NSURL?   // 添加url
    
    var _paragraphStyle : RZImageParagraphStyle?  // 样式
    var _shadow : RZImageShadowStyle?            // 阴影
    
    func package(_ para: NSMutableParagraphStyle?, sha: NSShadow?) -> NSAttributedString? {
        if image == nil {
            return nil;
        }
        self.imageAttchment.image = image;
        let attr = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: imageAttchment))
        
        if _paragraphStyle != nil {
            attr.addAttributes([NSAttributedString.Key.paragraphStyle: _paragraphStyle!.paragraph], range: NSRange.init(location: 0, length: attr.string.count))
        } else if para != nil {
            attr.addAttributes([NSAttributedString.Key.paragraphStyle: para!], range: NSRange.init(location: 0, length: attr.string.count))
        }
        if _shadow != nil {
            attr.addAttributes([NSAttributedString.Key.shadow: _shadow?.shadow as Any], range: NSRange.init(location: 0, length: attr.string.count))
        } else if sha != nil{
            attr.addAttributes([NSAttributedString.Key.shadow: sha as Any], range: NSRange.init(location: 0, length: attr.string.count))
        }
        if _url != nil {
            attr.addAttributes([NSAttributedString.Key.link: _url!], range: NSRange.init(location: 0, length: attr.string.count))
        }
        return attr
    }
}

// MARK 可使用的方法
public extension RZImageAttribute {
     
    // 设置段落样式
    var paragraphStyle : RZImageParagraphStyle? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZImageParagraphStyle.init()
                _paragraphStyle?.and = self
            }
            return _paragraphStyle
        }
    }
    // 设置阴影
    var shadow : RZImageShadowStyle? {
        get {
            if _shadow == nil {
                _shadow = RZImageShadowStyle.init()
                _shadow?.and = self
            }
            return _shadow
        }
    }
     
    /// 图片大小和位置，y轴为正，图片上移
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.imageAttchment.bounds = bounds
        return self
    }
    
    /// 图片的size （大小） 与前后文本对齐的方式  font为前后文本的字体
    @discardableResult
    func size(_ size: CGSize, align:RZImageAttachmentHorizontalAlign, font:UIFont) -> Self {
        var y = 0.0;
        let fontHeight = font.ascender - font.descender;
        switch (align) {
        case .top:
            y = Double(-(size.height - fontHeight) + font.descender);
        case .center:
            y = Double(-(size.height - fontHeight)/2.0 + font.descender);
        case .bottom:
            y = Double(font.descender);
        }
        imageAttchment.bounds = CGRect(x: 0, y: CGFloat(y), width: size.width, height: size.height)
        return self
    }
    /// y轴偏移量，在某些情况下，在对齐之后需要做上下偏移时，用此方法，请在设置size之后或者bounds之后使用
    @discardableResult
    func yOffset(_ yOffset: CGFloat) -> Self {
        let bounds = imageAttchment.bounds;
        imageAttchment.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - yOffset, width: bounds.size.width, height: bounds.size.height)
        return self
    }
    
    /// 添加url
    @discardableResult
    func url(_ url: NSURL) -> Self {
        self._url = url
        return self
    }
    // 添加url
    @discardableResult
    func tapAction(_ tapAction:String) -> Self {
        self._url = NSURL.init(string: tapAction)
        return self
    }
}
