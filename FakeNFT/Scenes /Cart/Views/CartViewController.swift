//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 26.10.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    private lazy var nftTableView = UITableView()
    private var countCells = 3 //MOCK
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupConstarints()
    }
    
    private func setupNavigationBar() {
        //TODO: - to do nav bar
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.background
        
        view.addSubview(nftTableView)
        
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.backgroundColor = .clear
    }
    
    private func setupTableView() {
        nftTableView.delegate = self
        nftTableView.dataSource = self
        nftTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupConstarints() {
        NSLayoutConstraint.activate([
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nftTableView.heightAnchor.constraint(equalToConstant: CGFloat(140 * countCells))
        ])
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                as? NFTTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .white
        return cell
    }
}
