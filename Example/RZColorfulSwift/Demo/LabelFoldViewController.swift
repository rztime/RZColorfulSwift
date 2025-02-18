//
//  LabelFoldViewController.swift
//  RZColorfulSwift_Example
//
//  Created by rztime on 2022/1/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class LabelFoldViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: .plain)
    var items: [LabelFoldModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var i = 100
        while i > 0 {
            items.append(.init())
            i -= 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension LabelFoldViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LabelFoldCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? LabelFoldCell) ?? LabelFoldCell.init(style: .value1, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        cell.label.rz.set(attributedString: item.attributedString, maxLine: 4, maxWidth: self.view.frame.size.width - 20, isFold: item.isFold, showAllText: item.showAll, showFoldText: item.showFold)
        cell.label.rz.tapAction { [weak self] (label, tapActionId, range) in
            let item = self?.items[label.tag]
            if tapActionId == "all" {
                item?.isFold = false
            } else if tapActionId == "fold" {
                item?.isFold = true
            }
            self?.tableView.reloadData()
        }
        cell.label.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class LabelFoldModel {
    var isFold = true
    let attributedString = NSAttributedString.rz.colorfulConfer { confer in
        let text =
        """
        “中国人的饭碗任何时候都要牢牢端在自己手中，饭碗主要装中国粮”“保证粮食安全，大家都有责任，党政同责要真正见效”，习近平总书记强调指出。
        民为国基，谷为民命。粮食问题不仅要算“经济账”，更要算“政治账”；不仅要顾当前，还要看长远。
        \n今年，我国粮食生产喜获丰收，产量保持在1.3万亿斤以上，为开新局、应变局、稳大局发挥重要作用。但也要看到，当前我国粮食需求刚性增长，资源环境约束日益趋紧
        \n粮食增面积、提产量的难度越来越大。全球新冠肺炎疫情持续蔓延，气候变化影响日益加剧，保障粮食供应链稳定难度加大。
        """
        confer.text(text)?.textColor(.black).font(.systemFont(ofSize: 16))
    }
    let showAll = NSAttributedString.rz.colorfulConfer { confer in
        confer.text("...显示全文")?.textColor(.red).font(.systemFont(ofSize: 16)).tapActionByLable("all")
    }
    let showFold = NSAttributedString.rz.colorfulConfer { confer in
        confer.text("...折叠")?.textColor(.red).font(.systemFont(ofSize: 16)).tapActionByLable("fold")
    }
}

class LabelFoldCell: UITableViewCell {
    var label = UILabel.init()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.selectionStyle = .none
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
