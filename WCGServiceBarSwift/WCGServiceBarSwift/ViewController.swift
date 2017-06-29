//
//  ViewController.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/26.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WCGServiceBarDeleage {
    
    var isServiceMenuOPEN: Bool = true{
        didSet{
            let serviceBarOffset: Float = Float(isServiceMenuOPEN ? 0.0 : WCGServiceBarHeight)
            let chatToolbarOffset: Float = Float(isServiceMenuOPEN ? WCGServiceBarHeight : 0.0)
                        
            UIView.animate(withDuration: WCGServiceBarAnimationDuration, animations: { 
                self.serviceBar.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(self.view).offset(serviceBarOffset)
                })
                
                self.chatToolBar.snp.updateConstraints { (make) in
                    make.bottom.equalTo(self.view).offset(chatToolbarOffset)
                }
                print("当前的线程是:\(Thread.current)")
                self.view.layoutIfNeeded()
                
            }) { (isFinished) in
                guard isFinished else {
                    return
                }
                if !self.isServiceMenuOPEN {
                    self.serviceBar.hiddenToolBar()
                }else{
                    self.serviceBar.showToolBar()
                }
            }
        }
    }

    
    lazy fileprivate var chatToolBar: UIView = {
        var toolBar = UIView()
        toolBar.backgroundColor = WCGColorRGB.color(r: 243, g: 243, b: 243)
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "keyMenu"), for: .normal)
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        toolBar.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.left.equalTo(toolBar.snp.left).offset(8)
            make.centerY.equalTo(toolBar.snp.centerY)
            make.size.equalTo(CGSize(width: 36, height: 36))
        })
        return toolBar
    }()
    
    lazy fileprivate var serviceBar: WCGServiceBar = {
        var bar = WCGServiceBar.serviceBarWithMenuArr(["主菜单0","主菜单1","主菜单2"])
        bar.delegate = self
        return bar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(chatToolBar)
        chatToolBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(WCGServiceBarHeight)
        }

        self.view.addSubview(serviceBar)
        serviceBar.snp.makeConstraints({ (make) in
            make.height.equalTo(WCGServiceBarHeight)
            make.bottom.equalTo(self.view)
            make.left.right.equalTo(self.view)
        })
        
    }

    func btnClickAction() {
        isServiceMenuOPEN = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        serviceBar.hiddenSubMenu()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// MARK-:代理
    func didClickKeyBoardBtn(_ bar: WCGServiceBar, btn: UIButton) {
        isServiceMenuOPEN = false
    }
    
    func didSelected(_ section: NSInteger, row: NSInteger) {
        print("didSelected---> section\(section), row\(row)")
    }

    func didHiddenKeyBoardBtn(_ bar: WCGServiceBar) {
        
    }
    
    func didShowKeyBoardBtn(_ bar: WCGServiceBar) {
        
    }
}

