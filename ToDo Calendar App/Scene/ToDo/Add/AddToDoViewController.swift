//
//  AddToDoViewController.swift
//  ToDo Calendar App
//
//  Created by Deiner John Calbang on 4/21/25.
//

import UIKit
import SnapKit
import domain

final class AddToDoViewController: UIViewController {
    
    protocol Delegate: AnyObject {
        func saveItem(title: String, desc: String, startDate: String, endDate: String, priority: ToDoPriority)
        func editItem(with id: String, title: String, desc: String, startDate: String, endDate: String, priority: ToDoPriority)
        func deleteItem(item: ToDoItem)
    }
    
    enum ViewState {
        case add
        case addonDate(selectedDate: Date)
        case edit(item: ToDoItem)
    }

    var itemId: String = ""
    var viewState: ViewState = .add
    
    weak var delegate: Delegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 12
        
        return stack
    }()
    
    private lazy var titleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Title"
        textField.textContentType = .jobTitle
        textField.returnKeyType = .next
        textField.delegate = self
        return textField
    }()

    private lazy var titleView = TextFieldError(textField: titleTextField)
    
    private lazy var descriptionTextView: CustomTextView = {
        let view = CustomTextView()
        view.placeholder = "Description"
        view.isScrollEnabled = false
        view.delegate = self
        view.returnKeyType = .default
        return view
    }()
    private var descriptionHeightConstraint: Constraint?
    
    
    private lazy var startPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        return picker
    }()
    private lazy var startDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Start Date"
        textField.textContentType = .dateTime
        textField.returnKeyType = .next
        textField.tintColor = .clear
        textField.inputView = startPicker
        return textField
    }()
    private lazy var startDateView = TextFieldError(textField: startDateField)
    
    
    private lazy var endPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    private lazy var endDateField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "End Date"
        textField.textContentType = .dateTime
        textField.returnKeyType = .next
        textField.tintColor = .clear
        textField.inputView = endPicker
        return textField
    }()
    private lazy var endDateView = TextFieldError(textField: endDateField)
    
    private let priorityControl = UISegmentedControl(items: ToDoPriority.allCases.map { $0.valueText } )
    
    private lazy var saveButton: SystemButton = {
        let button = SystemButton()
        button.kind = .main
        
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: SystemButton = {
        let button = SystemButton()
        button.kind = .black
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        switch viewState {
        case .add, .addonDate:
            title = "Add ToDo"
        case .edit:
            title = "Edit ToDo"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Exit",
            style: .plain,
            target: self,
            action: #selector(exitTapped)
        )
        
        setupLayout()
        populateIfNeeded()
    }
    
    @objc private func exitTapped() {
        dismiss(animated: true)
    }

    private func setupLayout() {
        priorityControl.selectedSegmentIndex = 0


        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalTo(self.view).offset(20).inset(20)
            make.width.equalTo(view).offset(-40)
        }
        
        mainStack.addArrangedSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        mainStack.addArrangedSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(100)
            self.descriptionHeightConstraint = make.height.equalTo(100).constraint
        }
        
        mainStack.addArrangedSubview(startDateView)
        
        mainStack.addArrangedSubview(endDateView)
        
        mainStack.addArrangedSubview(priorityControl)
        priorityControl.snp.makeConstraints { make in
            make.height.equalTo(titleView)
        }
        
        mainStack.addArrangedSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        mainStack.addArrangedSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        deleteButton.isHidden = true
        
        setupDatePickers()
    }

    private func setupDatePickers() {
        
        startDateField.inputView = startPicker
        endDateField.inputView = endPicker

        let startToolbar = UIToolbar()
        startToolbar.sizeToFit()
        let endToolbar = UIToolbar()
        endToolbar.sizeToFit()

        startToolbar.setItems([UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartDate))], animated: false)
        endToolbar.setItems([UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndDate))], animated: false)

        startDateField.inputAccessoryView = startToolbar
        endDateField.inputAccessoryView = endToolbar

        endPicker.minimumDate = startPicker.date
    }
    
    @objc private func startDateChanged(_ picker: UIDatePicker) {
        endPicker.minimumDate = picker.date

        if endPicker.date < picker.date {
            endPicker.date = picker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            endDateField.text = formatter.string(from: picker.date)
        }
    }

    private func populateIfNeeded() {
        
        switch viewState {
        case .addonDate(let selectedDate):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            startDateField.text = formatter.string(from: selectedDate)
            startDateField.textInputDisabled = true // Disable editing
            deleteButton.isHidden = true
            
            endPicker.minimumDate = selectedDate
            
            if let endDateText = endDateField.text, let endDate = formatter.date(from: endDateText), endDate < selectedDate {
                endDateField.text = formatter.string(from: selectedDate)
            }
            
        case .edit(let item):
            
            titleTextField.text = item.title
            descriptionTextView.text = item.description
            startDateField.text = item.startDate
            endDateField.text = item.endDate
            priorityControl.selectedSegmentIndex = ToDoPriority.allCases.firstIndex(of: item.priority) ?? 0
            deleteButton.isHidden = false

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let start = formatter.date(from: item.startDate) {
                startPicker.date = start
            }
            if let end = formatter.date(from: item.endDate) {
                endPicker.date = end
            }
            
            endPicker.minimumDate = startPicker.date
            
        default: break
            
        }
    }

    @objc private func doneStartDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let newStartDate = startPicker.date
        let selectedEndDate = endDateField.text?.toDate() ?? endPicker.date

        // Only set if new start is not after end
        if newStartDate > selectedEndDate {
            startDateView.showError("Start date can't be after end date.")
            endDateField.text = ""
        } else {
            startDateField.text = formatter.string(from: newStartDate)
            startDateView.hideError()

            endPicker.minimumDate = newStartDate
            view.endEditing(true)
        }

    }

    @objc private func doneEndDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let newEndDate = endPicker.date
        let selectedStartDate = endDateField.text?.toDate() ?? endPicker.date

        if newEndDate < selectedStartDate {
            endDateView.showError("End date can't be before start date.")
        } else {
            endDateField.text = formatter.string(from: newEndDate)
            endDateView.hideError()
            view.endEditing(true)
        }

    }

    @objc private func handleSave() {
        
        let isTitleValid = !(titleTextField.text?.isEmpty ?? true)
        let isStartDateValid = !(startDateField.text?.isEmpty ?? true)
        let isEndDateValid = !(endDateField.text?.isEmpty ?? true)

        if !isTitleValid {
            titleView.showError("Title is required")
        }

        if !isStartDateValid {
            startDateView.showError("Start Date is required")
        }

        if !isEndDateValid {
            endDateView.showError("End Date is required")
        }

        guard isTitleValid, isStartDateValid, isEndDateValid else {
            return
        }
        
        guard let title = titleTextField.text,
              let desc = descriptionTextView.text,
              let start = startDateField.text,
              let end = endDateField.text,
              !title.isEmpty, !start.isEmpty, !end.isEmpty else {
            return
        }

        let selectedPriority: ToDoPriority = ToDoPriority.allCases[priorityControl.selectedSegmentIndex]
        
        switch viewState {
        case .edit(let item):
            self.delegate?.editItem(with: item.id, title: title, desc: desc, startDate: start, endDate: end, priority: selectedPriority)
        default:
            self.delegate?.saveItem(title: title, desc: desc, startDate: start, endDate: end, priority: selectedPriority)
        }
        
       
        dismiss(animated: true)
    }

    @objc private func handleDelete() {
        switch viewState {
        case .edit(let item):
            self.delegate?.deleteItem(item: item)
        default: break
        }
        dismiss(animated: true)
    }
}

extension AddToDoViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
             let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                 return false
         }
         let substringToReplace = textFieldText[rangeOfTextToReplace]
         let count = textFieldText.count - substringToReplace.count + string.count
         return count <= 32
    }
}

extension AddToDoViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        return count <= 250
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedHeight = textView.sizeThatFits(size).height
        let clampedHeight = max(100, min(estimatedHeight, 250))

        descriptionHeightConstraint?.update(offset: clampedHeight)

        textView.isScrollEnabled = estimatedHeight > 250
    }

}

extension AddToDoViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
