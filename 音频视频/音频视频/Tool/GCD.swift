//
//  GCD.swift
//  音频视频
//
//  Created by 王华峰 on 2018/6/7.
//  Copyright © 2018年 hf. All rights reserved.
//

import Foundation

class CGDManager {
    
    func asy() {
        //获取系统存在的全局队列
        let queue = DispatchQueue.global(qos: .default)
        //定义一个group
        let group = DispatchGroup()
        
        queue.async(group: group) {
            
            
        }
        
        //1,所有任务执行结束汇总，不阻塞当前线程
        group.notify(queue: .global(), execute: {
            print("group done")
        })
        
        group.wait()   
        
    }
    
}
