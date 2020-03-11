//
//  UITextField+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 对TextField的富文本支持
public extension UITextField { 
    /// 设置富文本 （原内容将被清空）
    public func rz_colorfulConfer(confer:ColorfulBlock?) -> Void {
        self.attributedText = nil;
        self.rz_colorfulConferInsetToLocation(0, confer)
    }
    
    /// 在指定位置插入富文本
    public func rz_colorfulConferInsetTo(position: RZConferInsertPosition, _ append:ColorfulBlock?) -> Void {
        var location = 0;
        switch position {
        case .Default, .Cursor :
            location = self.getCursorLocation()
        case .Header :
            location = 0
        case .End :
            location = self.getEndLocation()
        }
        self.rz_colorfulConferInsetToLocation(location, append)
    }
    
    /// 在指定位置处加入富文本
    public func rz_colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlock?) -> Void {
        if confer == nil {
            return ;
        }
        var loc = location;
        if loc < 0 {
            loc = 0;
        }
        
        let conferrerColorful = NSAttributedString.rz_colorfulConfer(confer: confer!)
        if conferrerColorful?.length == 0 || conferrerColorful == nil {
            return ;
        }
        var originAttr = self.attributedText
        if  originAttr == nil{
            originAttr = NSAttributedString.init()
        }
        let attr = NSMutableAttributedString.init(attributedString:originAttr!)
        attr.insert(conferrerColorful!, at: loc)
        self.attributedText = attr;
    }
    
    // 尾部的位置
    public func getEndLocation() -> Int {
        return (self.attributedText?.length)!
    }
    // 光标的位置
    public func getCursorLocation() -> Int {
        return self.rz_selectedRange().location
    }
    
    public func rz_selectedRange() -> NSRange {
        let beginning = self.beginningOfDocument;
        let selectedRange = self.selectedTextRange;
        let selectionStart = selectedRange!.start;
        let selectionEnd = selectedRange!.end;
        
        let location = self.offset(from: beginning, to: selectionStart)
        let length = self.offset(from: selectionStart, to: selectionEnd)
        
        return NSRange.init(location: location, length: length)
    }
    
    public func rz_setSelectedRange(range: NSRange) -> Void {
        let beginning = self.beginningOfDocument;
        let startPosition = self.position(from: beginning, offset: range.location)!
        let endPosition = self.position(from: beginning, offset: range.location + range.length)!
        let selectionRange = self.textRange(from: startPosition, to: endPosition)
        self.selectedTextRange = selectionRange
    }
}
