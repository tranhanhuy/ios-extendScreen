//
//  ViewController.swift
//  AirPlay
//
//  Created by Tran Han Huy on 10/12/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var mirroredWindow: UIWindow? = nil
    var mirroredScreen: UIScreen? = nil
    var mirroredView: UIView? = nil
    var countlabel: UILabel = UILabel.init()
    var count: Int = 0 {
        didSet {
            self.countlabel.text = "\(count)"
        }
    }
    var player: AVAudioPlayer?
    
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.setupOutputScreen()
    }
    
    func initUI() {
        countlabel.font = UIFont.systemFont(ofSize: 14.0)
        countlabel.text = "\(count)"
        self.view.addSubview(countlabel)
        countlabel.translatesAutoresizingMaskIntoConstraints = false
        countlabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        countlabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setupOutputScreen() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenDidConnect(notification:)), name: UIScreen.didConnectNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenDidDisconnect(notification:)), name: UIScreen.didDisconnectNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(screenModeDidChange(notification:)), name: UIScreen.modeDidChangeNotification, object: nil)
        
        let connectedScreens = UIScreen.screens;
        if connectedScreens.count > 1 {
            let mainScreen = UIScreen.main;
            for screen in connectedScreens {
                if screen != mainScreen {
                    self.setupMirroringForScreen(anExternalScreen: screen);
                    break;
                }
            }
        }
    }
    
    @objc func screenDidConnect(notification: Notification) {
        print("A screen got connected ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setupMirroringForScreen(anExternalScreen: notification.object as! UIScreen)
        }
    }
    
    @objc func screenDidDisconnect(notification: Notification) {
        print("A screen got disconnected ")
        self.disableMirroringOnCurrentScreen()
    }
    
    @objc func screenModeDidChange(notification: Notification) {
        print("A screen mode changed ")
        self.disableMirroringOnCurrentScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setupMirroringForScreen(anExternalScreen: notification.object as! UIScreen)
        }
    }
    
    func setupMirroringForScreen(anExternalScreen: UIScreen) {
        self.mirroredScreen = anExternalScreen
        if let app = UIApplication.shared.delegate as? AppDelegate, let mirroredWindow = app.newWindow, let mirroredScreen = self.mirroredScreen {
            self.mirroredWindow = mirroredWindow
            self.setupMirroredView(anExternalScreen: mirroredScreen)
            self.mirroredWindow?.addSubview(self.mirroredView!)
        }
        
//
//
//        var max: CGSize = CGSize.init(width: 0, height: 0)
//        var maxScreenMode: UIScreenMode? = nil
//
//        if let mirroredScreen = self.mirroredScreen {
//            for current in mirroredScreen.availableModes {
//                if maxScreenMode == nil || current.size.height > max.height || current.size.width > max.width {
//                    max = current.size
//                    maxScreenMode = current
//                }
//            }
//            self.mirroredWindow = UIWindow(frame: mirroredScreen.bounds)
//            if let mirroredWindow = self.mirroredWindow {
//                mirroredWindow.isHidden = false
//                mirroredWindow.layer.contentsGravity = .resizeAspect
////                mirroredWindow.screen = mirroredScreen
//
//                let vc = UIViewController()
//                vc.view.backgroundColor = .blue
//                mirroredWindow.rootViewController = vc
//                self.mirroredView = UIView.init(frame: mirroredScreen.bounds)
//                self.mirroredView?.backgroundColor = UIColor.red
//                mirroredWindow.addSubview(self.mirroredView!)
//                mirroredWindow.makeKeyAndVisible()
//
//
//
//                print(#function)
//            }
//        }
    }
    
    func disableMirroringOnCurrentScreen() {
        self.mirroredScreen = nil
        self.mirroredWindow = nil
        self.initUI()
    }

    private func setupMirroredView(anExternalScreen: UIScreen) {
        self.mirroredView = UIView.init(frame: anExternalScreen.bounds)
        if let mirroredView = self.mirroredView {
            mirroredView.backgroundColor = .yellow
            countlabel.font = UIFont.boldSystemFont(ofSize: 150.0)
            countlabel.text = "\(count)"
            mirroredView.addSubview(countlabel)
            countlabel.translatesAutoresizingMaskIntoConstraints = false
            countlabel.centerYAnchor.constraint(equalTo: mirroredView.centerYAnchor).isActive = true
            countlabel.centerXAnchor.constraint(equalTo: mirroredView.centerXAnchor).isActive = true
        }
    }

    @IBAction func upButtonTouched(_ sender: Any) {
        self.count += 1
    }
    
    @IBAction func downButtonTouched(_ sender: Any) {
        self.count -= 1
    }
 
}

