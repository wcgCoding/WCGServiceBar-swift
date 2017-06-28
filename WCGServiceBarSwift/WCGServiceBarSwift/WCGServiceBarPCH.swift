//
//  WCGServiceBarPCH.swift
//  WCGServiceBarSwift
//
//  Created by 吴朝刚 on 2017/6/27.
//  Copyright © 2017年 吴朝刚. All rights reserved.
//

import Foundation
import UIKit

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
class WCGColorRGB{
    class public func color(r:Float,g:Float,b:Float) -> UIColor{
       return UIColor.init(colorLiteralRed: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
    }
}

let WCGColorGray: UIColor = WCGColorRGB.color(r: 243, g: 243, b: 243)
