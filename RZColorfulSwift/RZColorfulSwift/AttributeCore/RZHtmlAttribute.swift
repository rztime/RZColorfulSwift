//
//  RZHtmlAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZHtmlAttribute: NSObject {
    var htmlCode : NSAttributedString?
    
    public func package() -> NSAttributedString? {
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

