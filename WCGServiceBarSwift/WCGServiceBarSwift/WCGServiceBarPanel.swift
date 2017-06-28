//
//  WCGServiceBarPanel.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/26.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import UIKit

protocol WCGSerivcePanelDelegate:NSObjectProtocol {
    func didClickPanel(_ panel:WCGServiceBarPanel,atRow row:NSInteger)
}

class WCGServiceBarPanel: UIView {
    static let btnH: Float = 44.0
    static let lineW: Float = 50.0
    static let increment: Int = 1000
    var panelWidth: Float = 0.0
    var panelHeight: Float = 0.0
    weak open var delegate: WCGSerivcePanelDelegate?
    var subMenuArr:[String]?{
        didSet{
            if self.subBtns.count > 0 {
                for (_,element) in self.subBtns.enumerated(){
                    element.removeFromSuperview()
                }
                self.subBtns.removeAll()
            }
            
            if let subTitleArr:[String] = subMenuArr{
                for (idx,subTitle) in subTitleArr.enumerated(){
                    let btn: UIButton = UIButton(type: .custom)
                    btn.titleLabel?.font = WCGFont.font(font: 14.0)
                    btn.setTitle(subTitle, for: .normal)
                    btn.tag = idx + WCGServiceBarPanel.increment
                    btn.setTitleColor(WCGColorBlack, for: .normal)
                    btn.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchUpInside)
                    self.contentView.addSubview(btn)
                    btn.snp.makeConstraints({ (make) in
                        make.height.equalTo(WCGServiceBarPanel.btnH)
                        
                        if (idx == 0){
                            make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
                        }else{
                            if (self.masnoryView != nil){
                                make.bottom.equalTo(self.masnoryView!.snp.top).offset(5)
                            }
                            
                        }
                        make.left.equalTo(self.contentView).offset(5)
                        make.right.equalTo(self.contentView).offset(-5)
                    })
                    
                    self.subBtns.append(btn)
                    self.masnoryView = btn
                    
                    if let menuArrNum: Int = self.subMenuArr?.count{
                        if menuArrNum - 1 > idx{
                            let line: UIView = UIView()
                            line.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0)
                            self.contentView.addSubview(line)
                            line.snp.makeConstraints({ (make) in
                                make.width.equalTo(WCGServiceBarPanel.lineW)
                                make.centerX.equalTo(self.contentView.snp.centerX)
                                make.height.equalTo(0.5)
                                make.bottom.equalTo(self.masnoryView!.snp.top)
                            })
                            self.subLines.append(line)
                        }
                    }
                    
                }
            }
            
            self.panelHeight = calpanelHeight(titleArr: subMenuArr)
            self.panelWidth = calpanelWidth(titleArr: subMenuArr)
        }
    }
    
    //fileprivate
    lazy fileprivate var contentView: UIView = {
        return UIView()
    }()
    lazy fileprivate var backImageView: UIImageView = {
        return UIImageView()
    }()
    lazy fileprivate var subBtns: [UIButton] = {
        return [UIButton]()
    }()
    lazy fileprivate var subLines: [UIView] = {
        return [UIView]()
    }()
    fileprivate var masnoryView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets.zero)
        }
        
        let image: UIImage? = UIImage(named: "chat_serviceMenuBG")
        backImageView.image = image
        contentView.addSubview(backImageView)
        
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(_ btn: UIButton){
        let row = btn.tag - WCGServiceBarPanel.increment
        delegate?.didClickPanel(self, atRow: row)
    }
}


extension String{
    /**
     *  获取字符串的宽度和高度
     */
    static func getTextRectSize(text:NSString,font:UIFont,size:CGSize) -> CGRect {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
}

extension WCGServiceBarPanel{
    
    public func calpanelWidth(titleArr: [String]?) -> Float{
        var width: Float = 0
        if titleArr != nil {
            for title in titleArr! {
                let rect: CGRect = String.getTextRectSize(text: title as NSString, font: WCGFont.font(font: 14.0), size: CGSize.init(width: 0, height: Int(WCGScreenWidth)))
                
                width = Float(rect.width)
            }
        }
        return width + 2.0 * 10
    }
    
    public func calpanelHeight(titleArr: [String]?) -> Float{
        var height: Float = 0
        if titleArr != nil {
            height = Float(titleArr!.count) * WCGServiceBarPanel.btnH
        }
        return height
    }
}
