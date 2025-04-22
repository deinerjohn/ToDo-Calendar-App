//
//  ToDoViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import SnapKit
import ReSwift
import domain

final class ToDoListViewController: UIViewController, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    private let viewModel: ToDoListViewModel
    private var lastLoadedItems: [ToDoItem] = []

    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)

    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.loadItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
        view.backgroundColor = .white
        setupLayout()
        StoreProvider.shared.subscribe(self)
    }

    deinit {
        StoreProvider.shared.unsubscribe(self)
    }

    func newState(state: AppState) {
        
        let items = state.toDoItems
        if items != lastLoadedItems {
            lastLoadedItems = items
            tableView.reloadData()
        }
    }

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: ToDoItemCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    @objc private func addButtonTapped() {
        let addVC = AddToDoViewController()
        let navController = UINavigationController(rootViewController: addVC)
        navController.isModalInPresentation = true
        addVC.delegate = self
        
        present(navController, animated: true)
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
        NotificationCenter.default.post(name: .didRequestLogout, object: nil)
    }
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sortedItems[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemCell.reuseIdentifier, for: indexPath) as? ToDoItemCell else {
            return UITableViewCell()
        }

        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sortedItems[indexPath.row]
        let addVC = AddToDoViewController()
        addVC.delegate = self
        let navController = UINavigationController(rootViewController: addVC)
        navController.isModalInPresentation = true
        addVC.viewState = .edit(item: item)
        
        present(navController, animated: true)
    }
    
    
}

extension ToDoListViewController: AddToDoViewController.Delegate {
    func saveItem(title: String, desc: String, startDate: String, endDate: String, priority: domain.ToDoPriority) {
        self.viewModel.addItem(title: title, description: desc, start: startDate, end: endDate, priority: priority)
    }
    
    func editItem(with id: String, title: String, desc: String, startDate: String, endDate: String, priority: ToDoPriority) {
        
        self.viewModel.updateItem(id: id, title: title, description: desc, start: startDate, end: endDate, priority: priority)
    }
    
    func deleteItem(item: ToDoItem) {
        self.viewModel.deleteItem(item)
    }
    
    
}


