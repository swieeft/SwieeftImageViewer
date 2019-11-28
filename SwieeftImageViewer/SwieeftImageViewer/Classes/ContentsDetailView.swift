//
//  ContentsDetailView.swift
//  TodayHouseHomework
//
//  Created by Park GilNam on 06/11/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ContentsDetailView: UIView {

    // MARK: UI Init
    
    // 검은 뒷 배경
    lazy private var blackBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.alpha = 0
        
        return view
    }()
    
    // 이미지 줌 스크롤을 위한 스크롤뷰
    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        
        return scrollView
    }()
    
    // 컨텐츠 이미지 뷰
    lazy private var contentsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // 이미지 뷰 이동 제스처
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveImageAction(_:)))
        imageView.addGestureRecognizer(panGesture)
        
        // 이미지 뷰 더블 탭 제스처
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomImageAction(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
        
        return imageView
    }()
    
    // 컨텐츠 내용 라벨
    lazy private var contentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 3
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        // 컨텐츠 텍스트 라벨 확장 탭 제스처
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentsTextExpandingAction(_:)))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    // 라벨 하단 흰 라인
    lazy private var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return view
    }()
    
    // 종료 버튼
    lazy private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        
        // 버튼 이미지
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 5))
        path.addLine(to: CGPoint(x: 20, y: 20))
        path.move(to: CGPoint(x: 20, y: 5))
        path.addLine(to: CGPoint(x: 5, y: 20))
        
        let closeLayer = CAShapeLayer()
        closeLayer.path = path.cgPath
        closeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        closeLayer.strokeEnd = 1
        closeLayer.lineWidth = 2
        button.layer.addSublayer(closeLayer)
        
        // 버튼 액션
        button.addTarget(self, action: #selector(imageDetailCloseButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()

    // ContentsTableView에서 선택한 이미지 뷰 (시작과 종료 위치를 알기 위해 가지고 있음)
    weak var originImageView: UIImageView?
    
    // MARK: CustomView Init
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        contentsDetailViewInit()
    }
    
    required  init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentsDetailViewInit()
    }
    
    public init(parentView: UIView) {
        super.init(frame: parentView.bounds)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isHidden = true
        parentView.addSubview(self)
        
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        
        contentsDetailViewInit()
        setUI()
    }
    
    private func contentsDetailViewInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Methods
    // 화면 회전 시 contentsImageView 가운데 정렬
    @objc private func deviceRotated() {
        contentsImageView.center = center
    }
    
    // 종료 버튼 클릭 이벤트
    @objc private func imageDetailCloseButtonAction(sender: UIButton) {
        hide()
    }
    
    // 콘텐츠 텍스트 라벨 클릭 이벤트(라벨 확장)
    @objc private func contentsTextExpandingAction(_ sender: UITapGestureRecognizer) {
        if contentsLabel.numberOfLines == 0 {
            contentsLabel.numberOfLines = 3
            contentsLabel.backgroundColor = .clear
        } else {
            contentsLabel.numberOfLines = 0
            contentsLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        
        contentsLabel.sizeToFit()
    }
    
    // 이미지 이동 제스처
    @objc private func moveImageAction(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            break
        case .changed:
            contentsImageView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            let y = translation.y > 0 ? translation.y : (-1 * translation.y)
            blackBackgroundView.alpha = 1.0 - (y / (self.frame.height / 2))
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.closeButton.alpha = 0
                self?.contentsLabel.alpha = 0
                self?.lineView.alpha = 0
            }
            
        case .ended:
            if blackBackgroundView.alpha < 0.4 {
                hide()
            } else {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.contentsImageView.transform = .identity
                    self?.blackBackgroundView.alpha = 1
                    self?.closeButton.alpha = 1
                    self?.contentsLabel.alpha = 1
                    self?.lineView.alpha = 1
                }
            }
        default:
            break
        }
    }
    
    // 더블 탭 시 이미지 줌 인/아웃
    @objc private func zoomImageAction(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let zoomScale = self?.scrollView.zoomScale {
                self?.scrollView.zoomScale = zoomScale == 1.0 ? 4.0 : 1.0
                
                let alpha: CGFloat = zoomScale == 1.0 ? 0 : 1
                
                UIView.animate(withDuration: 0.2) {
                    self?.closeButton.alpha = alpha
                    self?.contentsLabel.alpha = alpha
                    self?.lineView.alpha = alpha
                }
            }
        }
    }
    
    // 이미지 상세보기 열기
    public func show(originImageView: UIImageView?, contentsText: String?) {
        if let imageView = originImageView,
            let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) {
            
            isHidden = false
            
            imageView.alpha = 0
            
            self.originImageView = imageView
            
            contentsImageView.frame = startingFrame
            contentsImageView.image = imageView.image
            
            contentsLabel.text = contentsText
            
            if contentsText != nil {
                contentsLabel.isHidden = false
                lineView.isHidden = false
            } else {
                contentsLabel.isHidden = true
                lineView.isHidden = true
            }
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                if let frame = self?.frame {
                    let height = (frame.height / startingFrame.width) * startingFrame.height
                    let y = frame.height / 2 - height / 2
                    
                    self?.contentsImageView.frame = CGRect(x: 0, y: y, width: frame.width, height: height)
                    
                    self?.blackBackgroundView.alpha = 1
                    self?.closeButton.alpha = 1
                }
            }
        }
    }
    
    // 이미지 상세보기 닫기
    private func hide() {
        // 종료 후 컨트롤 설정
        func closeComplete() {
            originImageView?.alpha = 1
            originImageView = nil
            blackBackgroundView.alpha = 1
            closeButton.alpha = 1
            contentsLabel.alpha = 1
            contentsLabel.text = nil
            lineView.alpha = 1
            contentsImageView.transform = .identity
            isHidden = true
        }
        
        if let zoomOriginImageView = self.originImageView,
            let startingFrame = zoomOriginImageView.superview?.convert(zoomOriginImageView.frame, to: nil) {
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.contentsImageView.frame = startingFrame
                self?.blackBackgroundView.alpha = 0
                self?.closeButton.alpha = 0
                self?.contentsLabel.alpha = 0
                self?.lineView.alpha = 0
                
            }) { (didComplete) in
                closeComplete()
            }
        } else {
            closeComplete()
        }
    }
    

}

// MARK: -- UI Setting
extension ContentsDetailView {
    private func setUI() {
        // 검은색 배경 뷰 세팅
        addSubview(blackBackgroundView)
        blackBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blackBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blackBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blackBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        // 이미지 줌 스크롤을 위한 스크롤 뷰 세팅
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        // 컨텐츠 이미지를 표현할 이미지 뷰 세팅
        scrollView.addSubview(contentsImageView)
        
        // 닫기 버튼 세팅
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        // 컨텐츠 텍스트 라벨 세팅
        addSubview(contentsLabel)
        contentsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        contentsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        contentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        // 하단 흰색 라인 뷰 세팅
        addSubview(lineView)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
}

extension ContentsDetailView: UIScrollViewDelegate {
   
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentsImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.closeButton.alpha = 0
            self?.contentsLabel.alpha = 0
            self?.lineView.alpha = 0
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        if scale == 1.0 {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.closeButton.alpha = 1
                self?.contentsLabel.alpha = 1
                self?.lineView.alpha = 1
            }
        }
    }
}
