//
//  NSAttributedString+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NSAttributedString 扩展
public extension NSAttributedString {
    /// 富文本 归纳
    static func rz_colorfulConfer(confer:ColorfulBlock) -> NSAttributedString? {
        let connferrer = RZColorfulConferrer.init()
        confer(connferrer)
        return connferrer.confer()
    }
    
    func attributedStringByAppend(attributedString : NSAttributedString) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(attributedString: self)
        attr.append(attributedString)
        return NSAttributedString.init(attributedString: attr)
    }

    /**
     固定宽度，计算高
     
     @param width 固定宽度
     */
    func sizeWithConditionWidth(width:Float) -> CGSize {
        var size = self.sizeWithCondition(size: CGSize.init(width: CGFloat(width), height: CGFloat.greatestFiniteMagnitude))
        size.width = CGFloat(width)
        return size
    }
    /**
     固定高度，计算宽
     
     @param height 固定高度
     */
    func sizeWithConditionHeight(height:Float) -> CGSize {
        var size = self.sizeWithCondition(size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:CGFloat(height)))
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
    func sizeWithCondition(size:CGSize) -> CGSize {
        //  NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
        let rect = self.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)
        return rect.size
    }
    // 将html转换成 NSAttributedString
    static func htmlString(_ html: String?) ->NSAttributedString? {
        guard let html = html, html.count > 0 else {return nil}
        if let data = html.data(using: String.Encoding.unicode) {
            do {
                return try NSAttributedString.init(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch let error as NSError {
                print("html转换失败:\(error.localizedDescription)")
            }
        }
        return nil
    }
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
    /**
     将富文本编码成html标签，如果有图片，用此方法
     
     @param urls 图片的url，url需要先获取图片，然后自行上传到服务器，最后按照【- rz_images】此方法得到的图片顺序排列url
     @return HTML标签
     */
    func rz_codingToHtmlWithImagesURLSIfHad(urls:[String]?) -> String? {
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
        do {
            let exportParams = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes: exportParams)
            var string = String.init(data: htmlData, encoding: String.Encoding.utf8)
            string = string?.replacingOccurrences(of: "pt;", with: "px;")
            string = string?.replacingOccurrences(of: "pt}", with: "px}")
            return string
        } catch {
            return nil
        }
    }
}
