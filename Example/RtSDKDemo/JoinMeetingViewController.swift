//
//  ViewController.swift
//  RtSDKDemo
//
//  Created by gensee on 2019/11/15.
//  Copyright © 2019年 gensee. All rights reserved.
//

import UIKit
import RtSDK
import Foundation

enum textType {
    case domain
    case service
    case port
    case nickname
    case password
    
    var key : String {
        switch self {
        case .domain: return "RtSDKDemo.param.domain"
        case .service: return "RtSDKDemo.param.service"
        case .port: return "RtSDKDemo.param.port"
        case .nickname: return "RtSDKDemo.param.nickname"
        case .password: return "RtSDKDemo.param.password"
        }
    }
    
    var title : String {
        switch self {
        case .domain: return "域名"
        case .service: return "服务类型"
        case .port: return "端口号"
        case .nickname: return "姓名"
        case .password: return "会议密码"
      
        }
    }
}


class JoinMeetingViewController : GSBaseViewController,UIScrollViewDelegate {
    var textTypes:[textType]!
    var scrollview:UIScrollView!
    var fieldViewsDic = [String:UIView]()
    var servicesgment : UISegmentedControl!
    var startBtn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseConfig()
        self.title = "网络会议SDK"
        self.textTypes = [.domain,.port,.nickname,.password];
        //        UIView.additionaliPhoneXTopSafeHeight()
        self.scrollview = UIScrollView.init(frame: CGRect.init(x: 0, y: 64 + UIView.additionaliPhoneXTopSafeHeight, width: Width, height: Height - 64 - 50 - UIView.additionaliPhoneXTopSafeHeight - UIView.additionaliPhoneXBottomSafeHeight))
        self.scrollview.alwaysBounceVertical = true;
        self.scrollview.delegate = self;
        self.view.addSubview(self.scrollview)
        
        var top : CGFloat = 10
        let label = self.createTagLabel(tagContent: "会议参数设置", top: top)
        self.scrollview.addSubview(label)
        top = label.bottom + 5;
        
        let whiteBGView : UIView = self.createWhiteBGView(top: top, count: 4)
        top = whiteBGView.bottom + 10
        self.scrollview.addSubview(whiteBGView)
        
        for (i,type) in self.textTypes.enumerated() {
            whiteBGView.addSubview(self.createFieldView(type: type,index: i));
        }

        //        self.scrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag
        //        let servicelb = self.createTagLabel(tagContent: "站点类型", top: top)
        //        self.scrollview.addSubview(servicelb)
        //        top = servicelb.bottom + 5
        //        self.servicesgment = UISegmentedControl.init(items: ["Webcast","Training"])
        //        self.servicesgment.frame = CGRect.init(x: 15, y: top, width: (Width - 60)/2, height: 28)
        //        self.servicesgment.selectedSegmentIndex = 0
        //        self.scrollview.addSubview(self.servicesgment)
        
        startBtn = UIButton.init(frame: CGRect.init(x: 35, y: self.scrollview.y + self.scrollview.height + 5, width: (Width - 60), height: 40))
        startBtn.setTitle("进入会议", for: .normal)
        startBtn.layer.cornerRadius = 3
        startBtn.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        startBtn.layer.borderWidth = 0.5
        startBtn.layer.masksToBounds = true
        startBtn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        startBtn.addTarget(self, action: #selector(startlive), for: .touchUpInside)
        self.view.addSubview(startBtn)
    }
    
    func createFieldView(type : textType,index: Int) -> GSTextFieldTitleView {
        let fieldView = GSTextFieldTitleView.init(frame: CGRect.init(x: 0, y: index * 40, width: Int(Width), height: 40))
        fieldView.title = type.title
        fieldView.placeHolder = "请输入\(type.title)"
        fieldView.field.clearButtonMode = .always
        
        let value = UserDefaults.standard.value(forKey: type.key) as? String
        fieldView.field.text = value
        self.fieldViewsDic[type.key] = fieldView;
        return fieldView;
    }
    
    func paramVerify(param : String,type:textType) -> Bool {
        if param.count <= 0 {
            let alertvc = UIAlertController.init(title: "提示", message: "\(type.title)不能为空", preferredStyle: .alert)
            let okbtn = UIAlertAction.init(title: "确定", style: .default, handler: nil)
            alertvc.addAction(okbtn)
            self.present(alertvc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @objc func startlive() {
        
        let domain : String = (self.fieldViewsDic[textType.domain.key] as! GSTextFieldTitleView).field.text!
        let port : String = (self.fieldViewsDic[textType.port.key] as! GSTextFieldTitleView).field.text!
        let nickname : String = (self.fieldViewsDic[textType.nickname.key] as! GSTextFieldTitleView).field.text!
        let pwd : String = (self.fieldViewsDic[textType.password.key] as! GSTextFieldTitleView).field.text!
        
        let params = [domain,port,nickname,pwd]
        let types = [textType.domain,textType.port,textType.nickname,textType.password]
        for (index,str) in params.enumerated() {
            let result = paramVerify(param: str,type: types[index])
            if !result {
                return;
            }
        }
        
        
        UserDefaults.standard.set(domain, forKey: textType.domain.key)
        UserDefaults.standard.set(port, forKey: textType.port.key)
        UserDefaults.standard.set(nickname, forKey: textType.nickname.key)
        UserDefaults.standard.set(pwd, forKey: textType.password.key)
        
        let activity = UIActivityIndicatorView.init(style: .white)
        activity.frame = CGRect.init(x: self.view.width/2 - 40, y: self.view.height/2 - 40, width: 80, height: 80)
        activity.backgroundColor = UIColor.groupTableViewBackground
        activity.startAnimating()
        self.view.addSubview(activity)
        startBtn.isUserInteractionEnabled = false
        startBtn.backgroundColor = #colorLiteral(red: 0.1358612904, green: 0.3971300088, blue: 0.5744927765, alpha: 1)
        
        let enterblock : (Bool,String?)->Void = {[unowned self] (success:Bool,errorStr:String?) -> Void in
            print("enter block");
            
            activity.stopAnimating()
            activity.removeFromSuperview()
            self.startBtn.isUserInteractionEnabled = true
            self.startBtn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
            if !success {
                let alertvc = UIAlertController.init(title: "提示", message: "\(errorStr!)", preferredStyle: .alert)
                let okbtn = UIAlertAction.init(title: "确定", style: .default, handler: nil)
                alertvc.addAction(okbtn)
                self.present(alertvc, animated: true, completion: nil)
            }
        }
        
        let leaveblock = {
            print("leave block");
            
        }
//        RtSDKDemoSDK.shared()?.joinMeeting(byDomain: domain, port: port, nickname: nickname, pwd: pwd, completion: enterblock);
//
//        RtSDKDemoSDK.shared()?.setControllerLeave(leaveblock);
    }
    
}



extension JoinMeetingViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func baseConfig() {
        let standard = UserDefaults.standard
        if standard.value(forKey: textType.domain.key) == nil{
            standard.set("i.263.net", forKey: textType.domain.key)
        }
        if standard.value(forKey: textType.port.key) == nil{
            standard.set("443", forKey: textType.port.key)
        }
        standard.synchronize()
    }
}
