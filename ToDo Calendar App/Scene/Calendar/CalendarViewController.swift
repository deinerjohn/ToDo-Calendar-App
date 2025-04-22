//
//  CalendarViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import RxSwift
import RxCocoa
import domain

class CalendarViewController: UIViewController {

    private let viewModel: CalendarViewModel
    private let disposeBag = DisposeBag()

    private let calendarView = UICalendarView()
    private let selectedDateLabel = UILabel()

    private var items: [ToDoItem] = []
    private var dateDescriptions: [DateComponents: String] = [:]
    
    private let itemAddedSubject = PublishSubject<Void>()

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        calendarView.delegate = self
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setupBindings() {
        
        let input = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
                .map { _ in CalendarViewModel.Input.refresh }
        )

        let output = viewModel.transform(input: input)

        output.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] output in
                switch output {
                case .items(let items):
                    self?.items = items
                    self?.populateDateDescriptions(with: items)
                    self?.calendarView.reloadDecorations(
                        forDateComponents: items.flatMap { $0.dateRangeComponents },
                        animated: true
                    )
                case .error(let error):
                    
                    print("Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func itemAdded() {
        itemAddedSubject.onNext(())
    }

    private func populateDateDescriptions(with items: [ToDoItem]) {
        items.forEach { item in
            guard let startDate = item.startDate.toDate(), let endDate = item.endDate.toDate() else { return }
            Date.dates(from: startDate, to: endDate).forEach { date in
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                dateDescriptions[dateComponents] = item.description
            }
        }
    }
}

extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let calendar = Calendar.current

        let removeTimeComponent = DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day
        )

        var startCount = 0
        var endCount = 0

        for item in items {
            guard
                let startDate = item.startDate.toDate(),
                let endDate = item.endDate.toDate()
            else { continue }

            let startComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
            let endComponents = calendar.dateComponents([.year, .month, .day], from: endDate)

            if startComponents == removeTimeComponent {
                startCount += 1
            }
            if endComponents == removeTimeComponent {
                endCount += 1
            }
        }

        guard startCount > 0 || endCount > 0 else { return nil }
        
        let maxDots = 5
        let totalCount = min(startCount + endCount, maxDots)
        let baseDotSize: CGFloat = 6

        let dotSize: CGFloat = totalCount > maxDots ? baseDotSize * (CGFloat(maxDots) / CGFloat(totalCount)) : baseDotSize

        let stack = UIStackView()
         stack.axis = .horizontal
         stack.spacing = 2
         stack.alignment = .center

         let greenDots = min(startCount, maxDots)
         let redDots = max(0, maxDots - greenDots)

         for _ in 0..<greenDots {
             stack.addArrangedSubview(BadgeCountView(color: .systemGreen, size: dotSize))
         }
         for _ in 0..<min(endCount, redDots) {
             stack.addArrangedSubview(BadgeCountView(color: .systemRed, size: dotSize))
         }

         return .customView {
             let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
             container.addSubview(stack)
             stack.snp.makeConstraints { make in
                 make.center.equalToSuperview()
             }
             return container
         }
    }
}

extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = dateComponents?.date else { return }

        let detailVC = ToDoListForDateViewController(date: date, viewModel: self.viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
