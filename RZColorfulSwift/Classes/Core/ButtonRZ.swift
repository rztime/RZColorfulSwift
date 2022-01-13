//
//  ButtonRZ.swift
//  RZColorfulSwift
//
//  Created by rztime on 2021/3/26.
//

import UIKit

public extension RZColorfulSwiftBase where T: UIButton {
    func colorfulConfer(confer: ColorfulBlockRZ?, for state: UIControl.State) {
        guard let confer = confer else {
            self.rz.setAttributedTitle(nil, for: state)
            return
        }
        let attr = NSAttributedString.rz.colorfulConfer(confer: confer)
        self.rz.setAttributedTitle(attr, for: state)
    }
}
