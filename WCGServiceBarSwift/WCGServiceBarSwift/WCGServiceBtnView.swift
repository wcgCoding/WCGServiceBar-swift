//
//  WCGServiceBtnView.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/27.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit


protocol WCGServiceBtnViewDelegate:NSObjectProtocol {
    func didClickServiceBtnView(_  btnview: WCGServiceBtnView)
    func didClickServiceBtnView(_ btnView: WCGServiceBtnView, subMenuRow row:NSInteger)
}


class WCGServiceBtnView: UIView, WCGSerivcePanelDelegate{

    weak open var delegate: WCGServiceBtnViewDelegate?
    var topConstarint: ConstraintMakerEditable?
    lazy public var panel: WCGServiceBarPanel = {
        return  WCGServiceBarPanel()
    }()
    var isShowPanel : Bool = false
    var subMenus : [String]? {
        didSet{
            panel.subMenuArr = subMenus
            if (subMenus?.count)! > 0 {
                btn.setImage(UIImage.init(named: "chat_Menu"), for: .normal)
            }
            self.insertSubview(panel, at: 0)
            panel.snp.makeConstraints { (make) in
               self.topConstarint = make.top.equalToSuperview().offset(WCGServiceBarHeight)
                make.centerX.equalTo(self.snp.centerX)
                make.size.equalTo(CGSize.init(width: CGFloat(panel.panelWidth), height: CGFloat(panel.panelHeight)))
            }
        }
    }
    var title : String?{
        didSet{
            btn.setTitle(title, for: .normal)
        }
    }
    lazy fileprivate var backGroupImageView: UIView = {
        return UIImageView()
    }()
    lazy fileprivate var btn: UIButton = {
        return UIButton(type: UIButtonType.custom)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func createUI(){
        /// MARK-:初始化
        panel.delegate = self
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        btn.contentMode = .scaleAspectFit
        btn.titleLabel?.font = WCGFont.font(font: 15.0)
        btn.setTitleColor(WCGColorBlack, for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        
        backGroupImageView.backgroundColor = WCGColorGray
        
        /// MARK-:设置
        self.addSubview(backGroupImageView)
        backGroupImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
        
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
    }
    
    func btnClick(_ btn: UIButton) -> Void {
        delegate?.didClickServiceBtnView(self)
    }
    
    /// MARK-:WCGSerivcePanelDelegate
    func didClickPanel(_ panel:WCGServiceBarPanel,atRow row:NSInteger){
        delegate?.didClickServiceBtnView(self, subMenuRow: row)
        
        self.hiddenPanel { (isFinished) -> (Void) in
            
        }
//        self.hiddenPanel {[weak self](isFinished) -> (Void) in
//            
//            if let int: Int = self?.subMenus?.count {
//                print("\(int)")
//            }
//        }
    }
    
}

/// MARK-:给外界的事件
extension WCGServiceBtnView{
    
    public func changeShowStatus(_ completion: @escaping (_ finished : Bool,_ isShowed : Bool)->(Void)){
        if subMenus?.count == 0 {
            return
        }
        
        if isShowPanel {
            self.hiddenPanel({ (isFinished) -> (Void) in
                completion(isFinished,false)
            })
        }else{
            self.showPanel({ (isFinished) -> (Void) in
                completion(isFinished,true)
            })
        }
    }
    public func hiddenPanel(_ completion: @escaping (_ finished : Bool)->(Void)){
        if isShowPanel{
            self.panel.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(WCGServiceBarHeight)
            })
            UIView.animate(withDuration: WCGServiceBarAnimationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.isShowPanel = false
                completion(finished)
            })
        }
    }
    
    public func showPanel(_ completion: @escaping (_ finished: Bool)->(Void)){
        if !isShowPanel{
            self.panel.snp.updateConstraints({ (make) in
                make.top.equalTo(self).offset(-self.panel.panelHeight - 10)
            })
            UIView.animate(withDuration: WCGServiceBarAnimationDuration, animations: {
                self.layoutIfNeeded()
            }, completion: { (finished) in
                self.isShowPanel = true
                completion(finished)
            })
        }
    }
}
