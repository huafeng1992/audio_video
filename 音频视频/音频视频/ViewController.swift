//
//  ViewController.swift
//  音频视频
//
//  Created by 王华峰 on 2018/5/24.
//  Copyright © 2018年 hf. All rights reserved.
//

import UIKit

let kw = UIScreen.main.bounds.size.width
let kh = UIScreen.main.bounds.size.height


class ViewController: UIViewController {
    
    enum TYPE: String {
        case video = "视频"
        case audio = "音频"
        
        var vcname: String {
            switch self {
            case .video:
                return "VideoController"
            case .audio:
                return "AudioController"
            }
        }
    }
    
    var dataArray: Array<TYPE> = [.audio, .video]
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = .init(x: 0, y: 0, width: kw, height: kh);
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        
        imageView.animationImages = [UIImage.init(named: "icon_1"), UIImage.init(named: "icon_2"), UIImage.init(named: "icon_3")] as? [UIImage]
        imageView.animationRepeatCount = 0
        imageView.animationDuration = 0.5
        imageView.startAnimating()
        imageView.stopAnimating()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let type = dataArray[indexPath.row]
        cell.textLabel?.text = type.rawValue
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type: TYPE = dataArray[indexPath.row]
        switch type {
        case .audio:
            let audio = AudioController()
            show(audio, sender: nil)
        case .video:
            let video = VideoController()
            show(video, sender: nil)
        }
    }
    
}



