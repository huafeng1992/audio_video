//
//  OSSManager.swift
//  BaonahaoSchool
//
//  Created by 王华峰 on 2018/6/6.
//  Copyright © 2018年 XiaoHeTechnology. All rights reserved.
//

import Foundation
import AliyunOSSiOS

// 已更改信息
let OSS_STSTOKEN_URL: String = "http://192.168.1.72:7080"

struct OSSManager {
    
    var vc: UIViewController!
    
    // aixiao
    let bucketName = "xiaohe-online"
//    let bucketObjectKey = "offline/audios/homework"
    let bucketObjectKey = ""
    
    let client: OSSClient = {

        //直接访问鉴权服务器（推荐，token过期后可以自动更新）
        let endpoint = "oss-cn-beijing.aliyuncs.com"
        //直接访问鉴权服务器（推荐，token过期后可以自动更新）
        let credential = OSSAuthCredentialProvider.init(authServerUrl: OSS_STSTOKEN_URL)
        // 开启日志记录
//        OSSLog.enable()
        
        let config = OSSClientConfiguration()
        config.maxRetryCount = 1  // 网络请求遇到异常失败后的重试次数
        config.timeoutIntervalForRequest = 30  // 网络请求的超时时间
        config.timeoutIntervalForResource = 24*60*60  // 允许资源传输的最长时间
        
        let client = OSSClient.init(endpoint: endpoint, credentialProvider: credential, clientConfiguration: config)
        return client
    }()
    
    // 测试
    func request(filePath: String) {
        
//        getMetaInObj()
        deleteObject()
//        getBucketInFile(bucketName: bucketName)
        
//        getBucketInFile(bucketName: bucketName)
//        putObject(filePath: filePath)
    }
    
    func putObject(filePath: String) {
        
        let put: OSSPutObjectRequest = OSSPutObjectRequest()
        put.contentType = "application/octet-stream"
        // 设置MD5校验，可选

//            [OSSUtil base64Md5ForFilePath:@"<filePath>"]; // 如果是文件路径
        // put.contentMd5 = [OSSUtil base64Md5ForData:<NSData *>]; // 如果是二进制数据
        
        put.bucketName = bucketName
        put.objectKey = bucketObjectKey
        put.uploadingFileURL = URL.init(fileURLWithPath: filePath)
//        put.uploadingData = 直接上传NSData
        
        let putTask: OSSTask = client.putObject(put)
        
        putTask.continue({(task) -> OSSTask<AnyObject>? in
            if task.error == nil {
                print("upload object success!")
            } else {
                print("异常")
                
            }
            return nil
        })
    }
}

// FileManager
extension OSSManager {
    
    // 检查文件是否存在
    func checkFileisHasService() -> Bool {
        
        return false
    }
    
    // 复制Object
    func copyObject() {
    
        let copy = OSSCopyObjectRequest()
        copy.bucketName = bucketName
        copy.objectKey = bucketObjectKey
        copy.sourceCopyFrom = "/\(bucketName)/\(bucketObjectKey)"
        // 源Object和目标Object必须属于同一个数据中心。
        // 如果拷贝操作的源Object地址和目标Object地址相同，可以修改已有Object的meta信息。
        // 拷贝文件大小不能超过1G，超过1G需使用Multipart Upload操作。
        let copyTask = client.copyObject(copy)
        copyTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 删除Object
    func deleteObject() {
        
        let delete = OSSDeleteObjectRequest()
        delete.bucketName = bucketName
        delete.objectKey = bucketObjectKey
        
        let deleteTask = client.deleteObject(delete)
        deleteTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 只获取Object的Meta信息
    func getMetaInObj() {
        
        let head = OSSHeadObjectRequest()
        head.bucketName = bucketName
        head.objectKey = bucketObjectKey
        
        let headTask = client.headObject(head)
        headTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
}

// BucketManager
extension OSSManager {
    
    func creatBucketObj() {
        
        let create = OSSCreateBucketRequest()
        create.bucketName = bucketName
        create.xOssACL = "public-read-write"
        
        let createTask = client.createBucket(create)
        createTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 罗列所有Bucket
    func getAllBucket() {
        
        let getService = OSSGetServiceRequest()
        let getServiceTask = client.getService(getService)
        getServiceTask.continue ({ (t) -> Any? in
//            if let result = t.result as? OSSGetBucketResult {
            
                
                print("罗列所有Bucket\(t)")
                
                if let result = t.result as? OSSGetServiceResult {
                    print("buckets: \(String(describing: result.buckets))")
                    print("owner: \(result.ownerId), \(result.ownerDispName)")
                    if result.buckets != nil {
                        for item in result.buckets! {
                            if let dict = item as? NSDictionary {
                                print("BucketName: \(dict["Name"] ?? "")")
                                print("CreationDate: \(dict["CreationDate"] ?? "")")
                                print("Location: \(dict["Location"] ?? "")")
                            }
                        }
                    }
                }
                
//            }else
//            {
//                self.showResult(task: t)
//            }
            
            return nil
        })
    }
    
    // 罗列bucket中的文件
    func getBucketInFile(bucketName: String) {
        let getBucket = OSSGetBucketRequest()
        getBucket.bucketName = bucketName
        let getBucketTask = client.getBucket(getBucket)
        getBucketTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 删除Bucket
    func deleBucket(bucketName: String) {
        let delete = OSSDeleteBucketRequest()
        delete.bucketName = bucketName
        
        let deleBucket = client.deleteBucket(delete)
        deleBucket.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            }else
            {
                self.showResult(task: t)
            }
            return nil
        })
    }
}


extension OSSManager {
    
    func ossAlert(title: String?,message:String?) -> Void {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertCtrl.addAction(UIAlertAction(title: "confirm", style: UIAlertActionStyle.default, handler: { (action) in
            print("\(action.title!) has been clicked");
            alertCtrl.dismiss(animated: true, completion: nil)
        }))
        
        DispatchQueue.main.async {
            self.vc.present(alertCtrl, animated: true, completion: nil)
        }
    }
    
    func showResult(task: OSSTask<AnyObject>?) -> Void {
        if (task?.error != nil) {
            let error: NSError = (task?.error)! as NSError
            self.ossAlert(title: "error", message: error.description)
        }else
        {
            let result = task?.result
            self.ossAlert(title: "notice", message: result?.description)
            print(result?.description ?? "")
        }
    }
}
