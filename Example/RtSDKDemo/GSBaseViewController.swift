//
//  GSBaseViewController.swift
//  RtSDKDemoSwift
//
//  Created by gensee on 2019/5/24.
//  Copyright © 2019年 gensee. All rights reserved.
//

import UIKit

let Width = UIScreen.main.bounds.size.width
let Height = UIScreen.main.bounds.size.height
let StatusBarHeight = 20
let NavigationBarHeight = 44
let TabbarHeight = 49
let StatusBarAndNavigationBarHeight = 64
let iPhone4_4s = (Width == 375 && Height == 667 ? true : false)
let iPhoneX = (Width == 375 && Height == 812 ? true : false)

class GSBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = true;
        // Do any additional setup after loading the view.
    }
    
    func createTagLabel(tagContent:String,top:CGFloat) -> UILabel {
        return self.createTagLabel(tagContent: tagContent, top: top, left: 15);
    }
    
    func createTagLabel(tagContent:String,top:CGFloat,left:CGFloat) -> UILabel {
        let label = UILabel.init(frame: CGRect.init(x: left, y: top, width: 100, height: 20))
        label.text = tagContent;
        label.textColor = UIColor.gray;
        label.font = UIFont.systemFont(ofSize: 12);
        label.sizeToFit();
        return label;
    }
    
    func createWhiteBGView(top t:CGFloat,count c:NSInteger) -> UIView {
        let view = UIView.init(frame: CGRect.init(x: CGFloat(0), y: t, width: Width, height: CGFloat(c*40)));
        view.backgroundColor = UIColor.white;
        let topline = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Width, height: 0.5));
        topline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.addSubview(topline)
        let botline = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Width, height: 0.5));
        botline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        botline.bottom = view.height
        view.addSubview(botline)
        
        for i in 1...c {
            let topline = UIView.init(frame: CGRect.init(x: Double(15), y: Double(i * 40) - 0.5, width: Double(Width - 15), height: 0.5));
            topline.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.addSubview(topline)
        }
        return view;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
