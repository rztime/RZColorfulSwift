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
    
    /// 给UILabel添加富文本点击事件，给NSAttributedString添加".rztapLabel"属性即可
    func tapAction(_ tapAction:((_ label: UILabel, _ tapActionId: String, _ range: NSRange) -> Void)?) {
        let label = self.rz
        label.isUserInteractionEnabled = true
        var v: LabelFoldHeler? = self.rz.subviews.first(where: {$0.isKind(of: LabelFoldHeler.self)}) as? LabelFoldHeler
        if v == nil {
            _ = UILabel.rz_swizzledSelector
            v = .init(target: self.rz, tapAction: { label, text, range in
                tapAction?(label, text, range)
            })
            guard let v = v else { return }
            self.rz.addSubview(v)
            let v1 = v
            let left = NSLayoutConstraint.init(item: v1, attribute: .left, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint.init(item: v1, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint.init(item: v1, attribute: .right, relatedBy: .equal, toItem: label, attribute: .right, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint.init(item: v1, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 0)
            label.addConstraints([left, top, right, bottom])
        }
    }
}
