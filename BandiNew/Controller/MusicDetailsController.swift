//
//  PopupMusicDetailsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class MusicDetailsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupViews()
        
        
        popupItem.title = "sdfasdf"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.youtubePlayerFrame.frame = videoContainer.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let backgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let avp: AVPlayer = {
        let url = URL(string: "https://r5---sn-ab5szn7s.googlevideo.com/videoplayback?ip=104.236.232.152&mime=video%2Fmp4&pl=21&source=youtube&dur=228.275&mv=m&ms=au%2Crdu&mm=31%2C29&ipbits=0&c=WEB&expire=1525396385&fexp=23724337&id=o-APfq_i_sz7lvXQIbuBLzT8hP0RCWJDhWuPrBPzjAJ9ar&key=yt6&fvip=5&initcwndbps=191250&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&requiressl=yes&lmt=1516777979804090&itag=22&mn=sn-ab5szn7s%2Csn-ab5l6ndr&ratebypass=yes&ei=QV_rWr-6M8v48gSeh5iACg&mt=1525374657&signature=A04E23B1C5781690159603F448A305A3BAFD208F.A5FC7831A44D6B1CC1C5387D189D8E90455FC814")
        let av = AVPlayer(url: url!)
        return av
    }()
    
    lazy var youtubePlayerFrame: AVPlayerLayer = {
        let avpLayer = AVPlayerLayer(player: avp)
        avpLayer.videoGravity = .resizeAspect
        avpLayer.needsDisplayOnBoundsChange = true
        return avpLayer
    }()
    
    lazy var videoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(playButton)
        view.addSubview(pauseButton)
        
        videoContainer.layer.addSublayer(youtubePlayerFrame)
        
        
        view.addSubview(videoContainer)
        //        addChildViewController(youtubeController)
        //        view.addSubview(youtubeController.view)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pauseButton.heightAnchor.constraint(equalToConstant: 50),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pauseButton.bottomAnchor.constraint(equalTo: playButton.topAnchor),
            
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playButton.bottomAnchor.constraint(equalTo: videoContainer.topAnchor),
            
            videoContainer.heightAnchor.constraint(equalToConstant: 200),
            videoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        
        playButton.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTap), for: .touchUpInside)
    }
    
    func updateVideo(videoURLString: String) {
        let trimmedURL = videoURLString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let url = URL(string: trimmedURL)
        avp.replaceCurrentItem(with: AVPlayerItem(url: url!))
    }
    
    @objc func playButtonTap() {
        self.avp.play()
    }
    
    @objc func pauseButtonTap() {
        self.avp.pause()
    }
    
}
