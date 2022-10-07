//
//  MessagesViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 05.10.2022.
//

import UIKit

class MessagesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    private let headerView = MessageMatchHeaderCollectionReusableView()
    
    private let tablewView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        fetchMatches()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: 190
        )
        tablewView.frame = view.bounds
    }
    
    // MARK: Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tablewView.delegate = self
        tablewView.dataSource = self
        
        tablewView.tableFooterView = UIView()
        view.addSubview(tablewView)
        
        tablewView.tableHeaderView = headerView
        headerView.delegate = self
        
        if #available(iOS 15.0, *) {
            tablewView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    private func configureNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 22, width: 22)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .systemPink
        leftButton.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView(image: UIImage(named: "top_messages_icon")?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
    }
    
    // MARK: Actions
    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    // MARK: API
    func fetchMatches() {
        Service.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        label.text = "Messages"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label)
        label.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: MessageMatchHeaderCollectionReusableViewDelegate
extension MessagesViewController: MessageMatchHeaderCollectionReusableViewDelegate {
    
func matchHeader(_ header: MessageMatchHeaderCollectionReusableView, wantsToStartChatWith uid: String) {
    Service.fetchUser(withUid: uid) { user in
        print("Start chat with \(user.name)")
    }
}
}
