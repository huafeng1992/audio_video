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
import AliyunOSSiOS

class VideoController: UIViewController {
    
//    let videoUrl = "http://192.168.1.72:8080/resources/low.mp4"
    
    let videoUrl = "https://github.com/huafeng1992/audio_video/blob/master/low.mp4"
    let size1Lab = UILabel()
    let size2Lab = UILabel()
    let showImgView = UIImageView()
    
    var assetData: PHAsset?
    
    var avasset1: AVAsset?
    var avasset2: AVAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Video"
        view.backgroundColor = .white
        
        
        // 移动端建议使用STS方式初始化OSSClient。可以通过sample中STS使用说明了解更多(https://github.com/aliyun/aliyun-oss-ios-sdk/tree/master/DemoByOC)
        let credential = OSSStsTokenCredentialProvider.init(accessKeyId: AccessKeyId, secretKeyId: AccessKeySecret, securityToken: "SecurityToken")
        let client = OSSClient.init(endpoint: endpoint, credentialProvider: credential)
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

extension VideoController: TZImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        print(photos.count)
        print(photos)
        showImgView.image = photos.first
        

        if let asset = assets![0] as? PHAsset {
            self.assetData = asset
        }
    }
    
    @objc func tapAction() {
        
        TZImageManager.default().getVideoWithAsset(self.assetData) { (playerItem, info) in

//            HFVideoManager.manager.avAssetExport(inAvAsset: playerItem?.asset, preset: AVAssetExportPresetMediumQuality, toFileType: .mp4, filename: "clear", fileFix: "H")
            
            let play = AVPlayerViewController()
            play.player = AVPlayer.init(playerItem: playerItem)
            play.showsPlaybackControls = true
            play.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
            self.present(play, animated: true, completion: {
                play.player?.play()
            })
        }
        
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPresetLowQuality, success: { (outputPath) in
//
//            print("AVAssetExportPresetLowQuality:\(ICSandboxHelper.fileSize(outputPath))")
//            let play = AVPlayerViewController()
//            play.player = AVPlayer.init(url: URL.init(fileURLWithPath: outputPath!))
//            play.showsPlaybackControls = true
//            play.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
//            self.present(play, animated: true, completion: nil)
//
//        }, failure: { (errorMessage, error) in
//
//        })
        
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPresetMediumQuality, success: { (outputPath) in
//
//            print("AVAssetExportPresetMediumQuality:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPresetHighestQuality, success: { (outputPath) in
//
//            print("AVAssetExportPresetHighestQuality:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPreset640x480, success: { (outputPath) in
//
//            print("AVAssetExportPreset640x480:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPreset960x540, success: { (outputPath) in
//
//            print("AVAssetExportPreset960x540:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPreset1280x720, success: { (outputPath) in
//
//            print("AVAssetExportPreset1280x720:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
//        TZImageManager.default().getVideoOutputPath(withAsset: self.assetData, presetName: AVAssetExportPreset1920x1080, success: { (outputPath) in
//
//            print("AVAssetExportPreset1920x1080:\(ICSandboxHelper.fileSize(outputPath))")
//        }, failure: { (errorMessage, error) in
//
//        })
        
        
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
