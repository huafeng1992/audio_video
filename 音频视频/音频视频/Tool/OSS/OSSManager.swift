//
//  OSSManager.swift
//  BaonahaoSchool
//
//  Created by 王华峰 on 2018/6/6.
//  Copyright © 2018年 XiaoHeTechnology. All rights reserved.
//

import Foundation
import AliyunOSSiOS

class OSSManager: NSObject {
    
    enum PushObjType {
        case filePath, data
    }
    
    var client: OSSClient!
    var bucketName: String!
    var bucketObjectKey: String!
    
    convenience init(client: OSSClient, bucketName: String, objectKey: String) {
        self.init()
        self.client = client
        self.bucketName = bucketName
        self.bucketObjectKey = objectKey
    }
}

// 上传
extension OSSManager {
    
    //    bytesSent, totalBytesSent, totalBytesExpectedToSend
    func pushObject(filePath: String, progress: OSSNetworkingUploadProgressBlock?) -> OSSTask<AnyObject> {
        return putObject(type: .filePath, obj: filePath, uploadProgress: progress, complete: nil)
    }
    
    func pushObject(data: Data, progress: OSSNetworkingUploadProgressBlock?) -> OSSTask<AnyObject> {
        return putObject(type: .data, obj: data, uploadProgress: progress, complete: nil)
    }
    
    // 上传
    func putObject(type: PushObjType, obj: Any, uploadProgress: OSSNetworkingUploadProgressBlock?, complete: ((OSSTask<AnyObject>) -> Any)?) -> OSSTask<AnyObject> {
        
        let put: OSSPutObjectRequest = OSSPutObjectRequest()
        //  put.contentType = "application/octet-stream"
        // 设置MD5校验，可选
        
        // [OSSUtil base64Md5ForFilePath:@"<filePath>"]; // 如果是文件路径
        // put.contentMd5 = [OSSUtil base64Md5ForData:<NSData *>]; // 如果是二进制数据
        
        put.bucketName = bucketName
        put.objectKey = bucketObjectKey
        
        if type == .filePath {
            put.uploadingFileURL = URL.init(fileURLWithPath: obj as! String)
        }
        if type == .data {
            put.uploadingData = obj as! Data
        }
        
        // 进度设置，可选
        if uploadProgress != nil {
            put.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) in
                // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
                uploadProgress!(bytesSent, totalBytesSent, totalBytesExpectedToSend)
            }
        }
        
        let task = client.putObject(put)
        
        
        return task.continue({ (t) -> Any? in
    
            if complete != nil {
                return complete!(t)
            }
//            if t.error == nil {
//                self.showResult(task: t)
//            } else {
//                print("上传异常")
//            }
            return nil
        })
    }
}

// FileManager
extension OSSManager {
    
    // 检查文件是否存在
    private func checkFileisHasService() -> Bool {
        
        return false
    }
    
    // 复制Object
    private func copyObject() {
    
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
            } else {
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
            } else {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 只获取Object的Meta信息
    private func getMetaInObj() {
        
        let head = OSSHeadObjectRequest()
        head.bucketName = bucketName
        head.objectKey = bucketObjectKey
        
        let headTask = client.headObject(head)
        headTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            } else {
                self.showResult(task: t)
            }
            return nil
        })
    }
}

// BucketManager
extension OSSManager {
    
    private func creatBucketObj() {

        let create = OSSCreateBucketRequest()
        create.bucketName = bucketName
        create.xOssACL = "public-read-write"
        
        let createTask = client.createBucket(create)
        createTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            } else {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 罗列所有Bucket
    private func getAllBucket() {
        
        let getService = OSSGetServiceRequest()
        let getServiceTask = client.getService(getService)
        getServiceTask.continue ({ (t) -> Any? in

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
            return nil
        })
    }
    
    // 罗列bucket中的文件
    private func getBucketInFile(bucketName: String) {
        let getBucket = OSSGetBucketRequest()
        getBucket.bucketName = bucketName
        let getBucketTask = client.getBucket(getBucket)
        getBucketTask.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            } else {
                self.showResult(task: t)
            }
            return nil
        })
    }
    
    // 删除Bucket
    private func deleBucket(bucketName: String) {
        let delete = OSSDeleteBucketRequest()
        delete.bucketName = bucketName
        
        let deleBucket = client.deleteBucket(delete)
        deleBucket.continue ({ (t) -> Any? in
            if let result = t.result as? OSSGetBucketResult {
                self.showResult(task: OSSTask(result: result.contents as AnyObject))
            } else {
                self.showResult(task: t)
            }
            return nil
        })
    }
}


extension OSSManager {
    
    func showResult(task: OSSTask<AnyObject>?) -> Void {
        if (task?.error != nil) {
            let error: NSError = (task?.error)! as NSError
            print(error.description)
        } else {
            let result = task?.result
            print(result?.description ?? "")
        }
    }
}
