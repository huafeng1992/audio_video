//
//  HFVideoManager.swift
//  音频视频
//
//  Created by 王华峰 on 2018/6/1.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

class HFVideoManager: NSObject {
    
    static let manager = HFVideoManager()
//    var filename: String = {
//        let filename = ""
//        return filename
//    }()
}

extension HFVideoManager {
    
    func avAssetExport(inAvAsset avAsset: AVAsset?, preset: String, filename: String?) {
    }
    
    // 转换视频 completionHandler 回掉转换状态
    func avAssetExport(inAvAsset avAsset: AVAsset?, preset: String, toFileType: AVFileType, filename: String?, fileFix: String, completionHandler: @escaping (AVAssetExportSessionStatus) -> Void ) {
        if let exportSession = export(inAvAsset: avAsset, preset: preset, toFileType: toFileType, filename: filename, fileFix: fileFix) {
            exportSession.exportAsynchronously {
                completionHandler(exportSession.status)
            }
        }
    }
    
    func avAssetExport(inAvAsset avAsset: AVAsset?, preset: String, toFileType: AVFileType, filename: String?, fileFix: String) {
        
        if let exportSession = export(inAvAsset: avAsset, preset: preset, toFileType: toFileType, filename: filename, fileFix: fileFix) {
            
            exportSession.exportAsynchronously {
                switch (exportSession.status) {
                    
                case .unknown:
                    print("AVAssetExportSessionStatus.unknown")
                case .waiting:
                    print("AVAssetExportSessionStatus.waiting")
                case .exporting:
                    print("AVAssetExportSessionStatus.exporting")
                case .completed:
                    print("AVAssetExportSessionStatus.completed")
                case .failed:
                    print("AVAssetExportSessionStatus.failed")
                case .cancelled:
                    print("AVAssetExportSessionStatus.cancelled")
                }
            }
        }
    }
    
    func export(inAvAsset avAsset: AVAsset?, preset: String, toFileType: AVFileType, filename: String?, fileFix: String) -> AVAssetExportSession? {
        
        guard let avAsset = avAsset else {
            print(FUNCTION_PASCAL)
            return nil
        }
        
        // 可获取的视频质量
        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: avAsset)
        guard compatiblePresets.contains(preset) else {
            print("没有该资源获取方式")
            return nil
        }
        
        // 创建 AVAssetExportSession 对象
        let exportSession = AVAssetExportSession.init(asset: avAsset, presetName: preset)
        
        let fileHomePath = NSTemporaryDirectory() // 此目录后必须带"/" 用来隔开其它文件地址
        var path = ""
        
        // 判断video_output文件地址是否存在 不存在则创建
        let video_output = "\(fileHomePath)video_output"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: video_output) {
            do {
                try! fileManager.createDirectory(atPath: video_output, withIntermediateDirectories: true, attributes: nil)
            }
        }
        if filename == nil { //用时间给文件全名，以免重复
            let formater = DateFormatter.init()
            formater.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            path = "\(video_output)/\(fileFix)\(formater.string(from: Date()))"
            print(path)
        } else {
            path = "\(video_output)/\(fileFix)\(filename!)"
            print(path)
        }
        
        path = "\(path).mp4"
        //
        exportSession!.outputURL = URL.init(fileURLWithPath: path)
        exportSession!.outputFileType = toFileType
        exportSession!.shouldOptimizeForNetworkUse = true  // 优化文件用以网络使用
        return exportSession!
    }
    
    
}
