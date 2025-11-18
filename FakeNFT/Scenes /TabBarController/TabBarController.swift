import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "tab_basket"),
        tag: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let cartPresenter = CartPresenter(nftService: servicesAssembly.nftService)
        let cartController = CartViewController(presenter: cartPresenter)
        cartPresenter.view = cartController
        
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartItem

        viewControllers = [catalogController, cartNavigationController]
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = UIColor.blackYP
        view.backgroundColor = .systemBackground
    }
}
