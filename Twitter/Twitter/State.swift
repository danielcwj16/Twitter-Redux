//
//  State.swift
//  Twitter
//
//  Created by Weijie Chen on 4/23/17.
//  Copyright © 2017 Weijie Chen. All rights reserved.
//

import Foundation
import UIKit

class State : NSObject {
    static var _currentMenuItem : Int = 0  // 0 : Profile View 1 : Timeline View 2: Mentions View
    
    class var currentMenuItem : Int{
        get {
            return self._currentMenuItem
        }
        set(menuItem) {
            self._currentMenuItem = menuItem
        }
    }
}
