//
//  ViewOrderButtonView.swift
//  HYSOR
//
//  Created by Dayson Dong on 2020-03-17.
//  Copyright © 2020 Dayson Dong. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet{
            
            let isWhite = self.backgroundColor!.isEqualToColor(.white)
            let isLightGray = self.backgroundColor!.isEqualToColor(.lightGray)
            
            if isWhite || isLightGray {
                 backgroundColor = isHighlighted ? .lightGray : .white
            } else {
                backgroundColor = isHighlighted ? .darkGray : .black
            }
        }
    }
    
    private let headTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 18)
        l.text = "Button"
        l.numberOfLines = 1
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    

//    var titleText: String = "" {
//        didSet{
//             headTitleLabel.text = titleText
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .black
        addSubview(headTitleLabel)
   
        
        NSLayoutConstraint.activate([
            
            headTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headTitleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),

        ])
    }
    
    func configureButton(headTitleText: String, titleColor: UIColor, backgroud: UIColor?) {
        
        headTitleLabel.text = headTitleText
        headTitleLabel.textColor = titleColor
        backgroundColor = backgroud ?? .black
    }
    
    
    func configureTitle(title: String) {
        
        headTitleLabel.text = title
    }
    
 
}
