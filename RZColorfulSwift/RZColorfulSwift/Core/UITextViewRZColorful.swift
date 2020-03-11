//
//  UITextView+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 对TextView的富文本的支持
public extension UITextView {
    /// 设置富文本 （原内容将被清空）
    func rz_colorfulConfer(confer:ColorfulBlock?) -> Void {
        self.attributedText = nil;
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
        var originAttr = self.attributedText
        if  originAttr == nil{
            originAttr = NSAttributedString.init()
        }
        let attr = NSMutableAttributedString.init(attributedString:originAttr!)
        attr.insert(conferrerColorful!, at: loc)
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
    
    // 给UItextView添加点击属性时，点击的事件的回调，
    // 默认 return false  （true时，将打开浏览器）
    func rzDidTapTextView(rzdidTapTextView:@escaping RZDidTapTextView) {
        self.rzDidTapTextView = rzdidTapTextView
    }
}

// 添加的辅助属性，非主动使用方法
public extension UITextView {
    struct RZPropertyKey {
        static let rzHelperKey = UnsafeRawPointer.init(bitPattern: "rzHelperKey".hashValue)
        static let rzDidTapTextViewKey = UnsafeRawPointer.init(bitPattern: "rzDidTapTextViewKey".hashValue)
    }
    
    var rzHelper:RZTapActionHelper? {
        set {
            objc_setAssociatedObject(self, UITextView.RZPropertyKey.rzHelperKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let rzh = objc_getAssociatedObject(self, UITextView.RZPropertyKey.rzHelperKey!) as? RZTapActionHelper {
                return rzh
            }
            return nil
        }
    }
    // 点击事件
    typealias RZDidTapTextView = (_ tapObj:String, _ textView:UITextView) -> Bool
    var rzDidTapTextView : RZDidTapTextView? {
        set {
            objc_setAssociatedObject(self, UITextView.RZPropertyKey.rzDidTapTextViewKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            let rzHelper = RZTapActionHelper.init()
            rzHelper.rzTextView = self
            self.rzHelper = rzHelper
        }
        get {
            if let rzdtv = objc_getAssociatedObject(self, UITextView.RZPropertyKey.rzDidTapTextViewKey!) as? RZDidTapTextView {
                return rzdtv
            }
            return nil
        }
    }
}
