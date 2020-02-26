//
//  RZTextAttribute.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZTextAttribute : NSObject {
    var text : String = ""
    private var attributeDict = NSMutableDictionary.init()
    
    private var _paragraphStyle : RZTextParagraphStyle?
    private var _shadow : RZTextShadowStyle?
    
    func package(_ para: NSMutableParagraphStyle?, _ shadow: NSShadow?) -> NSAttributedString? {
        if text.count == 0 {
            return nil;
        }
        if _paragraphStyle != nil {
            attributeDict.addEntries(from: [NSAttributedString.Key.paragraphStyle: _paragraphStyle!.paragraph])
        } else if para != nil {
            attributeDict.addEntries(from: [NSAttributedString.Key.paragraphStyle: para!])
        }
        
        if _shadow != nil {
            attributeDict.addEntries(from: [NSAttributedString.Key.shadow : _shadow!.shadow])
        } else if shadow != nil {
            attributeDict.addEntries(from: [NSAttributedString.Key.shadow : shadow!])
        }
        
        let attr =  NSAttributedString.init(string: text, attributes: attributeDict as? [NSAttributedString.Key : Any]);
        attributeDict.removeAllObjects()
        return attr
    }
}
// MARK 可使用的方法
public extension RZTextAttribute { 
    /// 段落
    var paragraphStyle : RZTextParagraphStyle? {
        get {
            if _paragraphStyle == nil {
                _paragraphStyle = RZTextParagraphStyle.init()
                _paragraphStyle!.and = self
            }
            return _paragraphStyle
        }
    }
     
    /// 阴影
    var shadow : RZTextShadowStyle? {
        get {
            if _shadow == nil {
                _shadow = RZTextShadowStyle.init()
                _shadow!.and = self
            }
            return _shadow
        }
    }
    
    /// 字体
    @discardableResult
    func font(_ font: UIFont) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.font: font])
        return self;
    }
    
    /// 字体颜色
    @discardableResult
    func textColor(_ color: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.foregroundColor: color])
        return self;
    }
    
    /// 字体所在区域背景颜色
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.backgroundColor: color])
        return self;
    }
    
    /// 设置连体字，value = 0,没有连体， =1，有连体
    @discardableResult
    func ligature(_ ligature: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.ligature: ligature])
        return self;
    }
    
    /// 字间距 >0 加宽  < 0减小间距
    @discardableResult
    func kern(_ kern: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.kern: kern])
        return self;
    }
    
    /**
     删除线
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func strikethroughStyle(_ strikethroughStyle: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.strikethroughStyle: strikethroughStyle])
        return self;
    }
    
    /**
     下划线样式  取值参照删除线，位置不同罢了
     取值为 0 - 7时，效果为单实线，随着值得增加，单实线逐渐变粗，
     取值为 9 - 15时，效果为双实线，取值越大，双实线越粗。
     */
    @discardableResult
    func underlineStyle(_ underlineStyle: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.underlineStyle: underlineStyle])
        return self;
    }
    
    /// 描边的颜色
    @discardableResult
    func strokeColor(_ strokeColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.strokeColor: strokeColor])
        return self;
    }
    
    /// 描边的笔画宽度 为3时，空心  负值填充效果，正值中空效果
    @discardableResult
    func strokeWidth(_ strokeWidth: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.strokeWidth: strokeWidth])
        return self;
    }
    
    /// 给文本添加链接，并且可点击跳转浏览器打开  仅UITextView点击有效
    @discardableResult
    func link(_ link: NSURL) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.link: link])
        return self;
    }
    /// 给文本添加点击事件的id
    @discardableResult
    func tapAction(_ link: String) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.link: NSURL.init(string: link) as Any])
        return self;
    }
    
    /// 基准线偏移值
    @discardableResult
    func baselineOffset(_ baselineOffset: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.baselineOffset: baselineOffset])
        return self;
    }
    
    /// 下划线颜色
    @discardableResult
    func underlineColor(_ underlineColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.underlineColor: underlineColor])
        return self;
    }
    
    /// 删除线颜色
    @discardableResult
    func strikethroughColor(_ strikethroughColor: UIColor) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.strikethroughColor: strikethroughColor])
        return self;
    }
    
    /// 倾斜
    @discardableResult
    func obliqueness(_ obliqueness: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.obliqueness: obliqueness])
        return self;
    }
    
    /// 扩张，即拉伸文字 >0 拉伸 <0压缩
    @discardableResult
    func expansion(_ expansion: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.expansion: expansion])
        return self;
    }
    
    
    /// 书写方向
    /// - Parameter writingDirection: NSWritingDirection and NSWritingDirectionFormatType
    @discardableResult
    func writingDirection(_ writingDirection: [NSNumber]) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.writingDirection: writingDirection])
        return self;
    }
    
    /// 横竖排版 0：横版 1：竖版
    @discardableResult
    func verticalGlyphForm(_ verticalGlyphForm: NSNumber) -> Self{
        attributeDict.addEntries(from: [NSAttributedString.Key.verticalGlyphForm: verticalGlyphForm])
        return self;
    }
}
