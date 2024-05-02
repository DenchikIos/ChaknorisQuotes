import UIKit
import RealmSwift

final class CatalogQuoteViewController: UIViewController {
    
    private var categoriesJokes: Results<CategoriesJokesRealm>!
    var allCategoriesJokeTable: [CategoriesJokesStruct] = []
    var oneCategoryJokeName = CategoriesJokesStruct()
    
    var allJokeTable: [JokeStruct] = []
    var oneJokeName = JokeStruct()
    
    private lazy var categoriesTableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 50
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        categoriesJokes = AllJoke.shared.realm?.objects(CategoriesJokesRealm.self)
        showAllJoke()
    }
    
    func showAllJoke() {
        categoriesJokes.forEach(){
            oneCategoryJokeName.nameOfCategory = $0.nameOfCategory
            allCategoriesJokeTable.append(oneCategoryJokeName)
        }
    }
    
    private func setupUI(){
        view.addSubview(categoriesTableView)
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension CatalogQuoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoriesJokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = allCategoriesJokeTable[indexPath.item].nameOfCategory.description
        cell.contentConfiguration = content
        return cell
    }
}

extension CatalogQuoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jokeCategoryVC = CatalogDetailQuoteViewController()
        jokeCategoryVC.categoryNameFromCatalogVC = allCategoriesJokeTable[indexPath.item].nameOfCategory
        navigationController?.pushViewController(jokeCategoryVC, animated: true)
    }
}
