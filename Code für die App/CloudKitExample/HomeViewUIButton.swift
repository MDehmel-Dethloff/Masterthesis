//
//  HomeViewUIButton.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 19.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

// Sets the properties for buttons used for the app
@IBDesignable
class HomeViewUIButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
