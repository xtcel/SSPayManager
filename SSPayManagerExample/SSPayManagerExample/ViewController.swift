//
//  ViewController.swift
//  SSPayManagerExample
//
//  Created by xiaoyao on 2017/12/30.
//  Copyright © 2017年 xtcel.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func wxpayButtonClickedEvent(_ sender: Any) {
        let dataDict: Dictionary<String,String> = [
            "appid" : "wx55555baeec6d888d",
            "noncestr" : "5a45edfcf3507",
            "package" : "Sign=WXPay",
            "partnerid" : "1889999999",
            "prepayid" : "wx20171229152548d91962e59b0117190688",
            "sign" : "CD0C2740B14271DF30C664A858899EC8",
            "timestamp" : "1514532348",
            ]
        WXPayApiManager.sharedInstance.pay(data: dataDict as AnyObject) { (result: String) in
            // 支付结果回调处理
            //guard let payJSCallBack = self.payCallBack else {
            //        return;
            //}
            //payJSCallBack(result)
        }
    }
    
    @IBAction func alipayButtonClickedEvent(_ sender: Any) {
        
        let orderId = "alipaysdk=1234testalipay"
        AlipayApiManager.sharedInstance.pay(data: orderId as AnyObject) { (result: String) in
            // 支付结果回调处理
            //guard let payJSCallBack = self.payCallBack else {
            //        return;
            //}
            //payJSCallBack(result)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

