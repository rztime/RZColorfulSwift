//
//  LabelFoldTestViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2022/1/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
//
class TestLable : UILabel {
    override func drawText(in rect: CGRect) {
        var rect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        rect.origin.x = 5
        rect.origin.y = 100
        rect.size.width = 300
        rect.size.height = 400
        super.drawText(in: rect)
    }
}


class LabelFoldTestViewController: UIViewController {
    let label = TestLable.init()
    let model  = LabelFoldModel.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(label)
        label.frame = .init(x: 10, y: 100, width: 400, height: 500)

        label.rz.tapAction { [weak self] (label, tapActionId, range) in
            if tapActionId == "all" {
                self?.model.isFold = false
            } else if tapActionId == "fold" {
                self?.model.isFold = true
            }
            self?.reload()
        }
        reload()
    }
    func reload() {
        label.rz.set(attributedString: model.attributedString, maxLine: 4, maxWidth: 300, isFold: model.isFold, showAllText: model.showAll, showFoldText: model.showFold)
    }
}
