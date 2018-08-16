//
//  RZHtmlAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit
// MARK: - NSAttributedString 扩展
public extension NSAttributedString {
    public static func htmlString(_ html: String?) ->NSAttributedString? {
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
}

public class RZHtmlAttribute: NSObject {
    var htmlCode : NSAttributedString?
    
    func package() -> NSAttributedString? {
        if htmlCode == nil {
            return nil;
        }
        return htmlCode
    }
    
    // 富文本（如网页源码）
    @discardableResult
    public func htmlText(_ htmlText: String?) -> Self? {
        if htmlText?.count == 0 || htmlText == nil {
            return nil;
        }
        htmlCode = NSAttributedString.htmlString(htmlText);
        return self
    }
}

