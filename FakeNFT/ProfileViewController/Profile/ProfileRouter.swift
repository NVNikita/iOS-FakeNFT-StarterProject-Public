import UIKit
import WebKit

final class ProfileRouterImpl: ProfileRouterInput {

    weak var viewController: UIViewController?

    func openEditProfile(with profile: Profile, delegate: EditProfileDelegate?) {
        guard let vc = viewController else { return }
        // Для сборки используем существующую EditProfileAssembly
        if let servicesAssembly = (vc.tabBarController as? TabBarController)?.servicesAssembly {
            let assembly = EditProfileAssembly(servicesAssembly: servicesAssembly, delegate: delegate)
            let editVC = assembly.build(with: profile)
            editVC.hidesBottomBarWhenPushed = true
            if let nav = vc.navigationController {
                nav.pushViewController(editVC, animated: true)
            } else {
                // На случай отсутствия навигации — обернём в UINavigationController
                let nav = UINavigationController(rootViewController: editVC)
                nav.modalPresentationStyle = .fullScreen
                vc.present(nav, animated: true, completion: nil)
            }
        }
    }

    func openWeb(url: URL) {
        guard let nav = viewController?.navigationController else { return }
        let web = WKWebView()
        let webVC = UIViewController()
        webVC.view.addSubview(web)
        web.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            web.topAnchor.constraint(equalTo: webVC.view.topAnchor),
            web.bottomAnchor.constraint(equalTo: webVC.view.bottomAnchor),
            web.leadingAnchor.constraint(equalTo: webVC.view.leadingAnchor),
            web.trailingAnchor.constraint(equalTo: webVC.view.trailingAnchor)
        ])
        web.load(URLRequest(url: url))
        webVC.hidesBottomBarWhenPushed = true
        nav.pushViewController(webVC, animated: true)
    }

    func pushMyNFT(nfts: [MyNFT], onSaveLikes: @escaping () -> Void) {
        guard let nav = viewController?.navigationController else { return }
        let vc = MyNFTViewController()
        vc.nfts = nfts
        vc.hidesBottomBarWhenPushed = true
        vc.saveLikes = onSaveLikes
        nav.pushViewController(vc, animated: true)
    }

    func pushFavorites(nfts: [MyNFT], onSaveLikes: @escaping () -> Void) {
        guard let nav = viewController?.navigationController else { return }
        let vc = FavoritesNftViewController()
        vc.favoriteNfts = nfts
        vc.hidesBottomBarWhenPushed = true
        vc.saveLikes = onSaveLikes
        nav.pushViewController(vc, animated: true)
    }
}

