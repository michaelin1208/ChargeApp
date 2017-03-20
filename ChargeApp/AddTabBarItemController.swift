//
//  AddTabBarItemController.swift
//  ChargeApp
//
//  Created by Michaelin on 2017/3/14.
//  Copyright © 2017年 Michaelin. All rights reserved.
//

import UIKit

class AddTabBarItemController: UIViewController, MMDraggableTagDataDelegate, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let draggableTagView = MMDraggableTagView.init(frame:CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        draggableTagView.backgroundColor = UIColor.yellow
        draggableTagView.delegate = self
        self.view.addSubview(draggableTagView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func subTitlesOfDraggableTag(in indexArray: [Int]) -> [NSString]? {
        if indexArray.count > 1 {
            return nil
        }else{
            return ["aa","bb","cc","dd","dsdgagd","dqwehqwegqwehqwegqwehqweqwehqwhd","dsdfd","ddd","ddddd","ddasdgaegwegawegawegawehawegawegwegawegwaeg","dsadgasdgd","dd","dsagwefawdgafd","dsdgd","d"]
        }
    }
    
    func didSelectTag(_ indexArray: [Int]) {
        NSLog("\(indexArray)")
    }
    
}
