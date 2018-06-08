//
//  VideoController.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/24.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import Photos
import TZImagePickerController
import AVKit

import MBProgressHUD
import SVProgressHUD




class VideoController: UIViewController {
    
    let videoUrl = "http://a-image-demo.oss-cn-qingdao.aliyuncs.com/demo.mp4"
    let videoPre = "http://a-image-demo.oss-cn-qingdao.aliyuncs.com/demo.mp4?x-oss-process=video/snapshot,t_7000,f_jpg,w_800,h_600,m_fast"
    let size1Lab = UILabel()
    let size2Lab = UILabel()
    let showImgView = UIImageView()
    
    var assetData: PHAsset?
    
    var avasset1: AVAsset?
    var avasset2: AVAsset?
    
    var medias = [Media]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Video"
        view.backgroundColor = .white
//        SVProgressHUD.setBackgroundColor(UIColor.green)
//        SVProgressHUD.setMinimumSize(.init(width: kw, height: kh))
//        let newview = UIView()
//        newview.backgroundColor = .red
//
        SVProgressHUD.setDefaultMaskType(.clear)
    
//        // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
//        let credential = OSSStsTokenCredentialProvider.init(accessKeyId: AccessKeyId, secretKeyId: AccessKeySecret, securityToken: "SecurityToken")
//        let client = OSSClient.init(endpoint: endpoint, credentialProvider: credential)
        //        client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
        
        
        setUI()
    }
}

extension VideoController {
    
    func startvideo() {
        
//        let ipc = UIImagePickerController.init()
//        ipc.sourceType = .camera
//
//        let availableMedia: Array<String> = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)!
//        ipc.mediaTypes = availableMedia
//        self.present(ipc, animated: true, completion: nil)
//        ipc.delegate = self
    }
    
    func choosevideo() {
        
        let imagePickController = TZImagePickerController.init(maxImagesCount: 9, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickController?.allowTakePicture = true //是否在相册中显示拍照按钮
        imagePickController?.allowTakeVideo = true
        imagePickController?.videoMaximumDuration = 10
        imagePickController?.allowPickingOriginalPhoto = false //是否可以选择显示原图
        imagePickController?.allowPickingVideo = true //是否在相册中可以选择视频
        imagePickController?.allowPickingMultipleVideo = true //多选视频
        imagePickController?.showSelectBtn = true
        imagePickController?.showPhotoCannotSelectLayer = true
        imagePickController?.cannotSelectLayerColor = .white
        present(imagePickController!, animated: true, completion: nil)
    }
}

extension VideoController: TZImagePickerControllerDelegate, MediaBrowserDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        print(photos.count)
        print(photos)
        showImgView.image = photos.first
        

        if let asset = assets![0] as? PHAsset {
            self.assetData = asset
        }
        
        medias.removeAll()
        
        
        let media = Media.init(videoURL: URL.init(string: videoUrl)!, previewImageURL: URL.init(string: videoPre))
        medias.append(media)
        
        for asset in assets {
            
            let asset = asset as! PHAsset
            
            let media = Media.init(asset: asset, targetSize: CGSize.init(width: kw, height: kh))
            medias.append(media)
        }
        
    }
    
    @objc func tapAction() {
        
        
//        let playerItem = AVPlayerItem.init(url: URL.init(string: videoUrl)!)
//
//        let play = AVPlayerViewController()
//        play.player = AVPlayer.init(playerItem: playerItem)
//        play.showsPlaybackControls = true
//        play.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
//        self.present(play, animated: true, completion: {
//            play.player?.play()
//        })
        
//        TZImageManager.default().getVideoWithAsset(self.assetData) { (playerItem, info) in
//
////            HFVideoManager.manager.avAssetExport(inAvAsset: playerItem?.asset, preset: AVAssetExportPresetMediumQuality, toFileType: .mp4, filename: "clear", fileFix: "H")
//
////            let play = AVPlayerViewController()
////            play.player = AVPlayer.init(playerItem: playerItem)
////            play.showsPlaybackControls = true
////            play.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
////            self.present(play, animated: true, completion: {
////                play.player?.play()
////            })
//
//        }
        
//        let browser = MediaBrowser(delegate: self)
//        browser.displayActionButton = false
//        browser.displayMediaNavigationArrows = false
//        browser.displaySelectionButtons = false
//        browser.alwaysShowControls = false
//        browser.zoomPhotosToFill = true
//        browser.enableGrid = false
//        browser.startOnGrid = false
//        browser.enableSwipeToDismiss = true
//        browser.autoPlayOnAppear = false
//        browser.cachingImageCount = 2
//        browser.setCurrentIndex(at: 0)
//
//        let nc = UINavigationController.init(rootViewController: browser)
//        nc.modalTransitionStyle = .crossDissolve
//        self.present(nc, animated: true, completion: nil)
        
   
        PhotoImagePickerManager.manager.getMediaInfoFromAsset(asset: self.assetData) { (name, data, avAsset) in
            
            print("-------*上传中*-------")
            SVProgressHUD.show()
            let ossModel = OSSManagerModel.init(upType: .data, bucketName: BUCKET_NAME, objectkey_prefix: "test", dataType: .videos, objectkey_name: .homework, objectkey_md5path: "视频测试1")
            ossModel.data = data as! Data
            
            let ossModel1 = OSSManagerModel.init(upType: .data, bucketName: BUCKET_NAME, objectkey_prefix: "test", dataType: .videos, objectkey_name: .homework, objectkey_md5path: "视频测试2")
            ossModel1.data = data as! Data
            
            AXOSSManager.queue(putObjArray: [ossModel, ossModel1], allComplete: {
                SVProgressHUD.dismiss()
                print("-------*成功上传*-------")
            }, error: {
                
            })
        }
        
        
    }
    
    
//    MediaBrowserDelegate
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
//        if index < medias.count {
            return medias[index]
//        }
//        let media = Media.init(videoURL: URL.init(string: videoUrl)!, previewImageURL: URL.init(string: "http://img.zcool.cn/community/010f87596f13e6a8012193a363df45.jpg@1280w_1l_2o_100sh.jpg"))
//        return media
    }
    
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return medias.count
    }
    
    func didDisplayMedia(at index: Int, in mediaBrowser: MediaBrowser) {
        print("Did start viewing photo at index \(index)")
        
    }
}

extension VideoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        picker.dismiss(animated: true, completion: nil)
    }

}

//MARK:- UI
extension VideoController: ActionSheetDelegate {
    
    func setUI() {
        
        let btn = UIButton()
        btn.setTitle("打开相机", for: .normal)
        btn.backgroundColor = .blue
        view.addSubview(btn)
        btn.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.bottom.equalToSuperview().offset(-30)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        btn.addTarget(self, action: #selector(openAlertSheet), for: .touchUpInside)
        
        
        size1Lab.text = "原始大小："
        view.addSubview(size1Lab)
        size1Lab.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(100)
        }
        size2Lab.text = "编码大小："
        view.addSubview(size2Lab)
        size2Lab.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(size1Lab.snp.bottom).offset(10)
        }
        
        showImgView.backgroundColor = .yellow
        showImgView.contentMode = .scaleAspectFill
        showImgView.layer.masksToBounds = true
        showImgView.isUserInteractionEnabled = true
        view.addSubview(showImgView)
        showImgView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(size2Lab.snp.bottom).offset(20)
            $0.width.height.equalTo(90)
        }
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        showImgView.addGestureRecognizer(tap)
        
    }
    
    @objc func openAlertSheet() {
        
        let sheet = ActionSheet.init(delegate: self, cancelTitle: "取消", otherTitles: ["打开相机", "打开相册"])
        sheet.show()
    }
    
    func actionSheet(actionSheet: ActionSheet?, didClickedAt index: Int) {
        
        if index == 0 {
            startvideo()
        }
        
        if index == 1 {
            choosevideo()
        }
    }
}



//extension VideoController {
//
//    func startvideo() {
//
//        let ipc = UIImagePickerController.init()
//        ipc.sourceType = .camera
//
//        let availableMedia: Array<String> = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)!
//        ipc.mediaTypes = availableMedia
//        self.present(ipc, animated: true, completion: nil)
//        ipc.delegate = self
//    }
//
//    func choosevideo() {
//        let ipc = UIImagePickerController.init()
//        ipc.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum //sourcetype有三种分别是camera，photoLibrary和photoAlbum
//
//        //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
//        let availableMedia: Array<String> = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)!
//        ipc.mediaTypes = [availableMedia[1]]
//        self.present(ipc, animated: true, completion: nil)
//        ipc.delegate = self
//    }
//}
