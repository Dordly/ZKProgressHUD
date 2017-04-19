//
//  ViewController.swift
//  Demo
//
//  Created by 王文壮 on 2017/3/10.
//  Copyright © 2017年 WangWenzhuang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var screenWidth: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    let cellIdentifier = "cell"
    
    lazy var actionTexts = ["show", "show with status", "showProgress", "shwoImage", "showImage with status", "showInfo", "showSuccess", "showError", "showMessage"]
    lazy var headerTexts = ["遮罩样式", "加载样式", "方法"]
    
    var progressValue: CGFloat = 0
    
    lazy var maskStyles = [(text: "visible", maskStyle: ZKProgressHUDMaskStyle.visible), (text: "hide", maskStyle: ZKProgressHUDMaskStyle.hide)]
    var currentMaskStyleIndex = 0
    
    lazy var animationStyles = [(text: "circle", animationStyle: ZKProgressHUDAnimationStyle.circle), (text: "system", animationStyle: ZKProgressHUDAnimationStyle.system)]
    var currentAnimationStyleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.title = "ZKProgressHUD"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.tableView.tableHeaderView = {
            let gifView = ZKGifView()
            gifView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 400)
            gifView.showGIFImageWithLocalName(name: "timg")
            return gifView
        }()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }
        return self.actionTexts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        if indexPath.section == 0 {
            cell?.textLabel?.text = self.maskStyles[currentMaskStyleIndex].text
            cell?.accessoryType = .disclosureIndicator
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = self.animationStyles[self.currentAnimationStyleIndex].text
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.textLabel?.text = self.actionTexts[indexPath.row]
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            self.pushSelectView(tag: 0, title: "选择遮罩样式", data: self.maskStyles)
        } else if indexPath.section == 1 {
            self.pushSelectView(tag: 1, title: "选择加载样式", data: self.animationStyles)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                ZKProgressHUD.show()
                ZKProgressHUD.dismiss(3)
            } else if indexPath.row == 1 {
                ZKProgressHUD.show("正在拼命的加载中🏃🏃🏃")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                    DispatchQueue.main.async {
                        ZKProgressHUD.dismiss()
                        ZKProgressHUD.showInfo("加载完成😁😁😁")
                    }
                })
            } else if indexPath.row == 2 {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.timerHandler(timer:)), userInfo: nil, repeats: true)
            } else if indexPath.row == 3 {
                ZKProgressHUD.showImage(UIImage(named: "image"))
            } else if indexPath.row == 4 {
                ZKProgressHUD.showImage(image: UIImage(named: "image"), status: "图片会自动消失😏😏😏")
            } else if indexPath.row == 5 {
                ZKProgressHUD.showInfo("Star 一下吧😙😙😙")
            } else if indexPath.row == 6 {
                ZKProgressHUD.showSuccess("操作成功👏👏👏")
            } else if indexPath.row == 7 {
                ZKProgressHUD.showError("出现错误了😢😢😢")
            } else if indexPath.row == 8 {
                ZKProgressHUD.showMessage("开始使用 ZKProgressHUD 吧")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTexts[section]
    }
    
    func timerHandler(timer: Timer) {
        if self.progressValue > 100 {
            if timer.isValid {
                timer.invalidate()
            }
            ZKProgressHUD.dismiss()
            self.progressValue = 0
        } else {
            self.progressValue += 1
            ZKProgressHUD.showProgress(self.progressValue / 100)
        }
    }
    
    func pushSelectView(tag: Int, title: String, data: [Any]) {
        let selectViewController = SelectViewController()
        selectViewController.tag = tag
        selectViewController.title = title
        selectViewController.data = data
        selectViewController.delegate = self
        self.navigationController?.pushViewController(selectViewController, animated: true)
    }
}

extension ViewController: SelectViewControllerDelegate {
    func selected(selectViewController: SelectViewController, selectIndex: Int) {
        if selectViewController.tag == 0 {
            self.currentMaskStyleIndex = selectIndex
            ZKProgressHUD.setMaskStyle(self.maskStyles[self.currentMaskStyleIndex].maskStyle)
        } else {
            self.currentAnimationStyleIndex = selectIndex
            ZKProgressHUD.setAnimationStyle(self.animationStyles[self.currentAnimationStyleIndex].animationStyle)
        }
        self.tableView.reloadData()
    }
    func tableViewCellValue(selectViewController: SelectViewController, obj: Any) -> (text: String, isCheckmark: Bool) {
        if selectViewController.tag == 0 {
            let maskStyle = obj as! (text: String, maskStyle: ZKProgressHUDMaskStyle)
            return (text: maskStyle.text, isCheckmark: maskStyle.text == self.maskStyles[self.currentMaskStyleIndex].text)
        } else {
            let animationStyle = obj as! (text: String, animationStyle: ZKProgressHUDAnimationStyle)
            return (text: animationStyle.text, isCheckmark: animationStyle.text == self.animationStyles[self.currentAnimationStyleIndex].text)
        }
    }
}

