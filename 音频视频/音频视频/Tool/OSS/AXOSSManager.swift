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
    
    private init() {}
    
    enum UPType {
        case filePath, data
    }
    
    enum OSSProject: String {
        case homework = "homework"
        
        var name: String {
            return self.rawValue
        }
    }
    
    enum DataType: String {
        case audios = "audios"
        case videos = "videos"
        case images = "images"
        var name: String {
            return self.rawValue
        }
        var postfix: String {
            switch self {
            case .audios: return ".mp3"
            case .videos: return ".mp4"
            case .images: return ".png"
            }
        }
    }
    
    var upType: UPType?
    var bucketName: String = BUCKET_NAME
    var objectkey: String = ""
    var filePath: String?
    var data: Data?
    
    /// 初始化OSSManagerModel对象
    ///
    /// - Parameters:
    ///   - upType: 上传类型
    ///   - bucketName: OSS的BucketName
    ///   - objectkey_prefix: 前缀：返回项目的环境目录
    ///   - dataType: 文件类型
    ///   - objectkey_name: 功能名称：例如 homework
    ///   - objectkey_md5path: 文件名称：使用md5串
    init(upType: UPType, bucketName: String, objectkey_prefix: String, dataType: DataType, objectkey_name: OSSProject, objectkey_md5path: String) {
        self.upType = upType
        self.bucketName = bucketName
        
        // 拼接规则
        // objectkey_prefix：         online
        // dataType:                  video
        // objectkey_name:            homework
        // objectkey_md5path          md5字符串
        // postfix                   .mp4
        self.objectkey = "\(objectkey_prefix)/\(dataType.name)/\(objectkey_name.name)/\(objectkey_md5path)\(dataType.postfix)"
    }
    
    init(homework upType: UPType, dataType: DataType) {
        
        let project: OSSProject = .homework
        
        self.upType = upType
        self.bucketName = BUCKET_NAME
        self.objectkey = "test/\(dataType.name)/\(project.name)/\("objectkey_md5path")\(dataType.postfix)"
    }
    
    /// 获取ObjectKey
    ///
    /// - Returns: objectkey
    func getObjectKey() -> String {
        return self.objectkey
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
