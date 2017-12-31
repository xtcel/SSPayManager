//
//  BasePayManager.swift
//  HuaJuanQiPai
//
//  Created by jacky on 2017/12/30.
//  Copyright © 2017年 xtcel.com. All rights reserved.
//

import Foundation

protocol BasePayManager {
    typealias PayCompletionBlock = (String) -> Void
    
    /**
     * 使用已生成的预售订单信息调起支付
     */
    func pay(data:AnyObject);
    
    /**
     * 使用已生成的预售订单信息调起支付
     * handler:支付结果回调
     */
    func pay(data:AnyObject, handler: @escaping (String) -> Void);
}
