//
//  RecordManager.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/24.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
    //mp3录音编码器
    var mp3Recorder: Mp3Recorder!
    
    //对象控制器
    var target: UIViewController!
    //文件名称
    var saveName: String?
    //代理对象
    var delegateTarget = AudioManagerDelegate()
    
    convenience init(target: UIViewController, saveName: String?) {
        self.init()
        self.target = target
        self.saveName = saveName
        
        delegateTarget.target = target        
        mp3Recorder = Mp3Recorder.init(delegate: delegateTarget, fileName: self.saveName ?? "")
    }
}

//MARK:- 录音编码事件
extension AudioManager {
    
    // 开始录音
    func startRecord() {
        mp3Recorder.startRecord()
    }
    
    // 停止录音
    func stopRecord() {
        mp3Recorder.stopRecord()
    }
    
    // 取消录音
    func cancelRecord() {
        mp3Recorder.cancelRecord()
    }
    
    // 获取地址
    func getOrigPath() -> String {
        return mp3Recorder.getOrigPath()
    }
    
    func getMp3Path() -> String {
        return mp3Recorder.getMp3Path()
    }
}

class AudioManagerDelegate: NSObject, Mp3RecorderDelegate, AVAudioPlayerDelegate {
    
    typealias RecordBack = ()-> Void
    typealias RecordingBack = (_ obj: Mp3Recorder?, _ recordTime: Float, _ volume: Float)-> Void
    typealias RecordEndBack = (_ data: Data?, _ path: String?)-> Void
    
    var failRecordBack: RecordBack?
    var beginConvertBack: RecordBack?
    var recordingBack: RecordingBack?
    var endConvertBack: RecordEndBack?
    
    //对象控制器
    var target: UIViewController!
    
    //MARK:- 录音解码器
    func failRecord() {
        if failRecordBack != nil {
            failRecordBack!()
        }
    }
    
    func beginConvert() {
        if beginConvertBack != nil {
            beginConvertBack!()
        }
    }
    
    func recording(_ mp3Recorder: Mp3Recorder!, recordTime: Float, volume: Float) {
        if recordingBack != nil {
            recordingBack!(mp3Recorder, recordTime, volume)
        }
    }
    
    func endConvert(with data: Data!, path: String!) {
        if endConvertBack != nil {
            endConvertBack!(data, path)
        }
    }
}
