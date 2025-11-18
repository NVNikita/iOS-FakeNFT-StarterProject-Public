import Foundation
import UIKit

private var users: [User] = []


final class StatisticsPresenter {
    weak var view: StatisticsViewInput?
    private let userService: UserServiceProtocol
    
    private var users: [User] = []
    
    init(view: StatisticsViewInput? = nil, userService: UserServiceProtocol) {
        self.view = view
        self.userService = userService
    }
}


extension StatisticsPresenter: StatisticsViewOutput {
    func viewDidLoad() {
        view?.showLoading()
        
        userService.loadUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                guard let self = self else { return }
                
                switch result {
                case .success(let loadedUsers):
                    self.users = loadedUsers
                    self.users.sort { Int($0.rating) ?? 0 > Int($1.rating) ?? 0 }
                    self.view?.showUsers(self.users)
                case .failure(let error):
                    print("Ошибка загрузки пользователей: \(error)")
                }
            }
        }
    }
        
    func didTapSortByName() {
        let sortedUsers = users.sorted { $0.name < $1.name }
        view?.showUsers(sortedUsers)
    }
    
    func didTapSortByRating() {
        users.sort { Int($0.rating) ?? 0 > Int($1.rating) ?? 0 }
        view?.showUsers(users)
    }
}

