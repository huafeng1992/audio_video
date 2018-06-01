//
//  AlertSheet.swift
//  BaonahaoSchool
//
//  Created by huafeng on 2017/11/15.
//  Copyright © 2017年 XiaoHeTechnology. All rights reserved.
//

import Foundation

fileprivate let ActionSheetCancelTag = 1999
fileprivate let ActionSheetBaseTag = 1000
fileprivate let ActionSheetAnimationDuration: TimeInterval = 0.25
fileprivate let fontSize: CGFloat = 14
fileprivate let toolBarH: CGFloat = 50

let K_Window: UIWindow? = (UIApplication.shared.delegate?.window)!

extension UIColor{
    func getAlpha() -> CGFloat {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return a
        }
        
        guard let cmps = self.cgColor.components else {
            return 1
        }
        return cmps[3]
    }
    
    class func hexInt(_ hexValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

protocol ActionSheetDelegate: NSObjectProtocol {
    func actionSheet(actionSheet: ActionSheet?, didClickedAt index: Int)
}

class ActionSheet: UIView {
    weak var delegate: ActionSheetDelegate?
    
    var name:String?
    
    fileprivate lazy var btnArr: [UIButton] = [UIButton]()
    
    fileprivate lazy var dividerArr: [UIView] = [UIView]()
    
    fileprivate lazy var coverView: UIView = { [unowned self] in
        let coverView = UIView()
        coverView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverViewDidClick)))
        return coverView
        }()
    
    fileprivate lazy var actionSheet: UIView = {
        let actionSheet = UIView()
        actionSheet.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return actionSheet
    }()
    
    fileprivate lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.tag = ActionSheetCancelTag
        cancelBtn.backgroundColor = UIColor(white: 1, alpha: 1)
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        cancelBtn.setTitleColor(.darkGray, for: .normal)
        cancelBtn.addTarget(self, action: #selector(actionSheetClicked(_:)), for: .touchUpInside)
        return cancelBtn
    }()
    
    class func showActionSheet(with delegate: ActionSheetDelegate?, title: String? = nil, cancelTitle: String, otherTitles: [String]) -> ActionSheet {
        return ActionSheet(delegate: delegate, title: title,cancelTitle: cancelTitle, otherTitles: otherTitles)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(delegate: ActionSheetDelegate?, title: String? = nil,cancelTitle: String, otherTitles: [String]) {
        super.init(frame: CGRect.zero)
        btnArr.removeAll()
        dividerArr.removeAll()
        self.backgroundColor = .clear
        self.delegate = delegate
        self.addSubview(coverView)
        self.coverView.addSubview(actionSheet)
        if (title?.count ?? 0) > 0{
            self.createBtn(with: title!, bgColor: UIColor(white: 1, alpha: 1), titleColor: .lightGray, tagIndex: 0)
        }
        for i in 0..<otherTitles.count {
            self.createBtn(with: otherTitles[i], bgColor: UIColor(white: 1, alpha: 1), titleColor: .darkGray, tagIndex: i + ActionSheetBaseTag)
        }
        cancelBtn.setTitle(cancelTitle, for: .normal)
        self.actionSheet.addSubview(cancelBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createBtn(with title: String?, bgColor: UIColor?, titleColor: UIColor?, tagIndex: Int) {
        let actionBtn = UIButton(type: .custom)
        actionBtn.tag = tagIndex
        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize) + (tagIndex == 0 ? -3 : 0))
        actionBtn.backgroundColor = bgColor
        actionBtn.titleLabel?.textAlignment = .center
        actionBtn.setTitle(title, for: .normal)
        actionBtn.setTitleColor(titleColor, for: .normal)
        actionBtn.addTarget(self, action: #selector(actionSheetClicked(_:)), for: .touchUpInside)
        self.actionSheet.addSubview(actionBtn)
        self.btnArr.append(actionBtn)
        
        let divider = UIView()
        divider.backgroundColor = UIColor.hexInt(0xebebeb)
        actionBtn.addSubview(divider)
        dividerArr.append(divider)
    }
    
    @objc fileprivate func coverViewDidClick() {
        self.dismiss()
    }
    
    @objc fileprivate func actionSheetClicked(_ btn: UIButton) {
        if btn.tag != ActionSheetCancelTag && btn.tag >= ActionSheetBaseTag{
            self.delegate?.actionSheet(actionSheet: self, didClickedAt: btn.tag - ActionSheetBaseTag)
            self.dismiss()
        } else {
            self.dismiss()
        }
    }
    
    func show() {
        if self.superview != nil { return }
        
        
        self.frame = (K_Window?.bounds)!
        K_Window?.addSubview(self)
        
        coverView.frame = CGRect(x: 0, y: 0, width: kw, height: kh)
        
        let actionH = CGFloat(self.btnArr.count + 1) * toolBarH + 5.0
        actionSheet.frame = CGRect(x: 0, y: self.frame.height, width: kw, height: actionH)
        
        cancelBtn.frame = CGRect(x: 0, y: actionH - toolBarH, width: self.frame.width, height: toolBarH)
        
        let btnW: CGFloat = self.frame.width
        let btnH: CGFloat = toolBarH
        let btnX: CGFloat = 0
        var btnY: CGFloat = 0
        for i in 0..<btnArr.count {
            let btn = btnArr[i]
            let divider = dividerArr[i]
            btnY = toolBarH * CGFloat(i)
            btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
            divider.frame = CGRect(x: btnX, y: btnH - 1, width: btnW, height: 1)
        }
        
        UIView.animate(withDuration: ActionSheetAnimationDuration) {
            self.actionSheet.frame.origin.y = self.frame.height - self.actionSheet.frame.height
        }
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: ActionSheetAnimationDuration, animations: {
            self.actionSheet.frame.origin.y = self.frame.height
        }) { (_) in
            if self.superview != nil {
                self.removeFromSuperview()
            }
        }
    }
}


