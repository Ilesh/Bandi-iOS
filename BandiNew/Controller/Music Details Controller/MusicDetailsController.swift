//
//  PopupMusicDetailsController.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/2/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import MarqueeLabelSwift

class MusicDetailsController: UIViewController, AVPlayerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupItem.title = "Not Playing"
        setupViews()
        setUpTheming()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if AppThemeProvider.shared.currentTheme.themeName == "light" {
            return .default
        } else {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        upNextTableView.reloadData()
        let calculatedHeight = view.bounds.height - contentTopInset - 105 + CGFloat(upNextTableView.getCalculatedHeight())
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: calculatedHeight)
        mainScrollView.contentSize = contentView.frame.size
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.youtubePlayerFrame.frame = videoContainer.bounds
    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    var playingMusic: Song? {
        didSet {
            popupItem.title = playingMusic?.title
            titleLabel.text = playingMusic?.title
            popupItem.subtitle = playingMusic?.artist
            artistLabel.text = playingMusic?.artist
            popupItem.image = (playingMusic?.thumbnailImages!["small"] as! UIImage)
            popupItem.progress = 0.34
        }
    }
    
//    let backgroundView: UIVisualEffectView = {
//        let effect = UIBlurEffect(style: .dark)
//        let view = UIVisualEffectView(effect: effect)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    lazy var youtubePlayerFrame: AVPlayerLayer = {
        let avpLayer = AVPlayerLayer(player: avp)
        avpLayer.videoGravity = .resizeAspect
        avpLayer.needsDisplayOnBoundsChange = true
        return avpLayer
    }()
    
    let screenContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var videoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trackSlider: TrackSlider = {
        let slider = TrackSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "--:--"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .darkGray
        label.text = "--:--"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 20, fadeLength: 10)
        label.fadeLength = 10
        label.textColor = Constants.Colors().textGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 20, fadeLength: 10)
        label.textColor = Constants.Colors().primaryColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "play-100")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause-100")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let rewindButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rewind-96")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward-96")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let volumeSliderView: VolumeSlider = {
        let slider = VolumeSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let avp: AVPlayer = {
        let url = URL(string: "https://r5---sn-ab5szn7s.googlevideo.com/videoplayback?ip=104.236.232.152&mime=video%2Fmp4&pl=21&source=youtube&dur=228.275&mv=m&ms=au%2Crdu&mm=31%2C29&ipbits=0&c=WEB&expire=1525396385&fexp=23724337&id=o-APfq_i_sz7lvXQIbuBLzT8hP0RCWJDhWuPrBPzjAJ9ar&key=yt6&fvip=5&initcwndbps=191250&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&requiressl=yes&lmt=1516777979804090&itag=22&mn=sn-ab5szn7s%2Csn-ab5l6ndr&ratebypass=yes&ei=QV_rWr-6M8v48gSeh5iACg&mt=1525374657&signature=A04E23B1C5781690159603F448A305A3BAFD208F.A5FC7831A44D6B1CC1C5387D189D8E90455FC814")
        let av = AVPlayer(url: url!)
        return av
    }()
    
    lazy var upNextTableView: UpNextTableView = {
        // TODO: change upnext to show currently playing playlist
        let playlist = CoreDataHelper.shared.queue
        let tv = UpNextTableView(frame: .zero, style: .plain, playlist: playlist)
        tv.handleScrollDownTapped = {
            self.mainScrollView.scrollToView(view: tv, animated: true)
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let mainScrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.alwaysBounceVertical = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topBackground = UIView()
    let bottomBackground = UIView()
    var contentView = UIView()
    var contentTopInset = CGFloat(55)
    
    func setupViews() {
        
        //view.addSubview(backgroundView)
        
        let musicDetailsSubview = UIView()
        musicDetailsSubview.translatesAutoresizingMaskIntoConstraints = false
        musicDetailsSubview.addSubview(titleLabel)
        musicDetailsSubview.addSubview(artistLabel)
        
        let controlsSubview = UIView()
        controlsSubview.translatesAutoresizingMaskIntoConstraints = false
        controlsSubview.addSubview(playButton)
        controlsSubview.addSubview(pauseButton)
        controlsSubview.addSubview(rewindButton)
        controlsSubview.addSubview(forwardButton)
        
        let mainDetailsStackView = UIStackView()
        mainDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        mainDetailsStackView.axis = .vertical
        mainDetailsStackView.alignment = .center
        mainDetailsStackView.distribution = .fillEqually
        
        mainDetailsStackView.addArrangedSubview(musicDetailsSubview)
        mainDetailsStackView.addArrangedSubview(controlsSubview)
        mainDetailsStackView.addArrangedSubview(volumeSliderView)
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        if modelIdentifier().contains("iPhone10") {
            contentTopInset = 100
        }
        
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: contentTopInset).isActive = true
        mainScrollView.addSubview(contentView)
        
        videoContainer.layer.addSublayer(youtubePlayerFrame)
        screenContainer.addSubview(videoContainer)
        screenContainer.addSubview(trackSlider)
        screenContainer.addSubview(currentTimeLabel)
        screenContainer.addSubview(remainingTimeLabel)
        //screenContainer.addSubview(loadingView)
        
        topBackground.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topBackground)
        contentView.addSubview(screenContainer)
        contentView.addSubview(mainDetailsStackView)
        contentView.addSubview(upNextTableView)
        
        NSLayoutConstraint.activate([
//            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topBackground.topAnchor.constraint(equalTo: upNextTableView.topAnchor),
            topBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            screenContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            screenContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5625),
            screenContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            trackSlider.heightAnchor.constraint(equalToConstant: 20),
            trackSlider.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor),
            trackSlider.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor),
            trackSlider.bottomAnchor.constraint(equalTo: screenContainer.bottomAnchor, constant: 9),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor, constant: 15),
            currentTimeLabel.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor, constant: -15),
            currentTimeLabel.topAnchor.constraint(equalTo: screenContainer.bottomAnchor, constant: 10),
            currentTimeLabel.heightAnchor.constraint(equalToConstant: 15),
            
            remainingTimeLabel.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor, constant: 15),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor, constant: -15),
            remainingTimeLabel.topAnchor.constraint(equalTo: screenContainer.bottomAnchor, constant: 10),
            remainingTimeLabel.heightAnchor.constraint(equalToConstant: 15),
            
            videoContainer.topAnchor.constraint(equalTo: screenContainer.topAnchor),
            videoContainer.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor),
            videoContainer.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor),
            videoContainer.bottomAnchor.constraint(equalTo: screenContainer.bottomAnchor),
            
            mainDetailsStackView.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 10),
            mainDetailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainDetailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainDetailsStackView.bottomAnchor.constraint(equalTo:  upNextTableView.topAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: musicDetailsSubview.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: musicDetailsSubview.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: musicDetailsSubview.trailingAnchor),
            
            artistLabel.topAnchor.constraint(equalTo: musicDetailsSubview.centerYAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: musicDetailsSubview.leadingAnchor),
            artistLabel.trailingAnchor.constraint(equalTo: musicDetailsSubview.trailingAnchor),
            
            //            loadingView.topAnchor.constraint(equalTo: screenContainer.topAnchor),
            //            loadingView.leadingAnchor.constraint(equalTo: screenContainer.leadingAnchor),
            //            loadingView.trailingAnchor.constraint(equalTo: screenContainer.trailingAnchor),
            //            loadingView.bottomAnchor.constraint(equalTo: screenContainer.bottomAnchor),
            
            rewindButton.heightAnchor.constraint(equalToConstant: 40),
            rewindButton.leadingAnchor.constraint(equalTo: controlsSubview.leadingAnchor, constant: 70),
            rewindButton.widthAnchor.constraint(equalToConstant: 60),
            rewindButton.centerYAnchor.constraint(equalTo: controlsSubview.centerYAnchor),

            pauseButton.heightAnchor.constraint(equalToConstant: 60),
            pauseButton.leadingAnchor.constraint(equalTo: rewindButton.trailingAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor),
            pauseButton.centerYAnchor.constraint(equalTo: controlsSubview.centerYAnchor),

            playButton.heightAnchor.constraint(equalToConstant: 55),
            playButton.leadingAnchor.constraint(equalTo: rewindButton.trailingAnchor),
            playButton.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor),
            playButton.centerYAnchor.constraint(equalTo: controlsSubview.centerYAnchor),

            forwardButton.heightAnchor.constraint(equalToConstant: 40),
            forwardButton.widthAnchor.constraint(equalToConstant: 60),
            forwardButton.trailingAnchor.constraint(equalTo: controlsSubview.trailingAnchor, constant: -70),
            forwardButton.centerYAnchor.constraint(equalTo: controlsSubview.centerYAnchor),

            volumeSliderView.leadingAnchor.constraint(equalTo: mainDetailsStackView.leadingAnchor, constant: 25),
            volumeSliderView.trailingAnchor.constraint(equalTo: mainDetailsStackView.trailingAnchor, constant: -25),
            
            upNextTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upNextTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            upNextTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        
        avp.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        avp.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        avp.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsInt = Int(seconds.truncatingRemainder(dividingBy: 60))
            let minutesInt = Int(seconds / 60)
            
            let secondsString = String(format: "%02d", secondsInt)
            let minutesString = String(format: "%02d", minutesInt)
            
            if let duration = self.avp.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if !durationSeconds.isNaN {
                    let remainingSeconds = durationSeconds - seconds
                    let rSecondsInt = Int(remainingSeconds.truncatingRemainder(dividingBy: 60))
                    let rMinutes = Int(remainingSeconds / 60)
                    
                    let rSecondsString = String(format: "%02d", rSecondsInt)
                    let rMinutesString = String(format: "%02d", rMinutes)
                    
                    self.remainingTimeLabel.text = "-\(rMinutesString):\(rSecondsString)"
                    self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                    
                    self.trackSlider.value = Float(seconds / durationSeconds)
                }
            }
        })
        
        trackSlider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        setPlayBarButton()
        
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
    }
    
    @objc func handleSliderChange() {
        if let duration = avp.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let sliderValue = Float64(trackSlider.value) * totalSeconds
            
            if !sliderValue.isNaN {
                let seekTime = CMTime(value: Int64(sliderValue), timescale: 1)
                avp.seek(to: seekTime, completionHandler: { (completedSeek) in
                    
                })
            }
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if avp.rate > 0 {
                //print(avp.rate)
                hideLoading()
            }
        }
    }
    
    func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    
    func updateVideo(videoURLString: String) {
        let url = URL(string: videoURLString)
        avp.replaceCurrentItem(with: AVPlayerItem(url: url!))
    }
    
    var playBarButton: UIBarButtonItem?
    var pauseBarButton: UIBarButtonItem?
    
    func setPlayBarButton() {
        playBarButton = UIBarButtonItem(image: UIImage(named: "play-mini"), style: .plain, target: self, action: #selector(play))
        popupItem.rightBarButtonItems = [playBarButton!]
    }
    
    func setPauseBarButton() {
        pauseBarButton = UIBarButtonItem(image: UIImage(named: "pause-mini"), style: .plain, target: self, action: #selector(pause))
        popupItem.rightBarButtonItems = [pauseBarButton!]
    }
    
    @objc func play() {
        self.avp.play()
        setPauseBarButton()
        playButton.isHidden = true
        pauseButton.isHidden = false
    }
    
    @objc func pause() {
        self.avp.pause()
        setPlayBarButton()
        playButton.isHidden = false
        pauseButton.isHidden = true
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}

extension MusicDetailsController: Themed {
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.musicDetailsMainBackgroundColor
        topBackground.backgroundColor = theme.musicDetailsTopBackgroundColor
        upNextTableView.backgroundColor = theme.musicDetailsTopBackgroundColor
        currentTimeLabel.textColor = theme.subTextColor
        remainingTimeLabel.textColor = theme.subTextColor
        titleLabel.textColor = theme.textColor
        volumeSliderView.volumeSlider.tintColor = theme.subTextColor
        for view in volumeSliderView.volumeSlider.subviews {
            if view.isKind(of: UIButton.self) {
                let buttonOnVolumeView : UIButton = view as! UIButton
                volumeSliderView.volumeSlider.setRouteButtonImage(buttonOnVolumeView.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
                break;
            }
        }
        playButton.tintColor = theme.textColor
        pauseButton.tintColor = theme.textColor
        rewindButton.tintColor = theme.textColor
        forwardButton.tintColor = theme.textColor
    }
}
