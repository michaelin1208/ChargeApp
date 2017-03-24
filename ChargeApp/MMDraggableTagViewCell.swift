//
//  MMDraggableTagViewCell.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/15.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit

protocol MMDraggableTagViewCellDelegate: NSObjectProtocol {
    func draggableTagViewCell(_ draggableTagViewCell:MMDraggableTagViewCell, didClickedIn location:CGPoint)
    func draggableTagViewCell(_ draggableTagViewCell:MMDraggableTagViewCell, startDraggingFrom location:CGPoint)
    func draggableTagViewCell(_ draggableTagViewCell:MMDraggableTagViewCell, draggingFrom location:CGPoint)
    func draggableTagViewCell(_ draggableTagViewCell:MMDraggableTagViewCell, draggedFrom location:CGPoint)
}

class MMDraggableTagViewCell: UIView {
    weak var delegate : MMDraggableTagViewCellDelegate?
    var tagIndex : [Int]! = []
    
    var titleLabel : UILabel! = UILabel.init()
    var netTranslation : CGPoint!
    
    var isDragging = false
    
    override var frame: CGRect{
        didSet {
            let newFrame = frame
            super.frame = newFrame
            
            if titleLabel.text != nil {
                titleLabel.frame = CGRect(x: cellWidthPadding, y: cellHeightPadding, width: newFrame.size.width - cellWidthPadding * 2, height: newFrame.size.height - cellHeightPadding * 2)
            }
            
        }
    }
    
    convenience init(tagIndexArray:[Int]) {
        self.init(frame:CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.tagIndex = tagIndexArray
        
        self.addSubview(titleLabel)
        
//        self.addTarget(self, action: #selector(selfTouched(sender:)), for: .touchUpInside)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        netTranslation = CGPoint(x: 0, y: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        self.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        reloacteView()
    }
    
    func reloacteView() {
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(cellHeightPadding)
            make.left.equalTo(self).offset(cellWidthPadding)
            make.bottom.equalTo(self).offset(-cellHeightPadding)
            make.right.equalTo(self).offset(-cellWidthPadding)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func handleTapGesture(sender:UITapGestureRecognizer) {
        if self.superview != nil {
            delegate?.draggableTagViewCell(self, didClickedIn: sender.location(in: self.superview))
        }
    }
    
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        if self.superview != nil {
            if !isDragging {
                isDragging = true
                delegate?.draggableTagViewCell(self, startDraggingFrom: sender.location(in: self.superview))
            }
            let translation : CGPoint = sender.translation(in: self)
            //平移图片CGAffineTransformMakeTranslation
            self.transform = CGAffineTransform(translationX: netTranslation.x+translation.x, y: netTranslation.y+translation.y)
            
            delegate?.draggableTagViewCell(self, draggingFrom: sender.location(in: self.superview))
            
            
            if sender.state == UIGestureRecognizerState.ended{
                isDragging = false
                netTranslation.x = 0
                netTranslation.y = 0
                
                delegate?.draggableTagViewCell(self, draggedFrom: sender.location(in: self.superview))
                
            }
        }
    }
    
}
