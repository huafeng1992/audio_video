//
//  OSSClientMgr.swift
//  音频视频
//
//  Created by 华峰 on 2018/6/6.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AliyunOSSiOS


//RoleArn: acs:ram::1626597922695968:role/aliyunosstokengeneratorrole
//AccessKeyID：LTAI6t9KJ0Hp7rES
//AccessKeySecret：mlypYKR8z0hUgAlLwmppzQ2YKgNVUH


//let OSS_STSTOKEN_URL: String = "http://192.168.1.72:7080"
let OSS_STSTOKEN_URL: String = "https://apiaixiaofz.xiaohe.com/ali_index.php"
let ENDPOINT = "oss-cn-beijing.aliyuncs.com"
let BUCKET_NAME = "xiaohe-online"
let OBJECTKEY_FIX = "offline"

class OSSClientMgr {
        
    // 已更改信息
    class func client() -> OSSClient {
        //直接访问鉴权服务器（推荐，token过期后可以自动更新）
        let credential = OSSAuthCredentialProvider.init(authServerUrl: OSS_STSTOKEN_URL)
        // 开启日志记录
        // OSSLog.enable()
        
        let config = OSSClientConfiguration()
        config.maxRetryCount = 0  // 网络请求遇到异常失败后的重试次数
        config.timeoutIntervalForRequest = 30  // 网络请求的超时时间
        config.timeoutIntervalForResource = 24*60*60  // 允许资源传输的最长时间
        
        let client = OSSClient.init(endpoint: ENDPOINT, credentialProvider: credential, clientConfiguration: config)
        return client
    }
}
