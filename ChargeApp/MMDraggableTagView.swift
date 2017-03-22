//
//  MMDraggableTagView.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/14.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit
import SnapKit

let padding:CGFloat = 10

@objc protocol MMDraggableTagViewDelegate: NSObjectProtocol {
    func draggableTagView(_ draggableTagView:MMDraggableTagView, cellFor indexArray:[Int]) -> MMDraggableTagViewCell?
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, didSelectTag indexArray:[Int])
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, shouldSelectTag indexArray:[Int]) -> Bool
    
}

class MMDraggableTagView: UIView, MMDraggableTagViewCellDelegate, UITableViewDelegate {
    weak var delegate : MMDraggableTagViewDelegate?
    var selectedTags:[[Int]]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadData()
    }
    
    func reloadData() {
        drawTagView(at: [0])
        
        relocateTags()
    }
    
    func drawTagView(at indexArray:[Int]) {
        NSLog("indexArray: \(indexArray)")
        var indexArr = indexArray
        let cell = delegate?.draggableTagView(self, cellFor: indexArray)
        if (cell != nil) {
            
            if cell!.frame.size.width == 0 && cell!.titleLabel != nil && cell!.titleLabel!.text != nil{
                
                var titleSize = cell!.titleLabel!.text!.size(attributes: [NSFontAttributeName: UIFont.init(name: cell!.titleLabel!.font.fontName, size: cell!.titleLabel!.font.pointSize)!])
                titleSize.height += 10
                titleSize.width += 20
                cell!.frame = CGRect.init(x: cell!.frame.origin.x, y: cell!.frame.origin.y, width: titleSize.width, height: titleSize.height)
                
            }
            
            cell!.delegate = self
            self.addSubview(cell!)
            indexArr.append(0)
            self.drawTagView(at: indexArr)
        }else{
            if indexArr.count > 1 {
                indexArr.removeLast()
                indexArr[indexArr.count-1] += 1
                self.drawTagView(at: indexArr)
            }
        }
    }
    
    func relocateTags() {
        let tagViews = self.subviews
        var lastTagViewInThisLevel:UIView?
        var lastTagViewInLastLevel:UIView?
        var currentX = padding
        for tagView in tagViews {
            if lastTagViewInThisLevel == nil {
                if lastTagViewInLastLevel == nil {
                    tagView.snp.makeConstraints({ (make) in
                        make.top.equalTo(self).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    })
                }else{
                    tagView.snp.makeConstraints({ (make) in
                        make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    })
                }
            }else{
                tagView.snp.makeConstraints({ (make) in
                    if (currentX + tagView.frame.width + padding > self.frame.width) {
                        lastTagViewInLastLevel = lastTagViewInThisLevel
                        lastTagViewInThisLevel = tagView
                        currentX = padding
                        make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        make.left.equalTo(self).offset(padding)
                        if (tagView.frame.width + padding * 2 > self.frame.width) {
                            make.width.equalTo(self.frame.width - padding * 2)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = nil
                            lastTagViewInLastLevel = tagView
                            currentX = padding
                        }else{
                            make.width.equalTo(tagView.frame.width)
                            make.height.equalTo(tagView.frame.height)
                            lastTagViewInThisLevel = tagView
                            currentX = currentX + tagView.frame.width + padding
                        }
                    }else{
                        
                        if lastTagViewInLastLevel == nil {
                            make.top.equalTo(self).offset(padding)
                        }else{
                            make.top.equalTo(lastTagViewInLastLevel!.snp.bottom).offset(padding)
                        }
                        make.left.equalTo(lastTagViewInThisLevel!.snp.right).offset(padding)
                        make.width.equalTo(tagView.frame.width)
                        make.height.equalTo(tagView.frame.height)
                        lastTagViewInThisLevel = tagView
                        currentX = currentX + tagView.frame.width + padding
                    }
                })
                
            }
        }
    }

//MARK:- MMDraggableTagViewCellDelegate
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, didClickedIn indexArray: [Int]) {
        var shouldSelect = true
        if (delegate?.draggableTagView?(self, shouldSelectTag: indexArray) != nil) {
            shouldSelect = (delegate?.draggableTagView?(self, shouldSelectTag: indexArray))!
        }
        if shouldSelect {
            delegate?.draggableTagView?(self, didSelectTag: indexArray)
        }
    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, didDraggedFrom indexArray: [Int]) {
        NSLog("didDraggedFrom\(indexArray)")
    }
    
}
