//
//  ViewController.swift
//  TwoWayAudioDemo
//
//  Created by Suhaib Al Saghir on 23/03/2023.
//

import UIKit
import EEN_Two_Way_Audio_iOS_SDK

class ViewController: UIViewController {

    private lazy var twoWayAudioClient: TwoWayAudioClient = {
        let signalingServerUrl = URL(string: "wss://signalingServerUrl")!
        
        return TwoWayAudioClient.init(with: TwoWayAudioModel.init(webRtcUrl: signalingServerUrl,
                                                                  sourceID: "sourceID",
                                                                  type: TwoWayAudioTypes.talkdown,
                                                                  mediaType: TwoWayAudioMediaType.halfDuplex,
                                                                  authKey: "auth-key"),
                                      delegate: self)
    }()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var talkdownButton: AudioButton!
    
    private var status: TwoWayAudioStatus = .initial {
        didSet {
            switch status {
            case .initial:
                print("Initial state")
                
            case .disconnected(let reason):
                print("Error: \(reason)")
                talkdownButton.setDisconnectedState()
                
            case .connecting:
                talkdownButton.setLoadingState()

            case .connected:
                talkdownButton.setConnectedState()
                
            @unknown default:
                print("@unknown")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(talkdownButtonPressed))
        talkdownButton.addGestureRecognizer(tap)
    }
    
    @objc func talkdownButtonPressed() {
        switch status {
        case .disconnected,
                .initial:
            status = .connecting
            twoWayAudioClient.connect()
            
        case .connecting:
            status = .disconnected(reason: .manual)
            twoWayAudioClient.disconnect()
        
        case .connected:
            status = .disconnected(reason: .manual)
            twoWayAudioClient.disconnect()
            
        @unknown default:
            print("cucu")
        }
    }
}

extension ViewController: TwoWayAudioClientDelegate {
    func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeConnectionState status: TwoWayAudioStatus) {
        DispatchQueue.main.async {
            self.statusLabel.text = "\(status)"
            self.status = status
        }
    }
    
    func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didReceiveError message: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = message
        }
    }
    
    func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeAmplitude amplitude: Double) {
        talkdownButton.handleAmplitude(amplitude: amplitude)
    }
}
