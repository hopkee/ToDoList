//
//  Model.swift
//  ToDoList
//
//  Created by Valya on 10.03.22.
//

import UIKit

public class Model {
    
    enum Priority: Int32, CaseIterable {
        case high = 0
        case normal = 1
        case low = 2
        case completed = 3
        }
    }

extension String {
    
    func strikeThrough() -> NSAttributedString{
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func unStrikeThrought() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        return attributeString
    }
    
}

extension Task {
    
    var state: Model.Priority {
        get {
            return Model.Priority(rawValue: self.priority)!
        }

        set {
            self.priority = newValue.rawValue
        }
    }
    
}
