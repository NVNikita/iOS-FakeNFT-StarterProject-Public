
import UIKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(_ profile: Profile)
}

final class EditProfileAssembly {

    private let servicesAssembly: ServicesAssembly
    private weak var delegate: EditProfileDelegate?

    init(servicesAssembly: ServicesAssembly, delegate: EditProfileDelegate?) {
        self.servicesAssembly = servicesAssembly
        self.delegate = delegate
    }

    func build(with profile: Profile) -> UIViewController {
        let interactor = EditProfileInteractorImpl(profileService: servicesAssembly.profileService)
        let router = EditProfileRouterImpl()
        let presenter = EditProfilePresenterImpl(interactor: interactor, router: router, initialProfile: profile)
        let viewController = EditProfileViewController(presenter: presenter)

        presenter.view = viewController
        presenter.outputDelegate = delegate
        router.viewController = viewController

        return viewController
    }
}

