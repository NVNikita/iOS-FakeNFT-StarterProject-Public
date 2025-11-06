import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(named: "statistics_NoActive"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let statisticsController = StatisticsViewController()
        statisticsController.tabBarItem = statisticsTabBarItem
        
        let statisticsNavController = UINavigationController(rootViewController: statisticsController)
        statisticsNavController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsNavController]

        view.backgroundColor = UIColor(named: "White")
    }
}
