//
//  EditPageControllerMoodPicker.swift
//  MyJournal
//
//  Created by Josh Gerlach on 28/01/2017.
//  Copyright © 2017 Xing. All rights reserved.
//

import UIKit

/**
 Extension to handle the Mood Picker callbacks for EditPageController
 **/
extension EditPageController {
    
    // Mood Picker and its funcs : Picker delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.getInstance.getMoodArray().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Model.getInstance.getMoodArray()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mood = MoodEnum(mood: Model.getInstance.getMoodArray()[row])!
    }
}
