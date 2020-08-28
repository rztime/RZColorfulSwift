//
//  RZColorfulConferrer.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZColorfulConferrer {
    private var texts = NSMutableArray.init()
    private var _paragraphStyle: RZParagraphStyle<RZColorfulConferrer>?
    private var _shadow: RZShadowStyle<RZColorfulConferrer>?
    
    func confer() -> NSAttributedString? {
        let text = NSMutableAttributedString.init()
        texts .forEach { (t) in
            if let t = t as? RZTextAttribute, let tt = t.package(_paragraphStyle?.paragraph, _shadow?.shadow) {
                text.append(tt)
            } else if let t = t as? RZImageAttribute, let tt = t.package(_paragraphStyle?.paragraph, _shadow?.shadow) {
                text.append(tt)
            }
        }
        texts.removeAllObjects()
        return text
    } 
}
// MARK 可使用的方法
public extension RZColorfulConferrer { 
    /// 文字
    @discardableResult
    func text(_ text:String?) ->  RZTextAttribute?{
        guard let text = text, text.count > 0 else { return nil }
        let attribute = RZTextAttribute.init(text)
        self.texts.add(attribute)
        return attribute
    }
    /// 富文本（如网页源码）
    @discardableResult
    func htmlString(_ htmlString:String?) -> RZTextAttribute? {
        guard let htmlString = htmlString, htmlString.count > 0 else { return nil }
        let attr = NSAttributedString.htmlString(htmlString)
        let attribute = RZTextAttribute.init(attr)
        self.texts.add(attribute)
        return attribute;
    }
    /// 图片 可以设置bounds
    @discardableResult
    func image(_ image:UIImage?) -> RZImageAttribute? {
        guard let image = image else { return nil }
        let attribute = RZImageAttribute.init(image)
        self.texts.add(attribute)
        return attribute
    }
    
    /// url图片 可以设置size，maxSize
    @discardableResult
    func imageByUrl(_ imageUrl:String?) -> RZImageAttribute? {
        guard let imageUrl = imageUrl, imageUrl.count > 0 else { return nil }
        let attribute = RZImageAttribute.init(nil, imageUrl)
        self.texts.add(attribute)
        return attribute;
    }

    /// 段落
    var paragraphStyle: RZParagraphStyle<RZColorfulConferrer>? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZParagraphStyle<RZColorfulConferrer>.init(self)
            }
            return _paragraphStyle
        }
    }
    /// 阴影
    var shadow : RZShadowStyle<RZColorfulConferrer>? {
        get {
            if _shadow == nil {
                _shadow = RZShadowStyle<RZColorfulConferrer>.init(self)
            }
            return _shadow
        }
    }
}
