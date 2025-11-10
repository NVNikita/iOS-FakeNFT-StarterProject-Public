import Foundation
import UIKit

private var users: [User] = []


final class StatisticsPresenter {
    weak var view: StatisticsViewInput?
    
    private var users: [User] = []

    init(view: StatisticsViewInput? = nil) {
        self.view = view
    }
}


extension StatisticsPresenter: StatisticsViewOutput {
    func viewDidLoad() {
        view?.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.users = self.createMockUsers()
            self.view?.hideLoading()
            self.view?.showUsers(self.users)
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

    private func createMockUsers() -> [User] {
        return [
            User(id: "1", name: "Alex", avatar: "", description: "sample", website: "https://example.com", nfts: ["1","2"], rating: "5432"),
            User(id: "2", name: "Bill", avatar: "", description: "sample", website: "https://example.com", nfts: ["1","2"], rating: "4521"),
            User(id: "3", name: "Alla", avatar: "", description: "sample", website: "https://example.com", nfts: ["1"], rating: "3876"),
        ]
    }
}

