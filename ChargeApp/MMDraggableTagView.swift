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

protocol MMDraggableTagDataDelegate: class {
    func draggableTagView(_ draggableTagView:MMDraggableTagView, subTitlesFor indexArray:[Int]) -> [NSString]?
    func draggableTagView(_ draggableTagView:MMDraggableTagView, didSelectTag indexArray:[Int])
    func draggableTagView(_ draggableTagView:MMDraggableTagView, colorFor indexArray:[Int]) -> UIColor
}

class MMDraggableTagView: UIView {
    weak var delegate : MMDraggableTagDataDelegate?
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
        let titles = delegate?.draggableTagView(self, subTitlesFor: indexArray)
        if (titles != nil) {
            var i = 0
            for title in titles! {
                let newIndexArray = NSMutableArray.init(array: indexArray).adding(i)
                NSLog("title \(title)")
                let cell = MMDraggableTagViewCell.init(tagIndexArray: newIndexArray as! [Int])
                cell.setTitle(title as String, for: .normal)
                cell.layer.masksToBounds = true
                cell.layer.borderColor = UIColor.blue.cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 3;
                
                if cell.titleLabel != nil {
                    var titleSize = title.size(attributes: [NSFontAttributeName: UIFont.init(name: cell.titleLabel!.font.fontName, size: cell.titleLabel!.font.pointSize)!])
                    titleSize.height += 10
                    titleSize.width += 20
                    cell.frame = CGRect.init(x: cell.frame.origin.x, y: cell.frame.origin.y, width: titleSize.width, height: titleSize.height)
                }
                
                cell.backgroundColor = UIColor.green
                self.addSubview(cell)
                
                i += 1
                drawTagView(at: newIndexArray as! [Int])
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
    
}
