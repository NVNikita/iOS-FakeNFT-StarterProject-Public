import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserRatingCell.self, forCellReuseIdentifier: UserRatingCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sortBtn"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var users: [User] = []
    private var isLoading = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        loadMockData()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "White")
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        sortButton.frame = CGRect(x: 9, y: 2, width: 35, height: 40)
        containerView.addSubview(sortButton)
        
        let barButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.sortUsers(by: .name)
        })
        
        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortUsers(by: .rating)
        })
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sortButton
            popoverController.sourceRect = sortButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Data Loading
    
    private func loadMockData() {
        isLoading = true
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.users = self?.createMockUsers() ?? []
            self?.isLoading = false
            self?.activityIndicator.stopAnimating()
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
    }
    
    private func createMockUsers() -> [User] {
        return [
            User(id: "1", name: "Alex", avatar: "", description: "sample", website: "https://example.com", nfts: ["1", "2", "3", "4", "5"], rating: "5432"),
            User(id: "2", name: "Bill", avatar: "", description: "sample", website: "https://example.com", nfts: ["1", "2", "3", "4"], rating: "4521"),
            User(id: "3", name: "Alla", avatar: "", description: "sample", website: "https://example.com", nfts: ["1", "2", "3"], rating: "3876"),
            User(id: "4", name: "Mads", avatar: "", description: "sample", website: "https://example.com", nfts: ["1", "2"], rating: "2945"),
            User(id: "5", name: "Timothée", avatar: "", description: "sample", website: "https://example.com", nfts: ["1"], rating: "1234")
        ]
    }
    
    // MARK: - Sorting
    
    private enum SortOption {
        case name
        case rating
    }
    
    private func sortUsers(by option: SortOption) {
        switch option {
        case .name:
            users.sort { $0.name < $1.name }
        case .rating:
            users.sort { Int($0.rating) ?? 0 > Int($1.rating) ?? 0 }
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserRatingCell.reuseIdentifier,
            for: indexPath
        ) as? UserRatingCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        let rank = indexPath.row + 1
        cell.configure(with: user, rank: rank)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        print("Selected user: \(user.name)")
        // TODO: Навигация к профилю пользователя
    }
}
