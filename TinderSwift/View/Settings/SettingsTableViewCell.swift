//
//  SettingsTableViewCell.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 17.09.2022.
//

import UIKit
import RangeSeekSlider

protocol SettingsTableViewCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsTableViewCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    func settingsCellLabel(_ cell: SettingsTableViewCell, wantsToUpdateAgeRangeWith slider: RangeSeekSlider)
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
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(hue: 0.3333, saturation: 0, brightness: 0.44, alpha: 1.0)
        return label
    }()
    
    var rangeSlider = RangeSeekSlider()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        rangeSlider = createRangeSlider()
        
        contentView.addSubview(rangeSlider)
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        contentView.addSubview(ageLabel)
        contentView.addSubview(rangeLabel)
        inputField.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChange), for: .touchDragInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rangeSliderHeight: CGFloat = 44
        rangeSlider.frame = CGRect(
            x: 15,
            y: (height - rangeSliderHeight)/2,
            width: width - 30,
            height: rangeSliderHeight
        )
        
        let rangeLabelSize: CGFloat = 44
        ageLabel.frame = CGRect(
            x: 30,
            y: rangeSlider.top - 30,
            width: rangeLabelSize,
            height: rangeLabelSize
        )
        
        let rangeLabelHeight: CGFloat = 44
        let rangeLabelWidth: CGFloat = 60
        rangeLabel.frame = CGRect(
            x: width - rangeLabelWidth - 30,
            y: rangeSlider.top - 30,
            width: 60,
            height: rangeLabelHeight
        )
        
    }
    
    // MARK: - Actions
    
    @objc func rangeSliderValueChange(slider: RangeSeekSlider) {
        rangeLabel.text = viewModel.rangeAgeLabelText(forValue: slider.selectedMinValue, forValue: slider.selectedMaxValue)
        delegate?.settingsCellLabel(self, wantsToUpdateAgeRangeWith: slider)
    }
    
    @objc private func fieldEndEditing(sender: UITextField) {
        guard let value = sender.text else {
            return
        }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    // MARK: - Helpers
    private func createRangeSlider() -> RangeSeekSlider {
        let slider = RangeSeekSlider()
        slider.minValue = 18
        slider.maxValue = 65
        slider.colorBetweenHandles = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        slider.tintColor = .lightGray
        slider.handleColor = .white
        slider.hideLabels = true
        slider.handleBorderWidth = 1
        slider.handleBorderColor = .lightGray
        slider.handleDiameter = 25
        slider.selectedHandleDiameterMultiplier = 1.5
        slider.minDistance = 4
        slider.lineHeight = 2.5
        slider.setupShadow(opacity: 0.5,radius: 8, offset: .init(width: 0.8, height: 0.8))
        return slider
    }
    
    private func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        rangeSlider.isHidden = viewModel.shouldHideSlider
        ageLabel.isHidden = viewModel.shouldHideAgeLabel
        rangeLabel.isHidden = viewModel.shouldHideRangeLabel
        
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
        
        rangeLabel.text = viewModel.rangeAgeLabelText(forValue: viewModel.minAgeSliderValue, forValue: viewModel.maxAgeSliderValue)
        
        rangeSlider.selectedMinValue = viewModel.minAgeSliderValue
        rangeSlider.selectedMaxValue = viewModel.maxAgeSliderValue
    }
    
}
