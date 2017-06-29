//
//  WCGServiceBar.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/27.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit

protocol WCGServiceBarDeleage:NSObjectProtocol {
    func didClickKeyBoardBtn(_ bar: WCGServiceBar,btn: UIButton) -> Void
    func didSelected(_ section: NSInteger,row: NSInteger) -> Void
    
    func didShowKeyBoardBtn(_ bar: WCGServiceBar) -> Void
    func didHiddenKeyBoardBtn(_ bar: WCGServiceBar) -> Void
}

class WCGServiceBar: UIView,WCGServiceBtnViewDelegate {
    
    weak open var delegate: WCGServiceBarDeleage?    
    var menuArr: [String]?{
        willSet{
            if (menuArr != nil)&&(menuArr!.count > 0){
                for btn in self.menuBtns {
                    btn.removeFromSuperview()
                }
                self.menuBtns.removeAll()
                
                for line in self.lines{
                    line.removeFromSuperview()
                }
                self.lines.removeAll()
            }
        }
        didSet{
            if let menuArrV: [String] = menuArr{
                let sectionCount: Int = menuArrV.count
                
                let btnW: Float = (WCGScreenWidth - WCGServiceBar.keyBoradW - 16.0 - Float(sectionCount) * WCGServiceBar.lineW) / (Float(sectionCount) * 1.0)
                for (section,sectionTitle) in menuArrV.enumerated(){
                    let btnV: WCGServiceBtnView  = WCGServiceBtnView()
                    btnV.delegate = self
                    btnV.title = sectionTitle
                    btnV.tag = section + WCGServiceBar.incrementTag
                    
                    contentView.addSubview(btnV)
                    menuBtns.append(btnV)
                    
                    btnV.snp.makeConstraints({ (make) in
                        make.bottom.equalTo(contentView)
                        make.top.equalTo(self.topLine.snp.bottom)
                        
                        if (masnoryView == nil){
                            make.left.equalTo(contentView)
                        }else{
                            make.left.equalTo(masnoryView!.snp.right)
                        }
                        
                        make.width.equalTo(btnW)
                    })
                    masnoryView = btnV
                    
                    let menuName0 = "主\(section)子菜单0"
                    let menuName1 = "主\(section)子菜单1"
                    let menuName2 = "主\(section)子菜单2"
                    if section != 0 {
                        btnV.subMenus = [menuName0,menuName1,menuName2]
                    }
                    
                    if menuArrV.count - 1 > section{
                        let line = UIView()
                        line.backgroundColor = UIColor.lightGray
                        contentView.addSubview(line)
                        lines.append(line)
                        
                        line.snp.makeConstraints({ (make) in
                            make.top.bottom.equalTo(contentView)
                            make.left.equalTo(btnV.snp.right)
                            make.width.equalTo(WCGServiceBar.lineW)
                        })
                        masnoryView = line
                    }
                }
            }
//           self.setNeedsUpdateConstraints()
//           self.setNeedsLayout()
        }
    }

    
    //private
    static let keyBoradW: Float = 36.0
    static let lineW: Float = 0.5
    static let incrementTag: Int = 100
    lazy fileprivate var backGroupImageView: UIView = {
        UIView()
    }()
    
    lazy fileprivate var topLine: UIView = {
        UIView()
    }()
    
    lazy fileprivate var contentView: UIView = {
        UIView()
    }()
    
    lazy fileprivate var keyBoardBtn: UIButton = {
        UIButton(type: .custom)
    }()
    
    fileprivate var masnoryView: UIView?
    lazy fileprivate var menuBtns: [WCGServiceBtnView] = {
        [WCGServiceBtnView]()
    }()
    lazy fileprivate var lines: [UIView] = {
        [UIView]()
    }()
    fileprivate var currentBtnView: WCGServiceBtnView?
    
    
    public class func serviceBarWithMenuArr(_ menuArr: [String]?) -> WCGServiceBar{
        let bar: WCGServiceBar = WCGServiceBar()
        bar.backgroundColor = WCGColorGray
        bar.menuArr = menuArr
        return bar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backGroupImageView.backgroundColor = WCGColorGray
        addSubview(backGroupImageView)
        
        backGroupImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
        
        keyBoardBtn.setImage(UIImage(named: "keyBoardUp"), for: .normal)
        keyBoardBtn.addTarget(self, action: #selector(keyBoardClick(_:)), for: .touchUpInside)
        keyBoardBtn.setTitleColor(WCGColorBlack, for: .normal)
        keyBoardBtn.isOpaque = true
        addSubview(keyBoardBtn)
        
        keyBoardBtn.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(WCGServiceBar.keyBoradW)
        }
        
        let line: UIView = UIView()
        line.backgroundColor = UIColor.lightGray
        addSubview(line)
        lines.append(line)
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(keyBoardBtn.snp.right).offset(8)
            make.top.bottom.equalTo(self)
            make.width.equalTo(WCGServiceBar.lineW)
        }
        
        contentView.backgroundColor = UIColor.clear
        contentView.isOpaque = true
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.left.equalTo(line.snp.right)
        }
        
        topLine.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        contentView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
            make.width.equalTo(WCGScreenWidth)
            make.height.equalTo(WCGServiceBar.lineW)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func keyBoardClick(_ btn: UIButton){
        delegate?.didClickKeyBoardBtn(self, btn: btn)
    }
    
    /// MARK-:事件传递更正，panel超出父控件的依旧传递给panel
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view: UIView? = super.hitTest(point, with: event)
        
        if  view == nil {
            if let currentBtnViewV = currentBtnView{
                let panelP: CGPoint = (currentBtnViewV.panel.convert(point, from: self))
                if currentBtnViewV.panel.point(inside: panelP, with: event) {
                    return currentBtnView?.panel.hitTest(_:panelP, with:event)
                }
            }

        }
        
        return view
    }
    
    /// MARK-:public
    public func hiddenSubMenu(){
        guard (currentBtnView != nil) else {
            return
        }
        
        if (currentBtnView?.isShowPanel)! {
            currentBtnView!.hiddenPanel({ (isFinished) -> (Void) in
                //空操作
            })
        }
    }
    
    public func hiddenToolBar(){
        hiddenSubMenu()
        self.delegate?.didHiddenKeyBoardBtn(self)
    }
    
    public func showToolBar(){
        self.delegate?.didShowKeyBoardBtn(self)
    }
    
    /// MARK-:代理方法
    func didClickServiceBtnView(_ btnview: WCGServiceBtnView) {
        let section = btnview.tag - WCGServiceBar.incrementTag
        
        if (currentBtnView != nil) && (currentBtnView?.isShowPanel)!{
            currentBtnView?.hiddenPanel({ (finished) -> (Void) in
                if finished {
                    self.currentBtnView = btnview
                }
            })
        }
        
        if btnview.subMenus?.count == 0{
            delegate?.didSelected(section, row: 0)
            return
        }
        
        if !btnview.isShowPanel  {
            btnview.showPanel({ (finished) -> (Void) in
                if finished {
                    self.currentBtnView = btnview
                }
            })
        }
    }
    
    func didClickServiceBtnView(_ btnView: WCGServiceBtnView, subMenuRow row: NSInteger) {
        let section = btnView.tag - WCGServiceBar.incrementTag

        delegate?.didSelected(section, row: row)
        
    }
}
