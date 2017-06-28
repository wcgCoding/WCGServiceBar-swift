//
//  LDExtention.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/28.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
    
    public var viewX: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    public var viewY: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    //其他的篇幅原因就不在这里一一实现了
    
}
