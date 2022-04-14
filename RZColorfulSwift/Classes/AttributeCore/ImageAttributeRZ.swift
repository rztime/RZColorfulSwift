//
//  RZImageAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit
/// 文字、图片对齐方式
public enum ImageAttachmentHorizontalAlignRZ {
    case bottom
    case center
    case top
}

public class ImageAttributeRZ {
    private let imageAttchment = NSTextAttachment.init()
    private var attributeDict: [NSAttributedString.Key: Any] = [:]  // 一些其他属性
    private var _paragraphStyle : ParagraphStyleRZ<ImageAttributeRZ>?  // 样式
    private var _shadow : ShadowStyleRZ<ImageAttributeRZ>?            // 阴影
    private var yOffset: CGFloat?
    
    public init(_ image: UIImage? = nil) {
        if let image = image {
            self.imageAttchment.image = image
            self.imageAttchment.bounds = .init(origin: .zero, size: image.size)
        }
    }
}
extension ImageAttributeRZ: AttributePackageRZ {
    public func package(_ para: NSMutableParagraphStyle?, _ sha: NSShadow?) -> NSAttributedString? {
        guard let _ = self.imageAttchment.image else { return nil }
        if let y = yOffset {
            let bounds = imageAttchment.bounds
            imageAttchment.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - y, width: bounds.size.width, height: bounds.size.height)
        }
        let attr = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: imageAttchment))
        if let pa = (_paragraphStyle?.paragraph ?? para)?.copy() {
            attr.addAttributes([NSAttributedString.Key.paragraphStyle: pa], range: NSRange.init(location: 0, length: attr.string.count))
        }
        if let shadow = (_shadow?.shadow ?? sha)?.copy() {
            attr.addAttributes([NSAttributedString.Key.shadow: shadow], range: NSRange.init(location: 0, length: attr.string.count))
        }
        attr.addAttributes(attributeDict, range: NSRange.init(location: 0, length: attr.string.count))
        return attr
    }
}

// MARK 可使用的方法
public extension ImageAttributeRZ {
    /// 设置段落样式，使用and连接之后可继续设置图片属性
    var paragraphStyle : ParagraphStyleRZ<ImageAttributeRZ>? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = ParagraphStyleRZ.init(self)
            }
            return _paragraphStyle
        }
    }
    /// 设置阴影，使用and连接之后可继续设置图片属性
    var shadow : ShadowStyleRZ<ImageAttributeRZ>? {
        get {
            if _shadow == nil {
                _shadow = ShadowStyleRZ.init(self)
            }
            return _shadow
        }
    }
    /// 对齐方式 需单独一行时，设置有效
    @discardableResult
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .paragraphStyle?.alignment instead")
    func alignment(_ alignment: NSTextAlignment) -> Self {
        self.paragraphStyle?.alignment(alignment)
        return self
    }
    /// 图片大小和位置，y轴为正，图片上移
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        self.imageAttchment.bounds = bounds
        return self
    }
    /// 最大尺寸 默认宽为（屏幕宽-10），  其中一个为0时，自适应
    /// 高为0时，高度自适应
    @discardableResult
    func maxSize(_ size: CGSize, align: ImageAttachmentHorizontalAlignRZ = .bottom, font: UIFont = .systemFont(ofSize: 0)) -> Self {
        var s : CGSize = imageAttchment.bounds.size
        if size.width < s.width {
            s.width = size.width
        }
        if size.height < s.height {
            s.height = size.height
        }
        return self.size(s, align: align, font: font)
    }
    
    /// 图片的size （大小） 与前后文本对齐的方式  font为前后文本的字体 ： 其中一个为0时，自适应
    @discardableResult
    func size(_ size: CGSize, align: ImageAttachmentHorizontalAlignRZ = .bottom, font: UIFont = .systemFont(ofSize: 0)) -> Self {
        var size = size
        if size.width == 0 && size.height == 0 {
            size = imageAttchment.bounds.size
        } else if size.width == 0 {
            size.width = imageAttchment.bounds.size.width / imageAttchment.bounds.size.height * size.height
        } else if size.height == 0 {
            size.height = (imageAttchment.bounds.size.height * size.width) / imageAttchment.bounds.size.width
        }
        
        var y: CGFloat = 0.0
        let fontHeight = font.ascender - font.descender;
        switch (align) {
        case .top:
            y = -(size.height - fontHeight) + font.descender
        case .center:
            y = -(size.height - fontHeight)/2.0 + font.descender
        case .bottom:
            y = font.descender
        }
        imageAttchment.bounds = CGRect(x: 0, y: y, width: size.width, height: size.height)
        return self
    }
    /// y轴偏移量，在某些情况下，在对齐之后需要做上下偏移时，用此方法，请在设置size之后或者bounds之后使用
    @discardableResult
    func yOffset(_ yOffset: CGFloat?) -> Self {
        self.yOffset = yOffset
        return self
    }
    
    /// 添加url
    @discardableResult
    func url(_ url: URL?) -> Self {
        self.attributeDict[.link] = url
        return self
    }
    // 添加url
    @discardableResult
    func tapAction(_ action: String?) -> Self {
        self.attributeDict[.link] = action?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return self
    }
    // 添加点击事件 仅UILabel有效
    @discardableResult
    func tapActionByLable(_ action: String?) -> Self {
        self.attributeDict[.rztapLabel] = action?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return self
    }
    /// 添加自定义的key value
    @discardableResult
    func custom(key: NSAttributedString.Key, value: Any?) -> Self {
        self.attributeDict[key] = value
        return self
    }
}
