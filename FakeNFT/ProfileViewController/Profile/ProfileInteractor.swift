import Foundation

final class ProfileInteractorImpl: ProfileInteractorInput {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func loadProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        servicesAssembly.profileService.loadProfile { result in
            completion(result)
        }
    }
    
    func loadNFTs(ids: [String], completion: @escaping (Result<[MyNFT], Error>) -> Void) {
        if ids.isEmpty {
            completion(.success([]))
            return
        }
        var loaded: [MyNFT] = []
        let group = DispatchGroup()
        for id in ids {
            group.enter()
            servicesAssembly.myNftService.loadNft(id: id) { result in
                if case .success(let nft) = result {
                    loaded.append(nft)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(.success(loaded))
        }
    }
    
    func updateLikes(_ likes: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        servicesAssembly.profileService.updateLikes(likes: likes) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
