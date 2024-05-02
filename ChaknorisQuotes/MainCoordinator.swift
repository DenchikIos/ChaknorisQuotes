import UIKit

final class MainCoordinator {
    
    private var mainTabBarController: UITabBarController
    
    init() {
        mainTabBarController = UITabBarController()
    }
    
    func start() -> UIViewController {
        setTabBarController()
        return mainTabBarController
    }
    
    private func setTabBarController(){
        mainTabBarController.tabBar.backgroundColor = .systemBackground
        addControllersToTabBar()
    }
    
    private func addControllersToTabBar(){
        mainTabBarController.viewControllers = [createRandom(), createAll(), createCatalog()]
    }
    
    private func createRandom() -> UINavigationController {
        let randomNavigationController = UINavigationController(rootViewController: RandomQuoteViewController())
        randomNavigationController.title = "Random"
        randomNavigationController.tabBarItem = UITabBarItem(title: "Random", image: UIImage(systemName:"fanblades"), tag: 0)
        return randomNavigationController
    }

    private func createAll() -> UINavigationController {
        let allNavigationController = UINavigationController(rootViewController: AllQuoteViewController())
        allNavigationController.title = "All"
        allNavigationController.tabBarItem = UITabBarItem(title: "All", image: UIImage(systemName: "textformat.size.smaller"), tag: 1)
        return allNavigationController
    }
    
    private func createCatalog() -> UINavigationController {
        let catalogNavigationController = UINavigationController(rootViewController: CatalogQuoteViewController())
        catalogNavigationController.title = "Catalog"
        catalogNavigationController.tabBarItem = UITabBarItem(title: "Catalog", image: UIImage(systemName: "graduationcap"), tag: 2)
        return catalogNavigationController
    }
}
