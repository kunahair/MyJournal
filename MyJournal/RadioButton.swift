//
//  RadioButton.swift
//  MyJournal
//
//  Created by Josh Gerlach on 15/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation
import UIKit
//
//class RadioButton: UIButton {
//    var alternateButton:Array<RadioButton>?
//    
//    override func awakeFromNib() {
//        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 2.0
//        self.layer.masksToBounds = true
//    }
//    
//    func unselectAlternateButtons(){
//        if alternateButton != nil {
//            self.selected = true
//            
//            for aButton:RadioButton in alternateButton! {
//                aButton.selected = false
//            }
//        }else{
//            toggleButton()
//        }
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        unselectAlternateButtons()
//        super.touchesBegan(touches, withEvent: event)
//    }
//    
//    func toggleButton(){
//        self.selected = !selected
//    }
//    
//    override var selected: Bool {
//        didSet {
//            if selected {
//                self.layer.borderColor = Color.turquoise.CGColor
//            } else {
//                self.layer.borderColor = Color.grey_99.CGColor
//            }
//        }
//    }
//}
