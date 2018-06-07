//
//  AXOSSManager.swift
//  音频视频
//
//  Created by 王华峰 on 2018/6/7.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AliyunOSSiOS

class OSSManagerModel {
    
    enum UPType {
        case filePath, data
    }
    
    var upType: UPType?
    var bucketName: String = BUCKET_NAME
    var objectkey: String = ""
    var filePath: String?
    var data: Data?
    
    init(upType: UPType, bucketName: String, objectkey_fix: String, objectkey_path: String) {
        self.upType = upType
        self.bucketName = bucketName
        self.objectkey = "\(objectkey_fix)/\(objectkey_path)"
    }
}

class AXOSSManager: NSObject {
    
    class func queue(putObjArray: [OSSManagerModel], allComplete: @escaping () -> Void, error: @escaping () -> Void) {
        
        //获取系统存在的全局队列
        let queue = DispatchQueue.global(qos: .default)
        //定义一个group
        let group = DispatchGroup()
        
        var finishCount = putObjArray.count
        
        for putObjReq in putObjArray {
            
            //并发任务，顺序执行
            queue.async(group: group) {
                
                if putObjReq.upType == .filePath {
                    
                    if let filePath = putObjReq.filePath {
                        let ossmanager = OSSManager.init(client: OSSClientMgr.client(), bucketName: putObjReq.bucketName, objectKey: putObjReq.objectkey)
                        ossmanager.pushObject(filePath: filePath, progress: nil, complete: { (task) -> Any? in
                            if task.error == nil {
                                finishCount -= 1
                            }
                            return nil
                        }).waitUntilFinished()
                    }
                }
                
                if putObjReq.upType == .data {
                    
                    if let data = putObjReq.data {
                        let ossmanager = OSSManager.init(client: OSSClientMgr.client(), bucketName: putObjReq.bucketName, objectKey: putObjReq.objectkey)
                        ossmanager.pushObject(data: data, progress: nil, complete: { (task) -> Any? in
                            if task.error == nil {
                                finishCount -= 1
                            }
                            return nil
                        }).waitUntilFinished()
                    }
                }
            }
        }
        
        //1,所有任务执行结束汇总，不阻塞当前线程
        group.notify(queue: .global(), execute: {
            print("group done")
            print(finishCount)
            if finishCount == 0 {
                allComplete()
            } else {
                error()
            }
        })
        
        group.wait()   
    }
}
