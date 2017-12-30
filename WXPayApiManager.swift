//
//  WXPayApiManager.swift
//  HuaJuanQiPai
//
//  Created by xiaoyao on 2017/12/30.
//  Copyright © 2017年 XiaoYaoMedia. All rights reserved.
//

import Foundation

protocol WXApiManagerDelegate: NSObjectProtocol {
    func managerDidRecvGetMessageReq(request: GetMessageFromWXReq)
    func managerDidRecvShowMessageReq(request: ShowMessageFromWXReq)
    func managerDidRecvLaunchFromWXReq(request: LaunchFromWXReq)
    func managerDidRecvMessageResponse(response: SendMessageToWXResp)
    func managerDidRecvAuthResponse(response: SendAuthResp)
    func managerDidRecvAddCardResponse(response: AddCardToWXCardPackageResp)
}

class WXPayApiManager: NSObject, BasePayManager, WXApiDelegate {
    static let sharedInstance = WXPayApiManager()
    private override init() {}
    
    weak var delegate : WXApiManagerDelegate?
    var completionBlock : PayCompletionBlock?

    func pay(data: AnyObject) {
        self.pay(data: data, handler: { (String) in})
    }
    
    func pay(data: AnyObject, handler: @escaping (String) -> Void) {
        self.completionBlock = handler
        
        let dict = data as! NSDictionary
        let partnerid = dict.object(forKey: "partnerid") as! String
        let prepayId = dict.object(forKey: "prepayid") as! String
        let package = dict.object(forKey: "package") as! String
        let sign = dict.object(forKey: "sign") as! String
        let noncestr = dict.object(forKey: "noncestr") as! String
        let timeStamp = UInt32(dict.object(forKey: "timestamp") as! String)
        
        //设置支付信息
        let request : PayReq = PayReq()
        
        request.partnerId = partnerid
        request.prepayId = prepayId
        request.package = package
        request.nonceStr = noncestr
        request.timeStamp = timeStamp!
        request.sign = sign
        
        let wxpayAppId : String = dict.object(forKey: "appid") as! String
        WXApi.registerApp(wxpayAppId)
        
        if (WXApi.isWXAppInstalled()) {
            WXApi.send(request)
        } else{
            NSLog("您尚未安装微信");
        }
    }
    
    //  微信回调
    func onResp(_ resp: BaseResp!) {
        if (resp.isKind(of: SendMessageToWXResp.self)) {
            if (delegate != nil) {
                let messageResp : SendMessageToWXResp = resp as! SendMessageToWXResp;
                delegate?.managerDidRecvMessageResponse(response:messageResp);
            }
        } else if (resp.isKind(of: SendAuthResp.self)) {
            if (self.delegate != nil) {
                let authResp: SendAuthResp = resp as! SendAuthResp;
                self.delegate?.managerDidRecvAuthResponse(response: authResp);
            }
        } else if (resp.isKind(of: AddCardToWXCardPackageResp.self)) {
            if (self.delegate != nil) {
                let addCardResp: AddCardToWXCardPackageResp = resp as! AddCardToWXCardPackageResp;
                self.delegate?.managerDidRecvAddCardResponse(response: addCardResp)
            }
        } else if(resp.isKind(of: PayResp.self)){
            handlePayResult(data: resp)
        }
    }
    
    func handlePayResult(data: AnyObject) {
        let resp = data as! PayResp
        let resultMsg: String
        let result: String
        switch resp.errCode {
            //  支付成功
            case 0 : do {
                result = "1"
                resultMsg = "支付成功"
            }
            //  支付失败
            default: do {
                result = "0"
                resultMsg = "支付失败"
            }
        }
            
        
        let alertView = UIAlertView.init(title: "支付结果", message: resultMsg, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
        
        guard let callBlock = self.completionBlock else {
            return;
        }
        callBlock(result);
    }

    func onReq(_ req: BaseReq!) {
        if (req.isKind(of: GetMessageFromWXReq.self)) {
            if (delegate != nil) {
                let getMessageReq : GetMessageFromWXReq = req as! GetMessageFromWXReq;
                delegate?.managerDidRecvGetMessageReq(request:getMessageReq);
            }
        } else if (req.isKind(of: GetMessageFromWXReq.self)) {
            if (delegate != nil) {
                let showMessageReq : ShowMessageFromWXReq = req as! ShowMessageFromWXReq;
                delegate?.managerDidRecvShowMessageReq(request:showMessageReq);
            }
        } else if (req.isKind(of: LaunchFromWXReq.self)) {
            if (delegate != nil) {
                let launchReq : LaunchFromWXReq = req as! LaunchFromWXReq;
                delegate?.managerDidRecvLaunchFromWXReq(request:launchReq);
            }
        }
    }
}


