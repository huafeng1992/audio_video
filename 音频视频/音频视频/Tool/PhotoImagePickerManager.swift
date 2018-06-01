//
//  File.swift
//  BaonahaoSchool
//
//  Created by huafeng on 2017/11/15.
//  Copyright © 2017年 XiaoHeTechnology. All rights reserved.
//

import Foundation
import Photos
import AssetsLibrary

//MARK:- PhotoModel
class PhotoModel: NSObject {
    
    var name: String?               // 媒体名字
    var uploadType: Any?            // 媒体上传格式 图片是NSData，视频主要是路径名，也有NSData
    var image: UIImage?             // 媒体照片
    var imageUrlString: String?     // 图片URL
    var isVideo: Bool?              // 是否属于可播放的视频类型
    var mediaURL: URL?              // 视频的URL    
    var asset: PHAsset?             // iOS8 之后的媒体属性
}

//MARK:- PhotoImagePickerManager
class PhotoImagePickerManager: NSObject {
    
    static let manager = PhotoImagePickerManager()
    let imgName = "IMG.PNG"
    let vidName = "Video.mov"
    /**
     传入 Image 和 PHAsset，得到该图片的原图名称、上传类型NSData

     @param image 传入的图片
     @param asset PHAsset对象，没有原图则传入nil
     @param completion 成功的回调
     */
    
    func getImageInfoFromImage(image: UIImage?, asset: PHAsset?, completion: (_ name: String,_ data: Data) -> Void) {
        guard let nImage = image else {return}
        //图片名
        let imageName: String = getMediaNameWithPHAsset(asset: asset, extensionName: imgName)
        var imageData: Data?
        if UIImagePNGRepresentation(nImage) == nil {
            imageData = UIImageJPEGRepresentation(nImage, 1)
        } else {
            imageData = UIImagePNGRepresentation(nImage)
        }
        completion(imageName, imageData!)
    }
    
    /**
     根据 URL 等获取视频封面、名称 和 上传类型(优先路径 或 NSData)
     
     @param videoURL   视频URL
     @param asset      视频PHAsset（本地存在原图才有这个属性值，不然传入nil）
     @param enableSave 对于本地没有的是否保存到本地
     @param completion 成功回调，不保存的话，返回的NSData
     */
    func getVideoPathFromURL(videoURL: URL?, asset: PHAsset?, enableSave: Bool, completion:(_ name: String,_ screenshot: UIImage?,_ pathData: Any? ) -> Void)  {
        
        //视频名
        let fileName: String = self.getMediaNameWithPHAsset(asset: asset, extensionName: vidName)
        //视频本地路径
        let filePath = NSTemporaryDirectory().appendingFormat("%@", fileName)
        //data视频
        guard let videoURLN = videoURL else {return}
        var videoData: Data?
        do{
            videoData = try Data.init(contentsOf: videoURLN)
        }catch{
            print("error")
        }
        //视频封面
        let screenshot = imageWithVideoURL(videoURL: videoURLN, enableSave: enableSave)
        
        //判断本地是否有
        let success: Bool = FileManager.default.fileExists(atPath: filePath)
        //本地不存在的情况
        if success == false {
            if enableSave {
                //写入本地，成功之后返回路径
                do {
                    try videoData?.write(to: URL.init(fileURLWithPath: filePath))
                    completion(filePath, screenshot, filePath)
                } catch {
                    print("写入失败")
                }
            } else {
                //不保存，那么就只有返回NSData
                completion(filePath, screenshot, filePath)
            }
        } else {
            //本地存在，那么就是本地视频，直接返回路径
            completion(filePath, screenshot, filePath)
        }
    }
    
    // 获取视频
    func getVideoWithAsset(_ asset: Any?, completion: ((AVPlayerItem?, [AnyHashable : Any]?) -> Void)?) {
        getVideoWithAsset(asset: asset, progressHandler: nil, completion: completion)
    }

    func getVideoWithAsset(asset: Any?, progressHandler: PHAssetImageProgressHandler?, completion: ((AVPlayerItem?, [AnyHashable : Any]?) -> Void)?)  {
        
        guard let assetItem = asset else {
            return
        }
        if assetItem is PHAsset {
            
            let assetObj = assetItem as! PHAsset
            
            let option = PHVideoRequestOptions.init()
            option.isNetworkAccessAllowed = true
            option.progressHandler = {(progress, error, stop, info) in
                DispatchQueue.main.async {
                    if progressHandler != nil {
                        progressHandler!(progress, error, stop, info)
                    }
                }
            }
            PHImageManager.default().requestPlayerItem(forVideo: assetObj, options: option, resultHandler: { (playerItem, info) in
                if completion != nil {
                    completion!(playerItem, info)
                }
            })
            
        } else if assetItem is ALAsset {
            let alAsset = assetItem as! ALAsset
            let defaultRepresentation: ALAssetRepresentation = alAsset.defaultRepresentation()
            let uti = defaultRepresentation.uti()
            guard let newuti = uti else {return}
            guard let videoUrlDict = alAsset.value(forProperty: ALAssetPropertyURLs) as? NSDictionary else { return }
            guard let videoURL = videoUrlDict.value(forKey: newuti) as? URL else {return}
            let playerItem: AVPlayerItem? = AVPlayerItem.init(url: videoURL)
            if completion != nil && playerItem != nil {
                completion!(playerItem!, nil)
            }
        }
    }
    
    /**
     根据 PHAsset 来获取 媒体文件(视频或图片)相关信息：文件名、文件上传类型（data 或 path）
     
     @param asset  PHAsset对象
     @param completion 成功回调 name：自定义名称， pathData：数据， image：略缩图
     */
    
    func getMediaInfoFromAsset(asset: PHAsset?, completion: @escaping (_ name: String,_ pathData: Any?, _ avurlAsset: AVURLAsset?) -> Void) {
        
        guard let assetItem = asset else {return}
        var mediaName: String?
        
        switch assetItem.mediaType {
        case .image:
            //图片文件名
            mediaName = getMediaNameWithPHAsset(asset: assetItem, extensionName: imgName)
            let options = PHImageRequestOptions()
            options.resizeMode = .fast
            options.version = .current
            //返回图片的质量类型 （效率高，质量低）
            options.deliveryMode = .fastFormat
            //同步请求获取iCloud图片（默认为NO）
            //options.synchronous = YES;
            PHImageManager.default().requestImageData(for: assetItem, options: options, resultHandler: { (imageData, dataUTI, orientation, info) in
                if imageData != nil {
                    completion(mediaName!, imageData, nil)
                }
            })
            print("传进来一个图片")
        case .video:
            
            mediaName = getMediaNameWithPHAsset(asset: assetItem, extensionName: vidName)
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            
            PHImageManager.default().requestAVAsset(forVideo: assetItem, options: options) { (avasset, avaudioMix, info) in
                
                guard let urlAsset = avasset as? AVURLAsset else {
                    return
                }
                let url = urlAsset.url
                do {
                    let data: Data = try Data.init(contentsOf: url)
                    completion(mediaName!, data, urlAsset)
                    
                } catch {
                    print("获取视频失败")
                }
            }
            
            print("传进来一个视频")
        case .unknown:
            break
        case .audio:
            break   
        }
    }
    
    //MARK: - private methods
    /**
     获取媒体文件名称
     
     @param asset     PHAsset对象
     @param extension 媒体文件的拓展名（.PNG等）
     @return asset为nil时，返回默认自定义时间(按时间命名)，不为nil则返回原图名称
     */
    private func getMediaNameWithPHAsset(asset: PHAsset?, extensionName: String) -> String {
        
        let date = Date()
        let formatter: DateFormatter = DateFormatter.init()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var mediaName: String?
        // 空的情况，返回自定义名称（按时间命名）
        if asset == nil {
            mediaName = formatter.string(from: date)
            return "\(mediaName!)\(extensionName)"
        }
        if #available(iOS 9.0, *) {
            
            let resource: PHAssetResource = PHAssetResource.assetResources(for: asset!).first!
            if !resource.originalFilename.isEmpty {
                mediaName = resource.originalFilename
            } else {
                mediaName = "\(formatter.string(from: date))\(extensionName)"
            }
            
        } else {
            mediaName = "\(formatter.string(from: date))\(extensionName)"
        }
        return mediaName ?? ""
    }
    
    /**
     根据视频的URL来获取视频封面截图
     
     @param videoURL 视频URL
     @param enableSave 是否将封面截图保存到本地
     @return 返回封面截图
     */
    func imageWithVideoURL(videoURL: URL?, enableSave: Bool) -> UIImage? {
        //1、根据视频URL创建 AVURLAsset
        guard let videoUrl = videoURL else {
            print("url为空")
            return nil
        }
        let urlAsset: AVURLAsset = AVURLAsset.init(url: videoUrl)
        
        //2、根据 AVURLAsset 创建 AVAssetImageGenerator对象
        let imageGenerator: AVAssetImageGenerator = AVAssetImageGenerator.init(asset: urlAsset)
        
        //3、定义获取0帧处的视频截图
        let time: CMTime = CMTimeMake(1, 10) //缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
        var actucalTime: CMTime = CMTime() //缩略图实际生成的时间
        //4、获取time处的视频截图
        var cgImage: CGImage? = nil
        do {
            cgImage = try imageGenerator.copyCGImage(at: time, actualTime: &actucalTime)
        } catch {
            print("截取视频图片失败")
        }
        guard let ncgImage = cgImage else {return nil}
        
        //5、将 CGImageRef 转化为 UIImage
        let img: UIImage? = UIImage.init(cgImage: ncgImage)
        guard let nimage = img else {return nil}
        
        //6、将其存储到本地相册
        if enableSave == true {
            UIImageWriteToSavedPhotosAlbum(nimage, nil, nil, nil)
        }
        return nimage
    }
    
    
    //通过图片Data数据第一个字节 来获取图片扩展名
    func contentTypeForImageData(data: Data) {

        
    }
  
}




