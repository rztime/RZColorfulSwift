//
//  RZTextAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZTextAttribute : NSObject {
    public var text : String = ""
    private var attributeDict = NSMutableDictionary.init()
    
    private var _paragraphStyle : RZTextParagraphStyle?
    /// 段落
    public var paragraphStyle : RZTextParagraphStyle? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZTextParagraphStyle.init()
                _paragraphStyle!.and = self
            }
            return _paragraphStyle
        }
    }
    
    private var _shadow : RZTextShadowStyle?
    /// 阴影
    public var shadow : RZTextShadowStyle? {
        get {
            if _shadow == nil {
                _shadow = RZTextShadowStyle.init()
                _shadow!.and = self
            }
            return _shadow
        }
    }
    
    func package(_ para: NSMutableParagraphStyle?, _ shadow: NSShadow?) -> NSAttributedString? {
        if text.count == 0 {
            return nil;
        }
        if _paragraphStyle != nil {
            attributeDict.addEntries(from: [NSAttributedStringKey.paragraphStyle: _paragraphStyle!.paragraph])
        } else if para != nil {
            attributeDict.addEntries(from: [NSAttributedStringKey.paragraphStyle: para!])
        }
        
        if _shadow != nil {
            attributeDict.addEntries(from: [NSAttributedStringKey.shadow : _shadow!.shadow])
        } else if shadow != nil {
            attributeDict.addEntries(from: [NSAttributedStringKey.shadow : shadow!])
        }
        
        let attr =  NSAttributedString.init(string: text, attributes: attributeDict as? [NSAttributedStringKey : Any]);
        attributeDict.removeAllObjects()
        return attr
    }
    
    /// 字体
    @discardableResult
    public func font(_ font: UIFont) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.font: font])
        return self;
    }
    
    /// 字体颜色
    @discardableResult
    public func textColor(_ color: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.foregroundColor: color])
        return self;
    }
    
    /// 字体所在区域背景颜色
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.backgroundColor: color])
        return self;
    }
    
    /// 设置连体字，value = 0,没有连体， =1，有连体
    @discardableResult
    public func ligature(_ ligature: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.ligature: ligature])
        return self;
    }
    
    /// 字间距 >0 加宽  < 0减小间距
    @discardableResult
    public func kern(_ kern: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.kern: kern])
        return self;
    }
    
    /**
     删除线
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    public func strikethroughStyle(_ strikethroughStyle: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.strikethroughStyle: strikethroughStyle])
        return self;
    }
    
    /**
     下划线样式  取值参照删除线，位置不同罢了
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    public func underlineStyle(_ underlineStyle: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.underlineStyle: underlineStyle])
        return self;
    }
    
    /// 描边的颜色
    @discardableResult
    public func strokeColor(_ strokeColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.strokeColor: strokeColor])
        return self;
    }
    
    /// 描边的笔画宽度 为3时，空心  负值填充效果，正值中空效果
    @discardableResult
    public func strokeWidth(_ strokeWidth: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.strokeWidth: strokeWidth])
        return self;
    }
    
    /// 给文本添加链接，并且可点击跳转浏览器打开  仅UITextView点击有效
    @discardableResult
    public func link(_ link: NSURL) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.link: link])
        return self;
    }
    
    /// 基准线偏移值
    @discardableResult
    public func baselineOffset(_ baselineOffset: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.baselineOffset: baselineOffset])
        return self;
    }
    
    /// 下划线颜色
    @discardableResult
    public func underlineColor(_ underlineColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.underlineColor: underlineColor])
        return self;
    }
    
    /// 删除线颜色
    @discardableResult
    public func strikethroughColor(_ strikethroughColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.strikethroughColor: strikethroughColor])
        return self;
    }
    
    /// 倾斜
    @discardableResult
    public func obliqueness(_ obliqueness: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.obliqueness: obliqueness])
        return self;
    }
    
    /// 扩张，即拉伸文字 >0 拉伸 <0压缩
    @discardableResult
    public func expansion(_ expansion: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.expansion: expansion])
        return self;
    }
    
    
    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    public func writingDirection(_ writingDirection: [NSNumber]) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.writingDirection: writingDirection])
        return self;
    }
    
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    public func verticalGlyphForm(_ verticalGlyphForm: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedStringKey.verticalGlyphForm: verticalGlyphForm])
        return self;
    }
}
