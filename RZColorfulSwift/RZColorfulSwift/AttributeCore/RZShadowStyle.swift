//
//  RZShadowStyle.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

class RZShadowStyle: NSObject {
    var shadow = NSShadow.init()
    
    /// 阴影偏移量（范围）
    @discardableResult
    func shadowOffset(_ shadowOffset:CGSize) -> Self {
        shadow.shadowOffset = shadowOffset
        return self
    }
    
    /// 模糊 值越大，越模糊
    @discardableResult
    func shadowBlurRadius(_ shadowBlurRadius:CGFloat) -> Self {
        shadow.shadowBlurRadius = shadowBlurRadius
        return self
    }
    
    /// 阴影颜色
    @discardableResult
    func shadowColor(_ shadowColor:UIColor) -> Self {
        shadow.shadowColor = shadowColor
        return self
    }
}
class RZTextShadowStyle : RZShadowStyle {
    weak var and : RZTextAttribute?
}

class RZColorfulConferrerShadowStyle : RZShadowStyle {
    weak var and : RZColorfulConferrer?
}
