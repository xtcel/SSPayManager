//
//  AlipayApiManager.swift
//  HuaJuanQiPai
//
//  Created by xiaoyao on 2017/12/30.
//  Copyright © 2017年 XiaoYaoMedia. All rights reserved.
//

import Foundation

class AlipayApiManager: BasePayManager {
    static let sharedInstance = AlipayApiManager()
    private init() {}
    
    var completionBlock : PayCompletionBlock?
    
    func pay(data: AnyObject) {
        self.pay(data: data, handler: { (String) in
        })
    }
    
    func pay(data: AnyObject, handler: @escaping (String) -> Void) {
        let appid = Bundle.main.infoDictionary?["AliPayAppId"] as? String
        let appScheme = "alipay" + appid!
        let orderString = "\(data)"
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) -> Void in
            print("resultDic:\(String(describing: resultDic))")
            // H5支付回调
            self.handlePayResult(data: resultDic as AnyObject)
        })
        
        self.completionBlock = handler
    }
    
    func handlePayResult(data: AnyObject) {
        print("reslut = \(String(describing: data))");
        guard let status = data["resultStatus"] as? String else {
            return
        }
        
        let result : String
        let resultString : String
        if status == "9000" {
            resultString = "支付成功"
            result = "1"
        }
        else if status == "8000" {
            resultString = "正在处理中"
            result = "1"
        }
        else if status == "4000" {
            resultString = "订单支付失败"
            result = "0"
        }
        else if status == "6001" {
            resultString = "支付失败,用户中途取消"
            result = "0"
        }
        else if status == "6002" {
            resultString = "支付失败,网络连接出错"
            result = "0"
        }
        else {
            result = "0"
            resultString = "支付失败"
        }
        
        let alertView = UIAlertView.init(title: "支付结果", message: resultString, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
        
        guard let callBlock = self.completionBlock else {
            return;
        }
        callBlock(result);
    }
}
