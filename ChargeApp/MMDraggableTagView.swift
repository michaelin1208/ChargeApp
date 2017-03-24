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
let cellHeightPadding:CGFloat = 5
let cellWidthPadding:CGFloat = 10

@objc protocol MMDraggableTagViewDelegate: NSObjectProtocol {
    func draggableTagView(_ draggableTagView:MMDraggableTagView, cellFor indexArray:[Int]) -> MMDraggableTagViewCell?
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, didSelectTag indexArray:[Int])
    @objc optional func draggableTagView(_ draggableTagView:MMDraggableTagView, shouldSelectTag indexArray:[Int]) -> Bool
    
}

class MMDraggableTagView: UIView, MMDraggableTagViewCellDelegate {
    weak var delegate : MMDraggableTagViewDelegate?
    var selectedTags:[[Int]]?
    var cells:[MMDraggableTagViewCell] = []
    var draggingCell:MMDraggableTagViewCell?
    var originalCell:MMDraggableTagViewCell?
    var isFirstLoad = true
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLoad {
            isFirstLoad = false
            reloadData()
        }
    }
    
    func reloadData() {
        cells.removeAll()
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
                cell!.titleLabel!.frame = CGRect(x: 10, y: 5, width: titleSize.width, height: titleSize.height)
                titleSize.height += cellHeightPadding * 2
                titleSize.width += cellWidthPadding * 2
                cell!.frame = CGRect.init(x: cell!.frame.origin.x, y: cell!.frame.origin.y, width: titleSize.width, height: titleSize.height)
                
            }
            
            cell!.delegate = self
            self.addSubview(cell!)
            
            cells.append(cell!)
            
            
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
        var lastTagViewInThisLevel:UIView?
        var lastTagViewInLastLevel:UIView?
        var currentX = padding
        for tagView in cells {
            if draggingCell != nil {
                if draggingCell == tagView {
                    NSLog("I am dragging, skip")
                    return
                }
            }
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
    
    func replaceObject(_ originCell:MMDraggableTagViewCell, inCellsByObject targetCell:MMDraggableTagViewCell) -> Int? {
        let replaceIndex = cells.index(of: originCell)
        if replaceIndex != nil {
            cells.insert(targetCell, at: replaceIndex!)
            cells.remove(at: replaceIndex! + 1)
            return replaceIndex
        }
        return nil
    }

//MARK:- MMDraggableTagViewCellDelegate
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, didClickedIn location:CGPoint) {
        var shouldSelect = true
        if (delegate?.draggableTagView?(self, shouldSelectTag: draggableTagViewCell.tagIndex) != nil) {
            shouldSelect = (delegate?.draggableTagView?(self, shouldSelectTag: draggableTagViewCell.tagIndex))!
        }
        if shouldSelect {
            delegate?.draggableTagView?(self, didSelectTag: draggableTagViewCell.tagIndex)
        }
    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, startDraggingFrom location:CGPoint) {
        NSLog("start dragging")
        originalCell = MMDraggableTagViewCell.init(tagIndexArray: draggableTagViewCell.tagIndex)
        originalCell!.backgroundColor = UIColor.darkGray   //TODO: this darkgray is used to test
        //originalCell!.titleLabel.text = "test test test"
        
        //originalCell!.layer.masksToBounds = true
        //originalCell!.layer.borderColor = UIColor.blue.cgColor
        //originalCell!.layer.borderWidth = 1
        //originalCell!.layer.cornerRadius = 3;
        
        originalCell!.frame = draggableTagViewCell.frame
        
        self.addSubview(originalCell!)
        NSLog("frame \(originalCell!.frame)")
        let replaceIndex = replaceObject(draggableTagViewCell, inCellsByObject: originalCell!)
        NSLog("replaceIndex \(replaceIndex)")
        
        draggingCell = draggableTagViewCell
        
        self.bringSubview(toFront: draggableTagViewCell)
    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, draggingFrom location:CGPoint) {
        NSLog("\(location) is dragging")
    }
    
    func findInsertPosition(_ cells:[UIView], with location:CGPoint) -> Int {
        var index = 0
        for tempC in cells {
            let tempCell = tempC as! MMDraggableTagViewCell
            
            if location.y > tempCell.frame.origin.y && location.y < tempCell.frame.origin.y + tempCell.frame.size.height {
                //if index {
                //
               // }
            }
            
            index += 1
            //TODO: check is it leave self orignal frame, or insert into others' gap, or in other cell's front
            
            
            
            
            //            if tempCell.tagIndex! != draggableTagViewCell.tagIndex! {
            //                let intersection = tempCell.frame.intersection(draggableTagViewCell.frame)
            //                if !intersection.isNull {
            //                    if tempCell.frame.size.width/2 < intersection.size.width || tempCell.frame.size.height/2 < intersection.size.height || draggableTagViewCell.frame.size.width/2 < intersection.size.width || draggableTagViewCell.frame.size.height/2 < intersection.size.height {
            //                        NSLog("Do something.")
            //                    }
            //                }
            //            }else{
            //                NSLog("Do not need to compare with myself")
            //            }
        }
        return 5;

    }
    
    func draggableTagViewCell(_ draggableTagViewCell: MMDraggableTagViewCell, draggedFrom location:CGPoint) {
        NSLog("dragging finished")
        
        if originalCell != nil && draggingCell != nil {
            
            self.draggingCell!.frame = self.originalCell!.frame
            UIView.animate(withDuration: 0.2, animations: {
                self.draggingCell!.transform = self.originalCell!.transform
            })
            
            
            let replaceIndex = replaceObject(originalCell!, inCellsByObject: draggingCell!)
            NSLog("replaceIndex \(replaceIndex)")
            originalCell!.removeFromSuperview()
            draggingCell = nil
        }
        
    }
    
}
