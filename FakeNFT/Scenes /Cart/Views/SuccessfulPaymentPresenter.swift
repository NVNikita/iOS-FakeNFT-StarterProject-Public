//
//  SuccessfulPaymentPresenter.swift
//  FakeNFT
//
//  Created by Никита Нагорный on 18.11.2025.
//

import UIKit

protocol SuccessfulPaymentViewProtocol: AnyObject {
    
}

final class SuccessfulPaymentPresenter {
    weak var view: SuccessfulPaymentViewProtocol?
    
    func cartButtonTapped() {
        CartService.shared.clearCart { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.returnToCart()
                case .failure(let error):
                    print("Ошибка при очистке корзины: \(error)")
                }
            }
        }
    }
    
    private func returnToCart() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let tabBarController = window.rootViewController as? TabBarController else {
            return
        }
        
        window.rootViewController?.dismiss(animated: true) {
            tabBarController.selectedIndex = 1
            
            NotificationCenter.default.post(name: .cartDidUpdate, object: nil)
        }
    }
}
