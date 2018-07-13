//
//  UITextView+RZColorful.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/13.
//  Copyright © 2018年 rztime. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    /// 设置富文本 （原内容将被清空）
    func rz_colorfulConfer(confer:ColorfulBlock?) -> Void {
        self.rzSetAttributedText(attr: nil)
        self.rz_colorfulConferInsetToLocation(0, confer)
    }
    
    /// 在指定位置插入富文本
    func rz_colorfulConferInsetTo(position: RZConferInsertPosition, _ append:ColorfulBlock?) -> Void {
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
    func rz_colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlock?) -> Void {
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
        var originAttr = self.rzAttributedString()
        if  originAttr == nil{
            originAttr = NSAttributedString.init()
        }
        let attr = NSMutableAttributedString.init(attributedString:originAttr!)
        attr.insert(conferrerColorful!, at: loc)
        self .rzSetAttributedText(attr: attr)
    }
    
    // 文本框的内容
    func rzAttributedString() -> NSAttributedString? {
        return self.attributedText;
    }
    // 设置文本框的内容
    func rzSetAttributedText(attr : NSAttributedString?) -> Void {
        self.attributedText = attr;
    }
    // 尾部的位置
    func getEndLocation() -> Int {
        return (self.attributedText?.length)!
    }
    // 光标的位置
    func getCursorLocation() -> Int {
        return self.selectedRange.location
    }
}
