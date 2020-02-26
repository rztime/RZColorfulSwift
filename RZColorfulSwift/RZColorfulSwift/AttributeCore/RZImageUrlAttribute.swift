//
//  RZImageUrlAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public enum RZImagePosition: String {
    case left   = "text-align: left;"
    case center = "text-align: center;"
    case right  = "text-align: right;"
}
public class RZImageUrlAttribute: NSObject {
    var imageByUrl : String?
    
    private var maxSize : CGSize?
    private var size : CGSize?
    
    private var attributeDict = NSMutableDictionary.init()
    
    private var alignment : RZImagePosition?
    
    func package() -> NSAttributedString? {
        if imageByUrl == nil || imageByUrl?.count == 0 {
            return nil
        }
        let attr = NSAttributedString.htmlString(self.toHtmlString())
        return attr
    }
    
}
// MARK 可使用的方法
public extension RZImageUrlAttribute {
    /// 最大尺寸 默认宽为（屏幕宽-10），
    /// 高为0时，高度自适应
    @discardableResult
    func maxSize(_ size: CGSize?) -> Self {
        self.maxSize = size
        return self
    }
    
    /// 固定尺寸 宽高为0时，自适应
    @discardableResult
    func size(_ size: CGSize?) -> Self {
        self.size = size
        return self
    }
    
    /// 对齐方式 需单独一行时，设置有效
    @discardableResult
    func alignment(_ alignment: RZImagePosition) -> Self {
        self.alignment = alignment
        return self
    }
    
    func toHtmlString() -> String? {
        if self.imageByUrl == nil || self.imageByUrl?.count == 0 {
            return nil
        }
        var maxWidth = "max-width:\(UIScreen.main.bounds.size.width - 10)px;"
        var maxHeight = "max-height:auto;"
        var width = "width:auto;"
        var height = "height:auto;"
        
        var alig = "text-align: left;"
        
        if maxSize != nil {
            if maxSize!.width > 0 {
                maxWidth = "max-width:\(maxSize!.width)px;"
            }
            if maxSize!.height > 0 {
                maxHeight = "max-height:\(maxSize!.height)px;"
            }
        }
        if size != nil {
            if size!.width > 0 {
                width = "width:\(size!.width)px;"
            }
            if size!.height > 0 {
                height = "height:\(size!.height)px;"
            }
        }
        var html : String?
        if self.alignment != nil {
            alig = self.alignment!.rawValue; 
            html = "<div style='\(alig);height: auto;width:100%;'> <img style='\(maxWidth)\(maxHeight)\(width)\(height);'  src='\(imageByUrl!)'> </div>"
        } else {
            html = "<img style='\(maxWidth)\(maxHeight)\(width)\(height)'  src='\(imageByUrl!)'>"
        }
        return html
    }
}
