//
//  NormalViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2022/7/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class NormalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let label = UITextView.init(frame: .zero)
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        label.font = .systemFont(ofSize: 20)
        label.isEditable = false
//        label.numberOfLines = 0
 
        label.rz.colorfulConfer { confer in
            confer.paragraphStyle?.textLists([.init(markerFormat: .box, options: 0)])
            confer.htmlString("<span>文本测试</span><a href=\"www.baidu.com\">百度一下</a>")?.font(.systemFont(ofSize: 17))
            confer.text("2222")?.font(.systemFont(ofSize: 20))
            confer.text("\n")?.font(.systemFont(ofSize: 20))
            confer.text("背景色")?.backgroundColor(.blue).font(.systemFont(ofSize: 20))
            confer.text("\n")?.font(.systemFont(ofSize: 20))
            confer.text("字间距")?.kern(3).font(.systemFont(ofSize: 20)).paragraphStyle?.textLists([.init(markerFormat: .check, options: 0)])
            confer.text("\n")?.font(.systemFont(ofSize: 20))
            confer.text("删除线")?.strikethroughStyle(.styleSingle).strikethroughColor(.red).font(.systemFont(ofSize: 20))
            confer.text("\n")
            confer.text("下划线")?.underlineStyle(.styleSingle).underlineColor(.red).font(.systemFont(ofSize: 20))
            confer.text("\n")
            confer.text("描边")?.textColor(.black).strokeWidth(3).strokeColor(.blue).font(.systemFont(ofSize: 20))  // 有问题
            confer.text("\n")
            confer.text("链接")?.link(URL.init(string: "baidu.com")).font(.systemFont(ofSize: 20))
            confer.text("\n")
            confer.text("基准线")?.font(.systemFont(ofSize: 20))
            confer.text("偏移")?.baselineOffset(10).font(.systemFont(ofSize: 20))
            confer.text("\n")
            confer.text("斜体")?.obliqueness(1).font(.systemFont(ofSize: 20)) // 不支持
            confer.text("\n")
            confer.text("扩展")?.expansion(2).font(.systemFont(ofSize: 20))  // 不支持
            confer.text("\n")
            confer.text("粗体粗体")?.font(.boldSystemFont(ofSize: 16)).font(.systemFont(ofSize: 20))
        }
        let text = label.attributedText?.rz.codingToCompleteHtml() ?? ""
        print("\n\n\n\n\(text)")
    }
      
}
