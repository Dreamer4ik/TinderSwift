//
//  SettingsTableViewCell.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 17.09.2022.
//

import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsTableViewCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    func settingsCell(_ cell: SettingsTableViewCell, wantsToUpdateAgeRangeWith sender: UISlider)
}

class SettingsTableViewCell: UITableViewCell {
    // MARK: - Properties
    weak var delegate: SettingsTableViewCellDelegate?
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
        
        selectionStyle = .none
        minAgeSlider = createAgeRangeSlider()
        maxAgeSlider = createAgeRangeSlider()
        
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
        
        inputField.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func ageRangeCnanged(sender: UISlider) {
        if sender == minAgeSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
        }
        else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
        }
        delegate?.settingsCell(self, wantsToUpdateAgeRangeWith: sender)
    }
    
    @objc private func fieldEndEditing(sender: UITextField) {
        guard let value = sender.text else {
            return
        }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    // MARK: - Helpers
    private func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.addTarget(self, action: #selector(ageRangeCnanged), for: .valueChanged)
        return slider
    }
    
    private func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
        
        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
        
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
    }
}
