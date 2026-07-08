//
//  UILabel+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

public enum ConferInsertPositionRZ: Int {
    case Default
    case Header
    case End
    case Cursor
}
// MARK: - 对Label的富文本支持
public extension RZColorfulSwiftBase where T: UILabel {
    /// 设置富文本 （原内容将被清空）
    func colorfulConfer(confer: ColorfulBlockRZ?) {
        self.rz.attributedText = nil
        self.colorfulConferInsetToLocation(0, confer)
    }
    /// 在指定位置插入富文本
    func colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append: ColorfulBlockRZ?) {
        var location = 0
        switch position {
        case .Default, .Cursor, .End:
            location = self.getEndLocation()
        case .Header:
            location = 0
        }
        self.colorfulConferInsetToLocation(location, append)
    }
    
    /// 在指定位置处加入富文本
    func colorfulConferInsetToLocation(_ location: Int, _ confer: ColorfulBlockRZ?) {
        guard let confer = confer else { return }
        guard let conferrerColorful = NSAttributedString.rz.colorfulConfer(confer: confer), conferrerColorful.length > 0 else { return }
        if location == 0 {
            self.rz.attributedText = conferrerColorful
            return
        }
        let originAttr = self.rz.attributedText ?? NSAttributedString.init()
        let attr = NSMutableAttributedString.init(attributedString:originAttr)
        var loc = max(location, 0)
        loc = min(loc, attr.length)
        attr.insert(conferrerColorful, at: loc)
        self.rz.attributedText = attr
    }
    // 尾部的位置
    func getEndLocation() -> Int {
        return self.rz.attributedText?.length ?? 0
    }
}

public extension RZColorfulSwiftBase where T: UILabel {
    
    /// 设置富文本（超过行数后，自动追加“展开” “收起”）
    /// - Parameters:
    ///   - attributedString: 原文
    ///   - maxLine: 最大显示行数
    ///   - maxWidth: 最大显示宽度，这个宽度用于计算文本行
    ///   - isFold: 当前是否折叠
    ///   - showAllText: 超过了行数之后，折叠状态显示的文本 如”展开“  需要给文本设置rztapLabel属性
    ///   - showFoldText: 超过行数之后，全部展开状态显示的文本  如”收起“  需要给文本设置rztapLabel属性
    ///   根据 tapAction返回的tapActionId, 可判断点击的是展开还是收起
    func set(attributedString: NSAttributedString?, maxLine: Int, maxWidth: CGFloat, isFold: Bool, showAllText: NSAttributedString?, showFoldText: NSAttributedString?) {
        self.rz.numberOfLines = 0
        guard let attr = attributedString, attr.length != 0 else {
            self.rz.attributedText = nil
            return
        }
        self.rz.attributedText = attr.rz.attributedStringBy(maxline: maxLine, maxWidth: maxWidth, isFold: isFold, showAllText: showAllText, showFoldText: showFoldText)
    }
    
    /// 设置富文本
    /// - Parameters:
    ///   - attributedString: 富文本
    ///   - maxLine: 最多行数
    ///   - maxWidth: 最大宽度
    ///   - lineBreakMode: 截取方式
    ///   - placeHolder: 超过后，截断的地方占位文本
    func set(attributedString: NSAttributedString?, maxLine: Int, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode, placeHolder: NSAttributedString?) {
        self.rz.numberOfLines = 0
        guard let attr = attributedString, attr.length != 0 else {
            self.rz.attributedText = nil
            return
        }
        self.rz.attributedText = attr.rz.attributedStringBy(maxline: maxLine, maxWidth: maxWidth, lineBreakMode: lineBreakMode, placeHolder: placeHolder)
    }
    /// 给UILabel添加富文本点击事件，给NSAttributedString添加"tapAction"属性即可
    /// 注意：lineBreakMode只能为0或者1，否则内部TextKit计算属性文本位置可能出错
    func tapAction(_ tapAction:((_ sender: Any, _ tapActionId: String, _ range: NSRange) -> Void)?) {
        let v = self.rz.activeColorful()
        v?.tapAction = tapAction
    }
}
