import Foundation

final class UserServiceImpl: UserServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUsers(completion: @escaping UsersLoadCompletion) {
        let request = AllUsersGetRequest()
        
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - AllUsersGetRequest
struct AllUsersGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
