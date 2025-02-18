//
//  LabelTextClickedViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2022/1/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class LabelTextClickedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let label = UILabel.init()
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(100)
        }
        label.rz.tapAction { label, tapActionId, range in
            print("tapActionId:\(tapActionId) range:\(range)")
        }
        let text1 = "当地时间1月5日，针对俄方提出的停火建议，乌克兰总统泽连斯基在例行视频讲话中表示，他不认为在传统假期期间有必要进行停火。"
        let text2 = "当天早些时候，为庆祝传统假期，俄罗斯总统普京指示俄国防部长绍伊古，自莫斯科时间1月6日12时至1月7日24时在乌克兰全境接触线实行停火制度，他同时呼吁乌克兰方面也实施停火。（总台记者 王斌）"
        label.numberOfLines = 0
        let width = UIScreen.main.bounds.size.width - 30
        /// 截断时，添加...
        let truncate = NSAttributedString.rz.colorfulConfer { confer in
            confer.text("...")?.font(.systemFont(ofSize: 18)).textColor(.red)
        }
        label.rz.colorfulConfer { confer in
            confer.text(text1)?.paragraphStyle?.numberOfLines(2, maxWidth: width, truncate: truncate).lineBreakMode(.byTruncatingTail).paragraphSpacing(30).and?.font(.systemFont(ofSize: 18)).textColor(.gray)
            confer.text("\n")
            confer.text(text2)?.paragraphStyle?.paragraphSpacing(30).and?.font(.systemFont(ofSize: 18)).textColor(.gray)
            confer.text("\n")
            confer.text(text1)?.paragraphStyle?.paragraphSpacing(30).and?.font(.systemFont(ofSize: 18)).textColor(.gray)
            confer.text("\n")
            confer.text(text2)?.paragraphStyle?.numberOfLines(3, maxWidth: width).lineBreakMode(.byTruncatingMiddle).paragraphSpacing(30).and?.font(.systemFont(ofSize: 18)).textColor(.gray)
            confer.text("\n")
            confer.text(text2)?.paragraphStyle?.numberOfLines(4, maxWidth: width).lineBreakMode(.byTruncatingTail).paragraphSpacing(30).and?.font(.systemFont(ofSize: 18)).textColor(.gray)
            confer.text("\n")
            confer.text("可点击文本2")?.font(.systemFont(ofSize: 18)).textColor(.red).tapActionByLable("22222").paragraphStyle?.alignment(.center)
        }
    }
}
