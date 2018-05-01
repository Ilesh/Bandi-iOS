//
//  PopupView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/29/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class PopupView: NSObject {
    
    init(heightRatio: CGFloat, title: String) {
        super.init()
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "Window missing")
        }
        baseView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: (window.frame.height - UIApplication.shared.statusBarFrame.size.height) * heightRatio)
        headerTitle.text = title
        if heightRatio == 1 {
            darkView.isHidden = true
        }
        
        headerTitle.font = UIFont.boldSystemFont(ofSize: 17)
        headerTitle.textColor = .white
        
        headerBottomBorder.backgroundColor = .black
        
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        setupViews()
    }
    
    let darkView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let baseView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerBottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.clipsToBounds = false
        button.backgroundColor = .clear
        button.setTitleColor(Constants.Colors().primaryColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 10)
        return button
    }()
    
    func setupViews() {
        
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "Window missing")
        }
        
        window.addSubview(darkView)
        window.addSubview(baseView)
        baseView.addSubview(headerView)
        headerView.addSubview(headerTitle)
        headerView.addSubview(headerBottomBorder)
        headerView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            darkView.topAnchor.constraint(equalTo: window.topAnchor),
            darkView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            darkView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            darkView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: baseView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            headerBottomBorder.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerBottomBorder.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerBottomBorder.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerBottomBorder.heightAnchor.constraint(equalToConstant: 0.5),
            
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 80)
            ])
        
        doneButton.addTarget(self, action: #selector(doneButtonTouchUpInside), for: .touchUpInside)
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doneButtonTouchUpInside)))
        darkView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        
    }
    
    func setupContent(content: UIView) {
        baseView.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            content.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            ])
    }
    
    @objc func doneButtonTouchUpInside() {
        dismissPopupMenu()
    }
    
    func showPopupMenu() {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        baseView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkView.alpha = 1
            self.baseView.frame.origin.y = window.frame.height - self.baseView.frame.height
        })
    }
    
    func dismissPopupMenu() {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkView.alpha = 0
            self.baseView.frame.origin.y = window.frame.height
        }, completion: { completed in
            self.baseView.isHidden = true
        })
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let window = UIApplication.shared.keyWindow else {
            assert(false, "window missing")
        }
        let translation = panGesture.translation(in: baseView)
        panGesture.setTranslation(CGPoint.zero, in: baseView)
        let menuMinY = baseView.frame.minY
        let menuHeight = baseView.frame.height
        
        if menuMinY + translation.y >= window.frame.height - menuHeight {
            baseView.center = CGPoint(x: baseView.center.x, y: baseView.center.y + translation.y)
            darkView.alpha = (window.frame.height - menuMinY) / menuHeight
        }
        
        if panGesture.state == .ended {
            let pastEndMargin = menuMinY >= window.frame.height - menuHeight * 0.66
            
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.darkView.alpha = pastEndMargin ? 0 : 1
                self.baseView.frame.origin = CGPoint(x: 0, y: pastEndMargin ? window.frame.height : window.frame.height - menuHeight)
            })
        }
    }
    
}

