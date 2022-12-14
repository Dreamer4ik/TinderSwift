//
//  SettingsTableViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 15.09.2022.
//

import UIKit
import RangeSeekSlider
import JGProgressHUD

protocol SettingsTableViewControllerDelegate: AnyObject {
    func settingsController(_ controller: SettingsTableViewController, wantsToUpdate user: User)
    func settingsControllerWantsToLogOut(_ controller: SettingsTableViewController)
}

class SettingsTableViewController: UITableViewController {
    // MARK: - Properties
    private var user: User
    
    private var headerView: SettingsHeader
    private var footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        self.headerView = SettingsHeader(user: user)
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    // MARK: - Actions
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Your Data"
        hud.show(in: view)
        Service.saveUserData(user: user) { error in
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
    }

    // MARK: - API
    private func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Image"
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imageUrl in
            if self.user.imageURLs.count < self.headerView.buttons.count {
                self.user.imageURLs.append(imageUrl)
            } else {
                self.user.imageURLs[self.imageIndex] = imageUrl
            }
            hud.dismiss()
        }
    }
    
    // MARK: - Helpers
    
    private func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 88)
    
        headerView.delegate = self
        footerView.delegate = self
        imagePicker.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}

// MARK: - UITableViewDataSource
extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell else {
            preconditionFailure("Error SettingsTableViewCell")
        }
        guard let section = SettingsSections(rawValue: indexPath.section) else {
            preconditionFailure("Error SettingsTableViewCell section")
        }
        let viewModel = SettingsTableViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        cell.rangeSlider.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else {
            return nil
        }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else {
            return 0
        }
        return section == .ageRange ? 96 : 44
    }
}

// MARK: - SettingsHeaderDelegate
extension SettingsTableViewController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
}
// MARK: - SettingsTableViewCellDelegate
extension SettingsTableViewController: SettingsTableViewCellDelegate {
    func settingsCellLabel(_ cell: SettingsTableViewCell, wantsToUpdateAgeRangeWith slider: RangeSeekSlider) {
        
    }
    
    func settingsCell(_ cell: SettingsTableViewCell, wantsToUpdateUserWith value: String, for section: SettingsSections) {
        switch section {
        case .name:
            user.name = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
        
        print("User is: \(user)")
    }
}

// MARK: - RangeSeekSliderDelegate
extension SettingsTableViewController: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        user.minSeekingAge = Int(roundf(Float(minValue)))
        user.maxSeekingAge = Int(roundf(Float(maxValue)))
    }
}

extension SettingsTableViewController: SettingsFooterDelegate {
    func logOut() {
        delegate?.settingsControllerWantsToLogOut(self)
    }
}
