//
//  WeatherViewController.swift
//  iOS-training-Taichone
//
//  Created by 三木 太智 on 2024/09/18.
//

import UIKit

class WeatherViewController: UIViewController {
    private var imageView = UIImageView()
    private var redLabel = UILabel()
    private var blueLabel = UILabel()
    private var closeButton = UIButton(type: .system)
    private var reloadButton = UIButton(type: .system)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        
        redLabel.text = "--"
        redLabel.textColor = .red
        redLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(redLabel)
        
        blueLabel.text = "--"
        blueLabel.textColor = .blue
        blueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(blueLabel)
        
        closeButton.setTitle("Button 1", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(closeButton)
        
        reloadButton.setTitle("Button 2", for: .normal)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(reloadButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            redLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            redLabel.trailingAnchor.constraint(equalTo: blueLabel.leadingAnchor, constant: -10),
            redLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50),
            
            blueLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            blueLabel.leadingAnchor.constraint(equalTo: redLabel.trailingAnchor, constant: 10),
            blueLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: redLabel.bottomAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: reloadButton.leadingAnchor, constant: -10),
            closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50),
            
            reloadButton.topAnchor.constraint(equalTo: redLabel.bottomAnchor, constant: 20),
            reloadButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10),
            reloadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50)
        ])
    }
}
