//
//  UIView.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import Foundation
import UIKit

extension UIView{
    func setRoundedCorner(){
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
    }
    
    func setRoundedShadow(){
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4.0
    }
}
