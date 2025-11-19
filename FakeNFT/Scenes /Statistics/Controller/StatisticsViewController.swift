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
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshList(_:)), for: .valueChanged)
        return control
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sortBtn"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    private var presenter: StatisticsViewOutput!
    private var users: [User] = []

    // MARK: - Init

    init(presenter: StatisticsViewOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupViews() {
        view.backgroundColor = UIColor(named: "White")
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.refreshControl = refreshControl
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
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            self?.presenter.didTapSortByName()
        })

        alert.addAction(UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.presenter.didTapSortByRating()
        })

        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sortButton
            popoverController.sourceRect = sortButton.bounds
        }

        present(alert, animated: true)
    }
    
    @objc private func refreshList(_ sender: UIRefreshControl) {
        presenter.viewDidLoad()
    }
}

// MARK: - StatisticsViewInput

extension StatisticsViewController: StatisticsViewInput {
    func showUsers(_ users: [User]) {
        self.users = users
        tableView.reloadData()
    }
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func showError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
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
    }
}

// MARK: - LoadingView

private extension StatisticsViewController {
    func showLoadingIndicator() {
        if !refreshControl.isRefreshing {
            tableView.isHidden = true
            activityIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        refreshControl.endRefreshing()
    }
}
