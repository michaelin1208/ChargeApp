//
//  MMDraggableTagViewCell.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/15.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit

class MMDraggableTagViewCell: UIButton {
    
    var tagIndex : [Int]?
    
    convenience init(tagIndexArray:[Int]) {
        self.init(frame:CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.tagIndex = tagIndexArray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
