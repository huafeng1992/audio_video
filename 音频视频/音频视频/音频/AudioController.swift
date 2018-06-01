//
//  AudioController.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/29.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController: UIViewController {
    
    var timeLab: UILabel!
    var startBtn: UIButton!
    var stopBtn: UIButton!
    var playBtn: UIButton!
    var playBtn2: UIButton!
    
    var size1Lab: UILabel!
    var size2Lab: UILabel!
    
    let timerStr = "时间："
    
    var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
    var volumLab: UILabel! //显示录音音量
    
    var recorder: AudioManager!
    var audioPlayer: AudioPlayerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Audio"
        view.backgroundColor = .white
        
        recorder = AudioManager.init(target: self, saveName: "test")
        
        recorder.delegateTarget.beginConvertBack = {
            print("recorder.delegateTarget?.beginConvertBack")
        }
        
        recorder.delegateTarget.failRecordBack = {
            print("recorder.delegateTarget?.failRecordBack")
        }
        
        recorder.delegateTarget.recordingBack = { [weak self] (obj, recordTime, volume) in
            print("recorder.delegateTarget?.recordingBack")
            self?.timeLab.text = "录制时间：\(recordTime)"
            
            if recordTime >= 10 && self != nil {
                self!.recorder.stopRecord()
                print("只能录10秒")
            }
        }
        
        recorder.delegateTarget.endConvertBack = {(data, path) in
            print(path)
        }
        
        audioPlayer = AudioPlayerManager.init(target: self)
        
        audioPlayer.delegateTarget.audioPlayerDidFinish = {(player, flag) in
            print("播放完了")
        }
        
        audioPlayer.delegateTarget.audioPlayerDidOccur = {(player, error) in
            
        }
        
        setUI()
    }
}

extension AudioController {
    
    @objc func startBtnClick() {
        recorder.startRecord()
    }
    
    @objc func stop() {
        recorder.stopRecord()
    }
    
    @objc func playBtnClick() {
        
        recorder.stopRecord()
        
        let path = recorder.getOrigPath()
        size1Lab.text = "原始大小：\(audioPlayer.getSize(path))"
        audioPlayer.playAudio(path)
    }
    
    @objc func playBtnClick2() {
        
        recorder.stopRecord()
        
        let path = recorder.getMp3Path()
        
        size2Lab.text = "编码大小：\(audioPlayer.getSize(path))"
        audioPlayer.playAudio(path)
    }
}

//MARK:- UI
extension AudioController {
    
    private func setUI() {
        
        timeLab = UILabel()
        timeLab.textColor = .red
        timeLab.text = timerStr
        view.addSubview(timeLab)
        timeLab.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        size1Lab = UILabel()
        view.addSubview(size1Lab)
        size1Lab.snp.makeConstraints{
            $0.left.equalTo(timeLab)
            $0.right.equalTo(timeLab)
            $0.height.equalTo(40)
            $0.top.equalTo(timeLab.snp.bottom)
        }
        
        size2Lab = UILabel()
        view.addSubview(size2Lab)
        size2Lab.snp.makeConstraints{
            $0.left.equalTo(timeLab)
            $0.right.equalTo(timeLab)
            $0.height.equalTo(40)
            $0.top.equalTo(size1Lab.snp.bottom)
        }
        
        size1Lab.text = "原始大小："
        size2Lab.text = "编码大小："
        
        startBtn = UIButton.init()
        startBtn.backgroundColor = .blue
        startBtn.setTitle("开始", for: .normal)
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints{
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.top.equalToSuperview().offset(300)
            $0.right.equalToSuperview().offset(-20)
        }
        
        stopBtn = UIButton.init()
        stopBtn.backgroundColor = .blue
        stopBtn.setTitle("暂停", for: .normal)
        view.addSubview(stopBtn)
        stopBtn.snp.makeConstraints{
            $0.top.equalTo(startBtn.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-20)
        }
        
        playBtn = UIButton.init()
        playBtn.backgroundColor = .blue
        playBtn.setTitle("原文件播放", for: .normal)
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints{
            $0.top.equalTo(stopBtn.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-20)
        }
        
        playBtn2 = UIButton.init()
        playBtn2.backgroundColor = .blue
        playBtn2.setTitle("编码文件播放", for: .normal)
        view.addSubview(playBtn2)
        playBtn2.snp.makeConstraints{
            $0.top.equalTo(playBtn.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-20)
        }
        
        volumLab = UILabel()
        volumLab.text = "录音音量"
        volumLab.textColor = .black
        view.addSubview(volumLab)
        volumLab.snp.makeConstraints{
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.top.equalTo(playBtn2.snp.bottom).offset(40)
        }
        
        startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        stopBtn.addTarget(self, action: #selector(stop), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        playBtn2.addTarget(self, action: #selector(playBtnClick2), for: .touchUpInside)
    }
    
}
