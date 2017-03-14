//
//  MMDraggableTagData.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/14.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import Foundation

class MMDraggableTagData {
    
    private var name:NSString!
    private var dataArray:NSMutableArray!
    
    convenience init() {
         self.init(tagName:"")
    }
    
    init(tagName:NSString!) {
        self.name = tagName
        self.dataArray = NSMutableArray.init()
    }
    
//    func addTagData(_ tagData:MMDraggableTagData) {
//        dataArray.add(tagData)
//    }
//    
//    func addTagData(_ tagData:MMDraggableTagData, at index:Int) {
//        dataArray.insert(tagData, at: index)
//    }
//    
//    func removeTagData(at index:Int) {
//        dataArray.removeObject(at: index)
//    }
//    
//    func subTagDatas() -> NSMutableArray {
//        return self.dataArray.mutableCopy() as! NSMutableArray
//    }
//
//    func setSubTagDatas(_ subTagDatas:NSMutableArray) {
//        dataArray = subTagDatas
//    }
    
    
}
