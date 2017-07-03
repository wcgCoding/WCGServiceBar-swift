//
//  WCGServiceBarPCH.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/27.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import UIKit

enum colorParameter {
    case r
    case g
    case b
}


struct WCGColorRGB {
    var r: Float
    var g: Float
    var b: Float
    
    let color: UIColor
    
    init() {
        self.init(r: 0,g: 0,b: 0)
    }
    init(r: Float,g: Float,b: Float) {
        self.r = r
        self.g = g
        self.b = b
        color = UIColor.init(colorLiteralRed: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
    }
    
    
//    subscript(index: colorParameter)->{
//    
//    }
}

let WCGServiceBarHeight: Float = 46.0
let WCGScreenWidth: Float = Float(UIScreen.main.bounds.size.width)
let WCGScreenHeight: Float = Float(UIScreen.main.bounds.size.height)
let WCGColorBlack: UIColor = UIColor.black
let WCGServiceBarAnimationDuration = 0.15

class WCGFont{
   class public func font(font: Float) -> UIFont{
        return UIFont.systemFont(ofSize: CGFloat(font))
    }
}

let WCGColorGray: UIColor = WCGColorRGB(r: 243, g: 243, b: 243).color
