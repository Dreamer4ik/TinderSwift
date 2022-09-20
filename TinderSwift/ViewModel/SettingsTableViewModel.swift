//
//  SettingsTableViewModel.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 17.09.2022.
//

import UIKit

enum SettingsSections: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange
    
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingsTableViewModel {
    
    private let user: User
    let section: SettingsSections
    
    let placeholderText: String
    var value: String?
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    var shouldHideAgeLabel: Bool {
        return section != .ageRange
    }
    
    var shouldHideRangeLabel: Bool {
        return section != .ageRange
    }
    
    var minAgeSliderValue: CGFloat {
        return CGFloat(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: CGFloat {
        return CGFloat(user.maxSeekingAge)
    }
    
    func rangeAgeLabelText(forValue valueMin: CGFloat, forValue valueMax: CGFloat) -> String {
        let minString = Int(roundf(Float(valueMin)))
        let maxString = Int(roundf(Float(valueMax)))
        return "\(minString) - \(maxString)"
    }
    
    init(user: User, section: SettingsSections) {
        self.user = user
        self.section = section
        
        placeholderText = "Enter \(section.description.lowercased())..."
        
        switch section {
        case .name:
            value = user.name
        case .profession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
}
