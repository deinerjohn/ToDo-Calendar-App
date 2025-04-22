//
//  CalendarViewModel.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import Foundation
import RxSwift
import RxCocoa
import domain

final class CalendarViewModel {

    enum Input {
        case refresh
        case itemAdded
    }
    
    enum Output {
        case items([ToDoItem])
        case error(Error)
    }
    
    private let disposeBag = DisposeBag()
    private let toDoUseCase: ToDoUseCaseProtocol
    private let userUseCase: UserUseCaseProtocol
    private let itemAddedSubject = PublishSubject<Void>()
    
    var itemAddedInput: Observable<Input> {
        return itemAddedSubject.map { _ in .itemAdded }
    }
    
    init(toDoUseCase: ToDoUseCaseProtocol, userUseCase: UserUseCaseProtocol) {
        self.toDoUseCase = toDoUseCase
        self.userUseCase = userUseCase
    }

    func transform(input: Observable<Input>) -> Observable<Output> {
        return input.flatMapLatest { [unowned self] inputEvent in
            switch inputEvent {
            case .refresh, .itemAdded:
                return loadItems()
            }
        }
    }
    
    private func loadItems() -> Observable<Output> {
        return Observable.create { [unowned self] observer in
            let userId = self.userUseCase.fetchLoggedInUserId() ?? ""
            let items = self.toDoUseCase.fetchToDoItems(for: userId)
            
            if items.isEmpty {
                observer.onNext(.error(NSError(domain: "No items found", code: 404, userInfo: nil)))
            } else {
                observer.onNext(.items(items))
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func addItem(title: String, description: String, start: String, end: String, priority: ToDoPriority) {
        guard let userId = userUseCase.fetchLoggedInUserId() else { return }

        let newItem = ToDoItem(
            id: UUID().uuidString,
            title: title,
            description: description,
            startDate: start,
            endDate: end,
            userId: userId,
            priority: priority
        )
        
        toDoUseCase.saveToDoItem(newItem)
        itemAddedSubject.onNext(())
    }
}
