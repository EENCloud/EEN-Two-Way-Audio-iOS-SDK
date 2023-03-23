//
//  AudioButton.swift
//  TwoWayAudioDemo
//
//  Created by Suhaib Al Saghir on 23/03/2023.
//

import UIKit

class AudioButton: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(named: "ic_talkdown")
        return imageView
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private let amplitudeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 4
        return view
    }()
    
    var amplitudeHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setLoadingState() {
        UIView.animate(withDuration: 0.3) {
            self.imageView.alpha = 0
            self.removeAmplitudeView()
        } completion: { _ in
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func setConnectedState() {
        UIView.animate(withDuration: 0.3) {
            self.activityIndicatorView.stopAnimating()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.imageView.alpha = 1
                self.backgroundColor = .blue
            } completion: { _ in
                self.addAmplitudeView()
            }
        }
    }
    
    func setDisconnectedState() {
        UIView.animate(withDuration: 0.3) {
            self.activityIndicatorView.stopAnimating()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.imageView.alpha = 1
                self.backgroundColor = nil
            } completion: { _ in
                self.removeAmplitudeView()
            }
        }
    }
    
    func handleAmplitude(amplitude: Double) {
        
        DispatchQueue.main.async { [weak self] in
            self?.amplitudeHeightConstraint?.constant = amplitude * 100
            
            UIView.animate(withDuration: 0.05, animations: {
                self?.layoutIfNeeded()
            })
        }
        
    }
}

private extension AudioButton {
    func setupUI() {
        
        self.layer.cornerRadius = 4
        addSubview(imageView)
        addSubview(activityIndicatorView)

        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func addAmplitudeView() {
        guard amplitudeView.superview == nil else { return }
        insertSubview(amplitudeView, at: 0)
        
        amplitudeView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        amplitudeView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        amplitudeView.widthAnchor.constraint(equalTo: amplitudeView.heightAnchor).isActive = true
        amplitudeHeightConstraint = amplitudeView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0)
        amplitudeHeightConstraint?.isActive = true
    }
    
    func removeAmplitudeView() {
        guard amplitudeView.superview != nil else { return }
        amplitudeHeightConstraint?.isActive = false
        amplitudeHeightConstraint = nil
        amplitudeView.removeFromSuperview()
    }
}
