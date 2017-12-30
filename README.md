# SSPayManager
### iOS Swfit封装微信支付&支付宝支付
简单的封装两大支付平台，带有示例Demo，快速在Swfit项目中使用。
### BasePayManager 支付协议基类
``` swift
/**
* 使用已生成的预售订单信息调起支付
*/
func pay(data:AnyObject);

/**
* 使用已生成的预售订单信息调起支付
* handler:支付结果回调
*/
func pay(data:AnyObject, handler: @escaping (String) -> Void);
```
### AlipayApiManager 支付宝支付类

``` swift
AlipayApiManager.sharedInstance.pay(data: data) { (result: String) in
		// 支付结果回调处理
		//guard let payJSCallBack = self.payCallBack else {
		//		return;
		//}
		//payJSCallBack(result)
}
```

### WXPayApiManager 微信支付类
``` swfit
WXPayApiManager.sharedInstance.pay(data: data) { (result: String) in
		// 支付结果回调处理
		//guard let payJSCallBack = self.payCallBack else {
		//		return;
		//}
		//payJSCallBack(result)
}
```


