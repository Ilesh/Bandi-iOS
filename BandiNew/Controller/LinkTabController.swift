//
//  LinkTabController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 4/28/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class LinkTabController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        setupViews()
    }
    
    let containingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = false
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let linkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("bandi.link", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = Constants.Colors().primaryColor
        button.clipsToBounds = true
        button.layer.cornerRadius = 25
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        //let tabBarController = self.tabBarController as? TabBarController
        //tabBarController?.setTransparentTabBar(isSet: true)
        
        UIView.animate(withDuration: 3, delay: 0.1, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.containingView.frame.origin = CGPoint(x: self.containingView.frame.origin.x,
                                                       y: self.containingView.frame.origin.y - 10)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //let tabBarController = self.tabBarController as? TabBarController
        //tabBarController?.setTransparentTabBar(isSet: false)
    }
    
    func setupViews() {
        view.addSubview(containingView)
        containingView.addSubview(linkButton)
        
        NSLayoutConstraint.activate([
            containingView.heightAnchor.constraint(equalToConstant: 50),
            containingView.widthAnchor.constraint(equalToConstant: 150),
            containingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            linkButton.topAnchor.constraint(equalTo: containingView.topAnchor),
            linkButton.bottomAnchor.constraint(equalTo: containingView.bottomAnchor),
            linkButton.leadingAnchor.constraint(equalTo: containingView.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: containingView.trailingAnchor),
            ])
        
        linkButton.addTarget(self, action: #selector(linkButtonTouchedDown), for: .touchDown)
        linkButton.addTarget(self, action: #selector(linkButtonTouchedUpInside), for: .touchUpInside)
        linkButton.addTarget(self, action: #selector(linkButtonTouchedUpOutside), for: .touchUpOutside)
        linkButton.addTarget(self, action: #selector(linkButtonTouchedUpOutside), for: .touchDragExit)
    }
    
    @objc func linkButtonTouchedDown() {
        UIView.transition(with: linkButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.linkButton.backgroundColor = Constants.Colors().primaryDarkColor
            self.showButtonShadow(show: false)
        })
    }
    
    @objc func linkButtonTouchedUpOutside() {
        UIView.transition(with: linkButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.linkButton.backgroundColor = Constants.Colors().primaryColor
            self.showButtonShadow(show: true)
        })
    }
    
    @objc func linkButtonTouchedUpInside() {
        UIView.transition(with: linkButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.linkButton.backgroundColor = Constants.Colors().primaryColor
            self.showButtonShadow(show: true)
        })
        let activityVC = UIActivityViewController(activityItems: [linkButton.titleLabel!.text!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func showButtonShadow(show: Bool) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.containingView.layer.shadowOpacity
        animation.toValue = show ? 0.5 : 0.33
        animation.duration = 0.33
        
        let animation2 = CABasicAnimation(keyPath: "shadowOffset")
        animation2.fromValue = self.containingView.layer.shadowOffset
        animation2.toValue = show ? CGSize(width: 0, height: 15) : CGSize(width: 0, height: 10)
        animation.duration = 0.33
        
        self.containingView.layer.add(animation, forKey: animation.keyPath)
        self.containingView.layer.add(animation2, forKey: animation.keyPath)
        
        self.containingView.layer.shadowOpacity = show ? 0.5 : 0.33
        self.containingView.layer.shadowOffset = show ? CGSize(width: 0, height: 15) : CGSize(width: 0, height: 10)
    }
    
}
