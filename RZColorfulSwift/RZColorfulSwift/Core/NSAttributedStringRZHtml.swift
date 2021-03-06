//
//  NSAttributedStringRZHtml.swift
//  RZColorfulSwift
//
//  Created by rztime on 2020/9/17.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    /// 将html转换成 NSAttributedString
    static func htmlString(_ html: String?) ->NSAttributedString? {
        guard let html = html, html.count > 0 else {return nil}
        if let data = html.data(using: String.Encoding.unicode) {
            if let attr = try? NSMutableAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                return attr
            }
        }
        return nil
    }
    /**
     将富文本编码成html标签，如果有图片，用此方法
     
     @param urls 图片的url，url需要先获取图片，然后自行上传到服务器，最后按照【- rz_images】此方法得到的图片顺序排列url
     @return HTML标签
     */
    func rz_codingToHtmlWithImagesURLSIfHad(urls: [String]?) -> String? {
        let tempAttr = NSMutableAttributedString.init(attributedString: self)
        var idx = 0
        var tempPlaceHolders: [String] = []
        tempAttr.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, tempAttr.length), options: NSAttributedString.EnumerationOptions.reverse) { (value, range, stop) in
            if let _ = value as? NSTextAttachment {
                let placeHolder = "rz_attributed_image_placeHolder_index_\(idx)"
                idx = idx + 1
                tempAttr.replaceCharacters(in: range, with: placeHolder)
                tempPlaceHolders.append(placeHolder)
            }
        }
        var html = tempAttr.rz_codingToCompleteHtml()
        var index = 0
        for placeHolder in tempPlaceHolders.enumerated().reversed() {
            if index < urls?.count ?? 0 {
                let url = urls?[index] ?? ""
                let img = "<img style=\"max-width:98%%;height:auto;\" src=\"\(url)\" alt=\"图片缺失\">"
                html = html?.replacingOccurrences(of: placeHolder.element, with: img)
            }
            index = index + 1
        }
        return html
    }
    /// 将富文本编码成html标签
    func rz_codingToCompleteHtml() -> String? {
        let exportParams = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        if let htmlData = try? self.data(from: NSMakeRange(0, self.length), documentAttributes: exportParams) {
            var string = String.init(data: htmlData, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "pt;", with: "px;")
            string = string?.replacingOccurrences(of: "pt}", with: "px}")
            return string
        }
        return nil
    }
}

public extension NSAttributedString {
    /// 将NSAttributedString 转换为 适用web的html  （删除线、下划线、斜体、扩展、描边、书写方向等系统方法不能正常转换，所以通过额外的方法去改写html）
    /// 需要自定义的标签、可以在 RZHtmlTransform.share.webLabels 中添加  这个转换为html之后，可以在webview上显示，但这个html不可逆转（不可 html转NSAttributedString）
    func rz_codingToCompleteHtmlByWeb() -> String? {
        let tempAttr = NSMutableAttributedString.init(attributedString: self)
        let labels = RZHtmlTransform.share.webLabels
        
        var temparray: [RZHtmlTransform] = [] // 记录转换了多少个标签，最后需要还原
        self.enumerateAttributes(in: NSMakeRange(0, tempAttr.length), options: .longestEffectiveRangeNotRequired) { (attrs, rang, _) in
            let tempAttributed = NSMutableAttributedString.init(attributedString: tempAttr.attributedSubstring(from: rang))
            let tempAttrDict = NSMutableDictionary.init(dictionary: attrs)
            let form = RZHtmlTransform.init()
            let url = tempAttrDict[NSAttributedString.Key.link]
            if let u = url as? NSURL {
                form.url = u.absoluteString
            } else if let u = url as? String {
                form.url = u
            }
            
            labels.forEach { (obj) in
                if obj.keys.count > 0, RZArrayHelper.compare(obj: tempAttrDict.allKeys, obj2: obj.keys) {
                    let style = (obj.styleConfigure?("", tempAttrDict)) ?? ""
                    form.style = "\(form.style ?? "")\(style)"
                    obj.keys.forEach { (key) in
                        tempAttributed.removeAttribute(key, range: NSMakeRange(0, tempAttributed.length))
                    }
                    tempAttrDict.removeObjects(forKeys: obj.keys)
                } else if let key = obj.key, RZArrayHelper.compare(obj: tempAttrDict.allKeys, obj2: [key]) {
                    let value = tempAttrDict[key] ?? ""
                    let style = (obj.styleConfigure?(value, tempAttrDict)) ?? ""
                    form.style = "\(form.style ?? "")\(style)"
                    tempAttributed.removeAttribute(key, range: NSMakeRange(0, tempAttributed.length))
                    tempAttrDict.removeObject(forKey: key)
                }
            }
            if let newUrl = form.mergeUrlAndStyle(), newUrl.count > 0 {
                tempAttributed.addAttribute(.link, value: newUrl, range: NSMakeRange(0, tempAttributed.length))
                tempAttr.replaceCharacters(in: rang, with: tempAttributed)
                temparray.append(form)
            }
        }
        var text = tempAttr.rz_codingToCompleteHtml()
        temparray.forEach { (obj) in
            text = obj.creatHtmlLabelWith(html: text)
        }
        return text
    }
    /// 有图片时，转换为web适用的html
    func rz_codingToHtmlByWebWithImagesURLSIfHad(urls: [String]?) -> String? {
        let tempAttr = NSMutableAttributedString.init(attributedString: self)
        var idx = 0
        var tempPlaceHolders: [String] = []
        tempAttr.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, tempAttr.length), options: NSAttributedString.EnumerationOptions.reverse) { (value, range, stop) in
            if let _ = value as? NSTextAttachment {
                let placeHolder = "rz_attributed_image_placeHolder_index_\(idx)"
                idx = idx + 1
                tempAttr.replaceCharacters(in: range, with: placeHolder)
                tempPlaceHolders.append(placeHolder)
            }
        }
        var html = tempAttr.rz_codingToCompleteHtmlByWeb()
        var index = 0
        for placeHolder in tempPlaceHolders.enumerated().reversed() {
            if index < urls?.count ?? 0 {
                let url = urls?[index] ?? ""
                let img = "<img style=\"max-width:98%%;height:auto;\" src=\"\(url)\" alt=\"图片缺失\">"
                html = html?.replacingOccurrences(of: placeHolder.element, with: img)
            }
            index = index + 1
        }
        return html
    }
}

public class RZArrayHelper {
    /// 比较两个数组 obj包含obj2时，return true (只比较了 NSAttributedString.Key，和String)
    static func compare(obj: [Any]?, obj2: [Any]?) -> Bool {
        guard let obj = obj else { return false }
        guard let obj2 = obj2 else { return false }
        var flag = false
        for i in obj2 {
            var obj1 = ""
            if let i = i as? NSAttributedString.Key {
                obj1 = i.rawValue
            } else if let i = i as? String {
                obj1 = i
            }
            let idx = obj.firstIndex { (o) -> Bool in
                var o1 = ""
                if let o = o as? NSAttributedString.Key {
                    o1 = o.rawValue
                } else if let o = o as? String {
                    o1 = o
                }
                return o1 == obj1
            }
            if idx != nil {
                flag = true
            } else {
                return false
            }
            
        }
        return flag
    }
}
