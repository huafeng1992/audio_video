//
//  AudioController.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/24.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController: UIViewController {
    
    var timeLab: UILabel!
    var startBtn: UIButton!
    var pauseBtn: UIButton!
    var playBtn: UIButton!
    let timerStr = "时间："
    
    
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
    var aacPath: String?   //录音地址
    var volumLab: UILabel! //显示录音音量
    
    var audioAsset: AVURLAsset!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Audio"
        view.backgroundColor = .white
        
        //组合录音文件路径
        aacPath = "\(ICSandboxHelper.libCachePath()!)/audio"
        setUI()
        audioPerpar()
    }
    
    @objc func startBtnClick() {
        
        //初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,
                                        settings: recorderSeetingsDic!)
        if recorder != nil {
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
            //启动定时器，定时更新录音音量
//            volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
//                                               selector: #selector(levelTimer),
//                                               userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func pauseBtnClick() {
        //停止录音
        recorder?.stop()
        //录音器释放
        recorder = nil
        //暂停定时器
//        volumeTimer.invalidate()
//        volumeTimer = nil
        volumLab.text = "录音音量:0"
    }
    
    @objc func playBtnClick() {
    
        pauseBtnClick()
        
        //播放
        player = try! AVAudioPlayer(contentsOf: URL(string: aacPath!)!)
        if player == nil {
            print("播放失败")
        }else{
            //让音频通过喇叭播放
            try! AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            player?.play()
            audioTime()
        }
    }
    
    @objc func levelTimer() {
        recorder!.updateMeters() // 刷新音量数据
//        let averageV:Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let maxV:Float = recorder!.peakPower(forChannel: 0) //获取音量最大值
        let lowPassResult:Double = pow(Double(10), Double(0.05*maxV))
        volumLab.text = "录音音量:\(lowPassResult)"
    }
    
    func audioTime() {
        
//        let url = URL.init(fileURLWithPath: aacPath!)
//        let asset = AVURLAsset.init(url: url, options: nil)
        
        
        
        let duration = player!.duration
        timeLab.text = "音频时长:\(duration)"
        timeLab.text = "音频时长:\(ICSandboxHelper.getMMSSFromSS("\(duration)")!)"
        
        print(timeLab.text)
        
        
//        let data = Data.init(contentsOf: URL.init(fileURLWithPath: URL.init(fileURLWithPath: aacPath!)), options: nil)
        let size = ICSandboxHelper.fileSize(atPath: aacPath!)
        let size1 = ICSandboxHelper.fileSize(aacPath!)
        
        
        print(size)
        print(size1)
        
    }
    
}

extension AudioController {
    
    func audioPerpar() {
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //设置支持后台
        try! session.setActive(false)
        
        //初始化字典并添加设置参数
        recorderSeetingsDic = [AVFormatIDKey: NSNumber.init(value: kAudioFormatMPEG4AAC),
                               AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                               AVEncoderAudioQualityKey: 320000,
                               AVSampleRateKey: 44100.0] //录音器每秒采集的录音样本数
        

//        recorderSeetingsDic = [AVSampleRateKey:  NSNumber.init(value: 44100.0), //           采样率  8000/11025/22050/44100/96000（影响音频的质量）
//                               AVFormatIDKey: kAudioFormatMPEG4AAC, // 音频格式
////                               AVLinearPCMBitDepthKey: 16, // 采样位数  8、16、24、32 默认为16
//                               AVNumberOfChannelsKey: 2, // 音频通道数 1 或 2
//                               AVEncoderAudioQualityKey: 320000] // 录音质量
        
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
        
        pauseBtn = UIButton.init()
        pauseBtn.backgroundColor = .blue
        pauseBtn.setTitle("暂停", for: .normal)
        view.addSubview(pauseBtn)
        pauseBtn.snp.makeConstraints{
            $0.top.equalTo(startBtn.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-20)
        }
        
        playBtn = UIButton.init()
        playBtn.backgroundColor = .blue
        playBtn.setTitle("播放", for: .normal)
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints{
            $0.top.equalTo(pauseBtn.snp.bottom).offset(40)
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
            $0.top.equalTo(playBtn.snp.bottom).offset(40)
        }
        
        
//        startBtn.addTarget(self, action: #selector(longTapAction), for: .touchUpInside)
        startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseBtnClick), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
    }
    
}








