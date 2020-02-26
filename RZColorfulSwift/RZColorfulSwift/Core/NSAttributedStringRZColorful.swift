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
        let attr = connferrer.confer();
        return attr
    }
    
    func attributedStringByAppend(attributedString : NSAttributedString) -> NSAttributedString {
        let attr = NSMutableAttributedString.init(attributedString: self)
        attr.append(attributedString)
        return attr.copy() as! NSAttributedString
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
        var size = self.sizeWithCondition(size: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height:CGFloat(height) ))
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
        if html?.count == 0 || html == nil {
            return nil;
        }
        let data = html!.data(using: String.Encoding.unicode)
        do {
            return try NSAttributedString.init(data: data!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch let error as NSError {
            print("html转换失败:\(error.localizedDescription)")
        }
        return nil
    }
    func rz_images() -> [UIImage] {
        var arrays = [UIImage]()
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, self.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range, stop) -> Void  in
            let image = value as? NSTextAttachment
            if image != nil {
                if image?.image != nil {
                    arrays.append(image!.image!)
                } else if (image?.fileWrapper?.regularFileContents != nil) {
                    let img = UIImage.init(data: image!.fileWrapper!.regularFileContents! )
                    arrays.append(img!)
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
        let tempAttr = self.mutableCopy() as! NSMutableAttributedString
        var idx = 0
        var tempPlaceHolders = [String]()
        tempAttr.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, tempAttr.length), options: NSAttributedString.EnumerationOptions.reverse) { (value, range, stop) in
            let image = value as? NSTextAttachment
            if image != nil {
                let placeHolder = "rz_attributed_image_placeHolder_index_\(idx)"
                idx = idx + 1
                tempAttr.replaceCharacters(in: range, with: placeHolder)
                tempPlaceHolders.append(placeHolder)
            }
        }
        var html = tempAttr.rz_codingToCompleteHtml()! as NSString
        var index = 0
        for placeHolder in tempPlaceHolders.enumerated().reversed() {
            if index < urls?.count ?? 0 {
                let url = urls?[index] ?? ""
                let img = "<img style=\"max-width:98%%;height:auto;\" src=\"\(url)\" alt=\"图片缺失\">"
                html = html.replacingOccurrences(of: (placeHolder.element as String), with: img) as NSString
            }
            index = index + 1
        }
        return html as String
    }
    
    /// 将富文本编码成html标签
    func rz_codingToCompleteHtml() -> String? {
        let exportParams = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes: exportParams)
            var htmlString = NSString.init(data: htmlData, encoding: String.Encoding.utf8.rawValue)
            htmlString = htmlString?.replacingOccurrences(of: "pt;", with: "px;") as NSString?
            htmlString = htmlString?.replacingOccurrences(of: "pt}", with: "px}") as NSString?
            return htmlString as String?
        } catch {
            return ""
        }
    }
}
