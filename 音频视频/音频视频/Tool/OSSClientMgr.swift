//
//  OSSClientMgr.swift
//  音频视频
//
//  Created by 华峰 on 2018/6/6.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AliyunOSSiOS


let OSS_STSTOKEN_URL: String = "http://192.168.1.72:7080"
let ENDPOINT = "oss-cn-beijing.aliyuncs.com"


class OSSClientMgr: OSSClient {
    
    static let sharedManager = OSSClientMgr()
    
    // 已更改信息
    let client: OSSClientMgr = {
    
        //直接访问鉴权服务器（推荐，token过期后可以自动更新）
        let credential = OSSAuthCredentialProvider.init(authServerUrl: OSS_STSTOKEN_URL)
        // 开启日志记录
        //        OSSLog.enable()
        
        let config = OSSClientConfiguration()
        config.maxRetryCount = 0  // 网络请求遇到异常失败后的重试次数
        config.timeoutIntervalForRequest = 30  // 网络请求的超时时间
        config.timeoutIntervalForResource = 24*60*60  // 允许资源传输的最长时间
        
        let client = OSSClientMgr.init(endpoint: ENDPOINT, credentialProvider: credential, clientConfiguration: config)
        return client
    }()
    
}
