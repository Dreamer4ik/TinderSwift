//
//  SettingsTableViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 15.09.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - Properties
    private let headerView = SettingsHeader()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    // MARK: Lifecycle
    
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
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
    
        headerView.delegate = self
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell else {
            preconditionFailure("Error SettingsTableViewCell")
        }
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
        let selectedImage = info[.originalImage] as? UIImage
        // have to figure out how to update photo
        setHeaderImage(selectedImage)
        
        dismiss(animated: true)
    }
}
