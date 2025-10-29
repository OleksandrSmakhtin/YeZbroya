//
//  DetailedPhotoView.swift
//  YeOzbroyenniaNS
//
//  Created by Oleksandr Smakhtin on 28/09/2025.
//

import UIKit
import SDWebImage

protocol DetailedPhotoViewDelegate: AnyObject {
    func closeView()
}

class DetailedPhotoView: UIView {
    
    weak var delegate: DetailedPhotoViewDelegate?
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // scroll view test
    private let imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 5.0
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let photoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = UIColor(named: "tableColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.addTarget(nil, action: #selector(closeView), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Actions
    @objc private func closeView() {
        delegate?.closeView()
    }

    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // add subviews
        addSubviews()
        // apply constraints
        applyConstraints()
        // delegate
        imageScrollView.delegate = self
    }
    
    
    //MARK: - Add Suviews
    private func addSubviews() {
        addSubview(blurView)
        //
        addSubview(imageScrollView)
        imageScrollView.addSubview(photoView)
        addSubview(circleView)
        addSubview(closeButton)
    }
    
    //MARK: - Apply Constraints
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        //
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            photoView.widthAnchor.constraint(equalTo: widthAnchor),
            photoView.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
            photoView.centerYAnchor.constraint(equalTo: imageScrollView.centerYAnchor)
        ])
        
        
        
        NSLayoutConstraint.activate([
            circleView.heightAnchor.constraint(equalToConstant: 50),
            circleView.widthAnchor.constraint(equalToConstant: 50),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: circleView.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: circleView.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: circleView.topAnchor),
            closeButton.bottomAnchor.constraint(equalTo: circleView.bottomAnchor)
        ])
    }
    
    
    //MARK: - Configure
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageScrollView.setZoomScale(1.0, animated: false)
        imageScrollView.contentOffset = .zero
        imageScrollView.contentInset = .zero
        photoView.sd_setImage(with: url)
        
        
    }

    
    //MARK: - Coder
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DetailedPhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return photoView
        }

}
