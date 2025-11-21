import Foundation
import UIKit

enum StatisticsSortType: String {
    case rating
    case name
}

private let sortTypeKey = "StatisticsSortType"

final class StatisticsPresenter {
    weak var view: StatisticsViewInput?
    private let userService: UserServiceProtocol

    private var users: [User] = []

    private var currentSortType: StatisticsSortType {
        get {
            if let savedType = UserDefaults.standard.string(forKey: sortTypeKey),
               let sortType = StatisticsSortType(rawValue: savedType) {
                return sortType
            }
            return .rating
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: sortTypeKey)
        }
    }

    init(view: StatisticsViewInput? = nil, userService: UserServiceProtocol) {
        self.view = view
        self.userService = userService
    }

    private func sortAndShowUsers() {
        let sortedUsers: [User]
        switch currentSortType {
        case .rating:
            sortedUsers = users.sorted { Int($0.rating) ?? 0 > Int($1.rating) ?? 0 }
        case .name:
            sortedUsers = users.sorted { $0.name < $1.name }
        }
        view?.showUsers(sortedUsers)
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
                    self.sortAndShowUsers()
                case .failure(let error):
                    print("Ошибка загрузки пользователей: \(error)")
                    self.view?.showError(message: "Не удалось загрузить данные. Попробуйте снова.")
                }
            }
        }
    }

    func didTapSortByName() {
        currentSortType = .name
        sortAndShowUsers()
    }

    func didTapSortByRating() {
        currentSortType = .rating
        sortAndShowUsers()
    }
}
