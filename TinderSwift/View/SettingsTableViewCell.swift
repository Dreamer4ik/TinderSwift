//
//  SettingsTableViewCell.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 17.09.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SettingsTableViewCell"
    var viewModel: SettingsTableViewModel! {
        didSet {
            configure()
        }
    }
    
    private var inputField: UITextField = {
        let field = UITextField()
        field.borderStyle = .none
        field.font = .systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        field.leftView = paddingView
        field.leftViewMode = .always
        return field
    }()
    
    var sliderStack = UIStackView()
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()
    
    var minAgeSlider = UISlider()
    var maxAgeSlider = UISlider()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minAgeSlider = createAgeRangeSlider()
        maxAgeSlider = createAgeRangeSlider()
        minAgeLabel.text = "Min: 18"
        maxAgeLabel.text = "Max: 65"
        
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minStack.spacing = 24
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        maxStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        
        contentView.addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func ageRangeCnanged() {
        
    }
    
    // MARK: - Helpers
    private func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.maximumValue = 18
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(ageRangeCnanged), for: .valueChanged)
        return slider
    }
    
    private func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
    }
}
