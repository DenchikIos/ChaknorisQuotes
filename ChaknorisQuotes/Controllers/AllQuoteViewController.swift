import UIKit
import RealmSwift

final class AllQuoteViewController: UIViewController {
    
    private var allJokes: Results<JokeRealm>!
    var allJokeTable: [JokeStruct] = []
    var oneJokeName = JokeStruct()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAllJoke()
        jokesTableView.reloadData()
    }
    
    func showAllJoke() {
        allJokes = AllJoke.shared.realm?.objects(JokeRealm.self).sorted(byKeyPath: "createdDate")
        allJokeTable.removeAll()
        if let allJokes = allJokes {
            for joke in allJokes.elements {
                oneJokeName.id = joke.id
                oneJokeName.value = joke.value
                oneJokeName.categories = joke.category?.nameOfCategory ?? ""
                oneJokeName.createdDate = joke.createdDate
                allJokeTable.append(oneJokeName)
            }
        }
        allJokeTable.sort(by: >)
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

extension AllQuoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allJokeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = allJokeTable[indexPath.row].value
        let categoryText = allJokeTable[indexPath.row].categories
        content.secondaryText = allJokeTable[indexPath.row].createdDate + " " + categoryText
        cell.contentConfiguration = content
        return cell
    }
}

extension AllQuoteViewController: UITableViewDelegate {}

