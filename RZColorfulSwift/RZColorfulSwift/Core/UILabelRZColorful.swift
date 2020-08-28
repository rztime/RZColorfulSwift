//
//  UILabel+RZColorful.swift
//  RZColorfulSwift
//
//  Created by ruozui on 2020/2/26.
//  Copyright © 2020 rztime. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 对Label的富文本支持
public extension UILabel {
    
    /// 设置富文本 （原内容将被清空）
    func rz_colorfulConfer(confer:ColorfulBlock?) -> Void {
        self.attributedText = nil
        self.rz_colorfulConferInsetToLocation(0, confer)
    }
    /// 在指定位置插入富文本
    func rz_colorfulConferInsetTo(position: RZConferInsertPosition, _ append:ColorfulBlock?) -> Void {
        var location = 0
        switch position {
        case .Default, .Cursor, .End:
            location = self.getEndLocation()
        case .Header:
            location = 0
        }
        self.rz_colorfulConferInsetToLocation(location, append)
    }
    
    /// 在指定位置处加入富文本
    func rz_colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlock?) -> Void {
        guard let confer = confer else { return }
        guard let conferrerColorful = NSAttributedString.rz_colorfulConfer(confer: confer), conferrerColorful.length > 0 else { return }
        let originAttr = self.attributedText ?? NSAttributedString.init()
        let attr = NSMutableAttributedString.init(attributedString:originAttr)
        var loc = max(location, 0)
        loc = min(loc, attr.length)
        attr.insert(conferrerColorful, at: loc)
        self.attributedText = attr
    }
    // 尾部的位置
    func getEndLocation() -> Int {
        return self.attributedText?.length ?? 0
    }
}

