//
//  AudioPlayerManager.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/29.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayerManager: NSObject {
    //audio播放器
    var player:AVAudioPlayer?
    
    //代理对象
    var delegateTarget = AudioPlayerManagerDelegate()
    
    convenience init(target: UIViewController) {
        self.init()
        
        delegateTarget.target = target
    }
}

//MARK:- 播放器事件
extension AudioPlayerManager {
    
    // 播放 播放前要停止录音  保证地址存在
    func playAudio(_ path: String?) {

        guard let path_url = path else {
            return
        }
        
        if !ICSandboxHelper.isPath(path_url) {
            return
        }
        
        //播放
        player = try! AVAudioPlayer(contentsOf: URL(string: path_url)!)
        if player == nil {
            print("播放失败")
        }else{
            //让音频通过喇叭播放
            //            try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            player!.play()
            player!.delegate = delegateTarget
        }
    }
    
    func getSize(_ path: String) -> String {
        let size = ICSandboxHelper.fileSize(path)
        return size ?? ""
    }
    
    func getTime(_ path: String) -> TimeInterval {
        if player != nil {
            return player?.duration ?? 0
        }
        return 0
    }
    
}

//MARK:- 播放器
class AudioPlayerManagerDelegate: NSObject, AVAudioPlayerDelegate {
    
    //对象控制器
    var target: UIViewController!
    
    var audioPlayerDidFinish: ((_ player: AVAudioPlayer, _ flag: Bool) -> Void)?
    var audioPlayerDidOccur: ((_ player: AVAudioPlayer, _ error: Error?) -> Void)?
    
    //(播放完成)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if audioPlayerDidFinish != nil {
            audioPlayerDidFinish!(player, flag)
        }
    }
    
    //(解码结束)
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if audioPlayerDidOccur != nil {
            audioPlayerDidOccur!(player, error)
        }
    }
}
