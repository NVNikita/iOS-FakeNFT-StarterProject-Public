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
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.backgroundColor = UIColor.yaLightGrayLight
        return stackView
    }()
    
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
        view.addSubview(footerStackView)
        
        nftTableView.translatesAutoresizingMaskIntoConstraints = false
        nftTableView.backgroundColor = .clear
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        nftTableView.delegate = self
        nftTableView.dataSource = self
        nftTableView.register(NFTTableViewCell.self, forCellReuseIdentifier: "cell")
        nftTableView.separatorStyle = .none
        nftTableView.allowsSelection = false
    }
    
    private func setupConstarints() {
        NSLayoutConstraint.activate([
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor),
            nftTableView.heightAnchor.constraint(equalToConstant: CGFloat(140 * countCells)),
            
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerStackView.heightAnchor.constraint(equalToConstant: 76)
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
