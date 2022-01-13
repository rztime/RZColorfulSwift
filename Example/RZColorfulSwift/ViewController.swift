//
//  ViewController.swift
//  RZColorfulSwift
//
//  Created by 若醉 on 2018/7/9.
//  Copyright © 2018年 rztime. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    let items:[(String, UIViewController.Type)] = [("富文本", TestViewController.self),
                                                   ("UILabel 可点击文本", LabelTextClickedViewController.self),
                                                   ("可折叠Label in TableView", LabelFoldViewController.self),
                                                   ("可折叠Lbale", LabelFoldTestViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tovc() {
        let vc = TestViewController.init();
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? .init(style: .value1, reuseIdentifier: "cell")
        let item = items[indexPath.row]
        cell.textLabel?.text = "\(item.0)"
        cell.detailTextLabel?.text = "\(item.1)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        self.navigationController?.pushViewController(item.1.init(), animated: true)
    }
}

