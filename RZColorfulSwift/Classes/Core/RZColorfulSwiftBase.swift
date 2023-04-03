//
//  RZColorfulSwiftBase.swift
//  RZColorfulSwift
//
//  Created by rztime on 2021/3/12.
//

import UIKit

public struct RZColorfulSwiftBase<T> {
    public let rz: T
    public init(rz: T) {
        self.rz = rz
    }
}

public protocol RZColorfulSwiftProtocol {}
public extension RZColorfulSwiftProtocol {
    static var rz: RZColorfulSwiftBase<Self>.Type {
        get { return RZColorfulSwiftBase<Self>.self }
        set { }
    }
    var rz: RZColorfulSwiftBase<Self> {
        get { return RZColorfulSwiftBase.init(rz: self) }
        set { }
    }
}

extension UIView: RZColorfulSwiftProtocol { }

extension NSAttributedString: RZColorfulSwiftProtocol { }
extension UIColor: RZColorfulSwiftProtocol { }
extension String: RZColorfulSwiftProtocol { }

public typealias RZDidTapTextView = (_ tapObj: String, _ textView: UITextView) -> Bool
public typealias ColorfulBlockRZ = ((_ confer: ColorfulConferrerRZ) -> Void)
public typealias ColorfulAttrBlockRZ = ((_ attr: TextAttributeRZ) -> Void)
