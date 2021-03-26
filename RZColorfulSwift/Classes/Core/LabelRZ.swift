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
    func colorfulConfer(confer:ColorfulBlockRZ?) -> Void {
        self.rz.attributedText = nil
        self.colorfulConferInsetToLocation(0, confer)
    }
    /// 在指定位置插入富文本
    func colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append:ColorfulBlockRZ?) -> Void {
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
    func colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlockRZ?) -> Void {
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

public extension UILabel {
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConfer(confer:ColorfulBlockRZ?) instead")
    func rz_colorfulConfer(confer:ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConfer(confer: confer)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append:ColorfulBlockRZ?) instead")
    func rz_colorfulConferInsetTo(position: ConferInsertPositionRZ, _ append:ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConferInsetTo(position: position, append)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlockRZ?) instead")
    func rz_colorfulConferInsetToLocation(_ location:Int, _ confer:ColorfulBlockRZ?) -> Void {
        self.rz.colorfulConferInsetToLocation(location, confer)
    }
    @available(iOS, introduced: 7.0, deprecated: 7.0, message: "Use .rz.getEndLocation() instead")
    func getEndLocation() -> Int {
        return self.rz.getEndLocation()
    }
}

