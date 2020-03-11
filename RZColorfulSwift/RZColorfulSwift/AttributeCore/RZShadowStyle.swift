//
//  RZShadowStyle.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public class RZShadowStyle: NSObject {
    var shadow = NSShadow.init()
    
    /// 阴影偏移量（范围）
    @discardableResult
    public func shadowOffset(_ shadowOffset:CGSize) -> Self {
        shadow.shadowOffset = shadowOffset
        return self
    }
    
    /// 模糊 值越大，越模糊
    @discardableResult
    public func shadowBlurRadius(_ shadowBlurRadius:CGFloat) -> Self {
        shadow.shadowBlurRadius = shadowBlurRadius
        return self
    }
    
    /// 阴影颜色
    @discardableResult
    public func shadowColor(_ shadowColor:UIColor) -> Self {
        shadow.shadowColor = shadowColor
        return self
    }
}
public class RZTextShadowStyle : RZShadowStyle {
    public weak var and : RZTextAttribute?
}

public class RZColorfulConferrerShadowStyle : RZShadowStyle {
    public weak var and : RZColorfulConferrer?
}
public class RZImageShadowStyle : RZShadowStyle {
    public weak var and : RZImageAttribute?
}
