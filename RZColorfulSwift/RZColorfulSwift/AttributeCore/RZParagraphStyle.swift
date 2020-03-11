//
//  RZParagraphStyle.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/11.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZParagraphStyle: NSObject {
    var paragraph = NSMutableParagraphStyle.init()
    
    /// 段落行距
    @discardableResult
    public func lineSpacing(_ lineSpacing:CGFloat) -> Self {
        paragraph.lineSpacing = lineSpacing
        return self
    }
    
    /// 段与段之间的间距
    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore:CGFloat) -> Self {
        paragraph.paragraphSpacingBefore = paragraphSpacingBefore
        return self
    }
    
    /// 段落后面的间距
    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing:CGFloat) -> Self {
        paragraph.paragraphSpacing = paragraphSpacing
        return self
    }
    
    /// 文本对齐方式
    @discardableResult
    public func alignment(_ alignment:NSTextAlignment) -> Self {
        paragraph.alignment = alignment
        return self
    }
    
    /// 首行文本缩进
    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent:CGFloat) -> Self {
        paragraph.firstLineHeadIndent = firstLineHeadIndent
        return self
    }
    
    /// 非首行文本缩进
    @discardableResult
    public func headIndent(_ headIndent:CGFloat) -> Self {
        paragraph.headIndent = headIndent
        return self
    }
    
    /// 文本缩进
    @discardableResult
    public func tailIndent(_ tailIndent:CGFloat) -> Self {
        paragraph.tailIndent = tailIndent
        return self
    }
    
    /// 文本折行方式
    @discardableResult
    public func lineBreakMode(_ lineBreakMode:NSLineBreakMode) -> Self {
        paragraph.lineBreakMode = lineBreakMode
        return self
    }
    
    /// 文本最小行距
    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight:CGFloat) -> Self {
        paragraph.minimumLineHeight = minimumLineHeight
        return self
    }
    
    /// 文本最大行距
    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight:CGFloat) -> Self {
        paragraph.maximumLineHeight = maximumLineHeight
        return self
    }
    
    /// 文本写入方式，即显示方式，从左至右，或从右到左
    @discardableResult
    public func baseWritingDirection(_ baseWritingDirection:NSWritingDirection) -> Self {
        paragraph.baseWritingDirection = baseWritingDirection
        return self
    }
    
    /// 设置文本行间距是默认间距的倍数
    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple:CGFloat) -> Self {
        paragraph.lineHeightMultiple = lineHeightMultiple
        return self
    }
    
    /// 设置每行的最后单词是否截断，在0.0-1.0之间，默认为0.0，越接近1.0单词被截断的可能性越大，
    @discardableResult
    public func hyphenationFactor(_ hyphenationFactor:Float) -> Self {
        paragraph.hyphenationFactor = hyphenationFactor
        return self
    }
    
    /// 未知
    @discardableResult
    public func defaultTabInterval(_ defaultTabInterval:CGFloat) -> Self {
        paragraph.defaultTabInterval = defaultTabInterval
        return self
    }
    
    /// 未知
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ allowsDefaultTighteningForTruncation:Bool) -> Self {
        if #available(iOS 9.0, *) {
            paragraph.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
        } else {
            // Fallback on earlier versions
        }
        return self
    } 
}

public class RZTextParagraphStyle : RZParagraphStyle {
    public weak var and : RZTextAttribute?
}

public class RZImageParagraphStyle : RZParagraphStyle {
    public weak var and : RZImageAttribute?
}

public class RZColorfulConferrerParagraphStyle : RZParagraphStyle {
    public weak var and : RZColorfulConferrer?
}
