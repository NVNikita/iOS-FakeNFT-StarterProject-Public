import UIKit

final class TabBarController: UITabBarController {
    // Собираем сервисы здесь
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        myNftStorage: MyNftStorageImpl(),
        currencyStorage: CurrencyStorage()
    )
    
    // Tab bar items
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .catalog),
        tag: 0
    )
        
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .tabBasket),
        tag: 1
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: "Профиль"),
        image: UIImage(systemName: "person.crop.circle"),
        tag: 2
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.stats", comment: "Статистика"),
        image: UIImage(named: "statistics_NoActive"),
        tag: 3
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Профиль
        let profileController = ProfileViewController(servicesAssembly: servicesAssembly)
        profileController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        // Каталог
        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        
        // Корзина (ТВОЯ РЕАЛИЗАЦИЯ!)
        let cartPresenter = CartPresenter(nftService: servicesAssembly.nftService)
        let cartController = CartViewController(presenter: cartPresenter)
        cartPresenter.view = cartController
        cartController.tabBarItem = cartTabBarItem
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        
        // Статистика
        let userService = servicesAssembly.userService
        
        let statisticsPresenter = StatisticsPresenter(
            view: nil,
            userService: userService
        )
        
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        statisticsPresenter.view = statisticsController
        
        let statisticsNavController = UINavigationController(rootViewController: statisticsController)
        statisticsNavController.tabBarItem = statisticsTabBarItem // Используем наш настроенный TabBarItem
        
        // Порядок вкладок: Профиль, Каталог, Корзина, Статистика
        viewControllers = [
            profileNavigationController,
            catalogController,
            cartNavigationController,
            statisticsNavController // Ваша рабочая реализация
        ]
        
        // Оформление
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .secondaryLabel
        view.backgroundColor = .systemBackground
    }
}
