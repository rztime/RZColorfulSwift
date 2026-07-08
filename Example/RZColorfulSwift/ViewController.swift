//
//  ViewController.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import AVFoundation
import QuicklySwift
import UIKit
import RZColorfulSwift

class ViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: .plain)

    let items: [(String, UIViewController.Type)] = [
        ("基础用法", BaseUseViewController.self),
        ("文本、图片可点击", TextClickViewController.self),
        ("折叠、展开、换行方式等", TextLineModeViewController.self),
        ("HTML转富文本", HtmlViewController.self),
        ("Markdown解析为html", MDToHtmlViewController.self),
        ("测试", TestViewController.self),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        let items = self.items
        tableView
            .qnumberofRows { section in
                return items.count
            }
            .qheightForRow { indexPath in
                return 60
            }
            .qcell { tableView, indexPath in
                let cell: UITableViewCell =
                    tableView.dequeueReusableCell(withIdentifier: "cell")
                    ?? .init(style: .value1, reuseIdentifier: "cell")
                let item = items[indexPath.row]
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = "\(item.0)"
                cell.detailTextLabel?.text = "\(item.1)"
                return cell
            }
            .qdidSelectRow { [weak self] tableView, indexPath in
                tableView.deselectRow(at: indexPath, animated: false)
                let item = items[indexPath.row]
                let vc = item.1.init()
                vc.title = item.0
                self?.navigationController?.pushViewController(vc, animated: true)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
