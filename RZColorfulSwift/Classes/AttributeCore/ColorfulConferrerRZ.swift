//
//  ColorfulConferrerRZ.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class ColorfulConferrerRZ {
    private var texts = NSMutableArray.init()
    private var _paragraphStyle: ParagraphStyleRZ<ColorfulConferrerRZ>?
    private var _shadow: ShadowStyleRZ<ColorfulConferrerRZ>?
    
    public func confer() -> NSAttributedString? {
        let text = NSMutableAttributedString.init()
        texts.forEach { (t) in
            if let t = t as? AttributePackageRZ, let tt = t.package(_paragraphStyle?.paragraph, _shadow?.shadow) {
                if tt.length > 0, let p = tt.attribute(.paragraphStyle, at:0, effectiveRange: nil) as? RZMutableParagraphStyle, p.numberOfLines > 0, p.textDrawMaxWidth > 0 {
                    /// 默认占位符 ... 也可以自定义
                    let placeholder : NSAttributedString = p.truncateText ?? tt.rz.copyAttributeToText("...")
                    let mode = p.lineBreakMode
                    p.lineBreakMode = .byWordWrapping
                    if let res = tt.rz.attributedStringBy(maxline: p.numberOfLines, maxWidth: p.textDrawMaxWidth, lineBreakMode: mode, placeHolder: placeholder) {
                        text.append(res)
                    } else {
                        text.append(tt)
                    }
                } else {
                    text.append(tt)
                }
            }
        }
        texts.removeAllObjects()
        return text
    }
}
// MARK 可使用的方法
public extension ColorfulConferrerRZ {
    /// 文字
    @discardableResult
    func text(_ text: String?) -> TextAttributeRZ? {
        guard let text = text, text.count > 0 else { return nil }
        let attribute = TextAttributeRZ.init(text)
        self.texts.add(attribute)
        return attribute
    }
    /// 富文本（如网页源码）
    @discardableResult
    func htmlString(_ htmlString: String?) -> TextAttributeRZ? {
        guard let htmlString = htmlString, htmlString.count > 0,
              let attr = NSAttributedString.rz.htmlString(htmlString), attr.length > 0 else {
            return nil
        }
        let attribute = TextAttributeRZ.init(attributedText: attr)
        self.texts.add(attribute)
        return attribute;
    }
    /// 图片 可以设置bounds
    @discardableResult
    func image(_ image: UIImage?) -> ImageAttributeRZ? {
        guard let image = image else { return nil }
        let attribute = ImageAttributeRZ.init(image)
        self.texts.add(attribute)
        return attribute
    }
    
    /// url图片 可以设置size，maxSize （会直接下载图片，所以在主线程时会阻塞线程）
    /// 支持本地filepath路径的图片
    @discardableResult
    func imageByUrl(_ imageUrl: String?) -> ImageAttributeRZ? {
        if var url = imageUrl {
            if !url.hasPrefix("http") && !url.hasPrefix("file://") {
                url = "file://\(url)"
            }
            if let u = URL.init(string: url), let imageData = try? Data.init(contentsOf: u), let image = UIImage.init(data: imageData) {
                return self.image(image)
            }
            if let u = URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), let imageData = try? Data.init(contentsOf: u), let image = UIImage.init(data: imageData) {
                return self.image(image)
            }
            if let u = URL.init(string: url.removingPercentEncoding ?? ""), let imageData = try? Data.init(contentsOf: u), let image = UIImage.init(data: imageData) {
                return self.image(image)
            }
        }
        return nil
    }
    
    /// 段落
    var paragraphStyle: ParagraphStyleRZ<ColorfulConferrerRZ>? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = ParagraphStyleRZ<ColorfulConferrerRZ>.init(self)
            }
            return _paragraphStyle
        }
    }
    /// 阴影
    var shadow: ShadowStyleRZ<ColorfulConferrerRZ>? {
        get {
            if _shadow == nil {
                _shadow = ShadowStyleRZ<ColorfulConferrerRZ>.init(self)
            }
            return _shadow
        }
    }
}
