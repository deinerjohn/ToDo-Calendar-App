//
//  ToDoListForDateViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import domain

class ToDoListForDateViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel: CalendarViewModel
    private let selectedDate: Date
    private var filteredItems: [ToDoItem] = []
    private let disposeBag = DisposeBag()
    
    init(date: Date, viewModel: CalendarViewModel) {
        self.selectedDate = date
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        view.backgroundColor = .systemBackground
        title = formattedDate(selectedDate)

        tableView.register(ToDoDateCell.self, forCellReuseIdentifier: ToDoDateCell.reuseIdentifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    @objc private func addButtonTapped() {
        let addVC = AddToDoViewController()
        addVC.delegate = self
        let navController = UINavigationController(rootViewController: addVC)
        navController.isModalInPresentation = true
        addVC.viewState = .addonDate(selectedDate: selectedDate)
        
        present(navController, animated: true)
    }

    private func setupBindings() {
        
        let input = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
                .map { _ in CalendarViewModel.Input.refresh },
            viewModel.itemAddedInput
        )

        let output = viewModel.transform(input: input)

        output.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .items(let items):
                    self?.filterItems(items: items)
                    self?.tableView.reloadData()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }

    private func filterItems(items: [ToDoItem]) {
        let selectedDateOnly = Calendar.current.startOfDay(for: selectedDate)

        filteredItems = items.filter { item in
            guard
                let start = item.startDate.toDate()?.stripTime(),
                let end = item.endDate.toDate()?.stripTime()
            else { return false }
            
            guard start <= end else { return false }

            return (start...end).contains(selectedDateOnly)
        }.sorted {
            ($0.startDate.toDate() ?? .distantPast) < ($1.startDate.toDate() ?? .distantPast)
        }

    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension ToDoListForDateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoDateCell.reuseIdentifier, for: indexPath) as? ToDoDateCell else {
            return UITableViewCell()
        }
        cell.configure(with: item)
        return cell
    }
}

extension ToDoListForDateViewController: AddToDoViewController.Delegate {
    func saveItem(title: String, desc: String, startDate: String, endDate: String, priority: domain.ToDoPriority) {
        self.viewModel.addItem(title: title, description: desc, start: startDate, end: endDate, priority: priority)
    }
    
    func editItem(with id: String, title: String, desc: String, startDate: String, endDate: String, priority: domain.ToDoPriority) {
        //
    }
    
    func deleteItem(item: domain.ToDoItem) {
        //
    }
    
}
