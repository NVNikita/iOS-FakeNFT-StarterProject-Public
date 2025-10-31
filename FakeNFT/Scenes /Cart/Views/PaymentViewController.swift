//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 31.10.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title = "Выберите способ оплаты"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupCollectionView() {
        
    }
    
    private func setupConstaints() {
        
    }
}
