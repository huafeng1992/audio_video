//
//  HomeWorkImageCollectCell.swift
//  BaonahaoSchool
//
//  Created by huafeng on 2017/11/8.
//  Copyright © 2017年 XiaoHeTechnology. All rights reserved.
//

import Foundation

protocol HomeWorkImageCollectCellDelegate: NSObjectProtocol {
    func addImageButtonClick()
    func delegateImageButtonClick(model: HomeWorkCollectionItemModel, index: IndexPath)
}

//MARK:- 带删除的功能UICollectionViewCell
class HomeWorkImageCollectCell: UICollectionViewCell {
    
    weak var delegate: HomeWorkImageCollectCellDelegate?
    
    var index: IndexPath?
    
    var model: HomeWorkCollectionItemModel? {
        didSet {
            
            switch (model?.type)! {
            case .AddBtn:
                deleBtn?.isHidden = true
                photoView?.isHidden = true
                addImgBtn?.isHidden = false
                ishidenVideoIcons(true)
            case .Image:
                deleBtn?.isHidden = false
                photoView?.isHidden = false
                addImgBtn?.isHidden = true
                if let imageurl = model?.imageUrlString {
                    photoView?.sd_setImage(with: URL.init(string: imageurl), placeholderImage: photo_image)
                } else {
                    photoView?.image = model?.image
                }
                ishidenVideoIcons(true)
            case .Video:
                deleBtn?.isHidden = false
                photoView?.isHidden = false
                addImgBtn?.isHidden = true
                if let imageurl = model?.imageUrlString {
                    photoView?.sd_setImage(with: URL.init(string: imageurl), placeholderImage: photo_image)
                } else {
                    photoView?.image = model?.image
                }
                ishidenVideoIcons(false)
                videoTimeLab?.text = " 10'12\" "
            }
        }
    }
    
    weak var photoView: UIImageView?
    weak var deleBtn: UIButton?
    weak var addImgBtn: UIButton?
    
    weak var videoBtnView: UIImageView? // 视频播放按钮
    weak var videoTimeLab: UILabel?     // 视频时间Label
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeWorkImageCollectCell {
    
    func addAllView() {

        let photoView = UIImageView()
        photoView.backgroundColor = CommonColor(ColorF0EFF5)
        photoView.contentMode = .scaleAspectFill
        photoView.layer.borderColor = CommonColor(Colorf0f0f0).cgColor
        photoView.layer.borderWidth = 0.5
        photoView.image = photo_image
        photoView.clipsToBounds = true
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.left.bottom.equalToSuperview()
        }
        self.photoView = photoView
        
        let videoBtnView = UIImageView()
        videoBtnView.image = R.image.player_smallicon()
        videoBtnView.isHidden = true
        photoView.addSubview(videoBtnView)
        videoBtnView.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        self.videoBtnView = videoBtnView
        
        let videoTimeLab = UILabel()
        videoTimeLab.textColor = .white
        videoTimeLab.layer.cornerRadius = 2
        videoTimeLab.layer.masksToBounds = true
        videoTimeLab.font = CommomFont(9)
        videoTimeLab.backgroundColor = UIColor.colorWithHexString(hex: "#000000", alph: 0.4)
        photoView.addSubview(videoTimeLab)
        videoTimeLab.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(5)
            $0.height.equalTo(15)
        }
        self.videoTimeLab = videoTimeLab
        
        let deleBtn = UIButton()
        deleBtn.setImage(R.image.homework_delete_icon(), for: .normal)
        contentView.addSubview(deleBtn)
        deleBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(20)
        }
        self.deleBtn = deleBtn
        
        let addImgBtn = UIButton()
        addImgBtn.setTitle("添加图片", for: .normal)
        addImgBtn.setTitleColor(CommonColor(SystemColor), for: .normal)
        addImgBtn.titleLabel?.font = CommomFont(12)
        addImgBtn.setImage(R.image.homework_add_icon(), for: .normal) 
        addImgBtn.isHidden = true
        addImgBtn.backgroundColor = CommonColor(ColorF0EFF5)
        contentView.addSubview(addImgBtn)
        addImgBtn.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(photoView)
        }
        self.addImgBtn = addImgBtn
        contentView.layoutIfNeeded()
        addImgBtn.buttonCategoryTypeBottom(mars: 6)
        
        addImgBtn.addTarget(self, action: #selector(addImgBtnAction(btn:)), for: .touchUpInside)
        deleBtn.addTarget(self, action: #selector(deleBtnAction(btn:)), for: .touchUpInside)
    }
    
    @objc func addImgBtnAction(btn: UIButton) {
        delegate?.addImageButtonClick()
    }
    
    @objc func deleBtnAction(btn: UIButton) {
        delegate?.delegateImageButtonClick(model: model!, index: index!)
    }
    
    fileprivate func ishidenVideoIcons(_ isBool: Bool) {
        videoBtnView?.isHidden = isBool
        videoTimeLab?.isHidden = isBool
    }
}











