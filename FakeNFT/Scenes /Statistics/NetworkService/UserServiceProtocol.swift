import Foundation

typealias UsersLoadCompletion = (Result<[User], Error>) -> Void

protocol UserServiceProtocol {
    func loadUsers(completion: @escaping UsersLoadCompletion)
}
