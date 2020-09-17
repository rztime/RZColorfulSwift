//
//  RZShadowStyle.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/12.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit

public struct RZShadowStyle<T: AnyObject> {
    public var shadow = NSShadow.init()
    public init(_ target: T?) {
        and = target
    }
    /// 连接词
    public weak var and: T?
    /// 阴影偏移量（范围）
    @discardableResult
    public func shadowOffset(_ shadowOffset: CGSize) -> Self {
        shadow.shadowOffset = shadowOffset
        return self
    } 
    /// 模糊 值越大，越模糊
    @discardableResult
    public func shadowBlurRadius(_ shadowBlurRadius: CGFloat) -> Self {
        shadow.shadowBlurRadius = shadowBlurRadius
        return self
    }
    /// 阴影颜色
    @discardableResult
    public func shadowColor(_ shadowColor: UIColor) -> Self {
        shadow.shadowColor = shadowColor
        return self
    }
}
