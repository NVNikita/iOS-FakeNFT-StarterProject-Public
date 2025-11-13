
import Foundation

final class EditProfileInteractorImpl: EditProfileInteractorInput {

    private let profileService: ProfileService

    init(profileService: ProfileService) {
        self.profileService = profileService
    }

    func loadCurrentProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.loadProfile { result in
            completion(result)
        }
    }

    func updateProfile(_ profile: Profile, completion: @escaping (Result<Profile, Error>) -> Void) {
        let name = profile.name ?? ""
        let description = profile.description ?? ""
        let website = profile.website ?? ""
        let avatar = profile.avatar ?? ""

        profileService.updateProfile(
            name: name,
            description: description,
            website: website,
            avatar: avatar
        ) { result in
            completion(result)
        }
    }

    func validateAvatarURL(_ string: String) -> URL? {

        if let url = URL(string: string), ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            return url
        }
        return nil
    }
}

