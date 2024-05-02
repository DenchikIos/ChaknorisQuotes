import UIKit
import RealmSwift

final class CatalogDetailQuoteViewController: UIViewController {
    
    private var allJokes: Results<JokeRealm>!
    var allJokeTable: [JokeStruct] = []
    var oneJokeName = JokeStruct()
    var categoryNameFromCatalogVC = ""
    
    private lazy var jokesTableView: UITableView = {
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
        allJokes = AllJoke.shared.realm?.objects(JokeRealm.self)
        showAllJoke()
    }
    
    func showAllJoke() {
        allJokes.forEach(){
            oneJokeName.id = $0.id
            oneJokeName.value = $0.value
            oneJokeName.createdDate = $0.createdDate
            oneJokeName.categories = $0.category?.nameOfCategory ?? ""
            if oneJokeName.categories == categoryNameFromCatalogVC {
                allJokeTable.append(oneJokeName)
            }
        }
    }
    
    private func setupUI(){
        view.addSubview(jokesTableView)
        view.backgroundColor = .systemBackground
    }
 
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            jokesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            jokesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            jokesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            jokesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension CatalogDetailQuoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allJokeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = allJokeTable[indexPath.item].value
        cell.contentConfiguration = content
        return cell
    }
    
}

extension CatalogDetailQuoteViewController: UITableViewDelegate {
}
