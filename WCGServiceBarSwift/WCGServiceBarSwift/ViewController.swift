//
//  ViewController.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/26.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WCGServiceBarDeleage {

    var serviceBar: WCGServiceBar?
    var bottomConstraint: ConstraintMakerEditable?
    
    @IBOutlet weak var chatToolBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        chatToolBar.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(46)
            self.bottomConstraint = make.bottom.equalTo(self.view)
        }
        
        serviceBar = WCGServiceBar.serviceBarWithMenuArr(["主菜单0","主菜单1","主菜单2"])
        serviceBar?.delegate = self
        self.view.addSubview(serviceBar!)
        serviceBar?.snp.makeConstraints({ (make) in
            make.height.equalTo(WCGServiceBarHeight)
            make.left.right.bottom.equalTo(self.view)
        })
        
        
    }

    @IBAction func btnClickAction(_ sender: Any) {
        self.bottomConstraint?.offset(CGFloat(WCGScreenHeight))
        UIView.animate(withDuration: WCGServiceBarAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
        serviceBar?.showToolBar()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        serviceBar?.hiddenSubMenu()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /// MARK-:代理
    func didClickKeyBoardBtn(_ bar: WCGServiceBar, btn: UIButton) {
        serviceBar?.hiddenToolBar()
        self.bottomConstraint?.offset(CGFloat(WCGScreenHeight - WCGServiceBarHeight))

        UIView.animate(withDuration: WCGServiceBarAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            
        }
    }
    
    func didSelected(_ section: NSInteger, row: NSInteger) {
        print("didSelected---> section\(section), row\(row)")
    }

    func didHiddenKeyBoardBtn(_ bar: WCGServiceBar) {
        
    }
    
    func didShowKeyBoardBtn(_ bar: WCGServiceBar) {
        
    }
}

