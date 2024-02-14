//
//  PlanDetailViewController.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

final class PlanDetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel // 전체 뷰모델이 필요한가? save랑 isEditable만 필요한데?
    private let stackView = UIStackView(
        axis: .vertical,
        spacing: 16,
        translatesAutoresizingMaskIntoConstraints: false
    )
    private let titleTextField = UITextField(placeholder: "Title")
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: Locale.preferredLanguages[0])
        
        return datePicker
    }()
    private let descriptionTextView = UITextView(keyboardDismissMode: .interactive)
    private let doneButton = UIBarButtonItem(systemItem: .done)
    private let editButton = UIBarButtonItem(systemItem: .edit)
    private let cancelButton = UIBarButtonItem(systemItem: .cancel)
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setContents()
        bindData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setContents() {
        let (state, title, deadline, description) = viewModel.fetchDetailContents()
        
        navigationItem.title = state
        titleTextField.text = title
        datePicker.date = deadline
        descriptionTextView.text = description
    }
    
    private func bindData() {
        viewModel.detailHandler = { isEditable in
            self.titleTextField.isEnabled = isEditable
            self.datePicker.isEnabled = isEditable
            self.descriptionTextView.isEditable = isEditable
            self.navigationItem.leftBarButtonItem = isEditable ? self.cancelButton : self.editButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        configureLayoutConstraint()
        configurePrimaryActions()
        configureNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.deselectPlan()
    }
    
    private func configureViewHierarchy() {
        [titleTextField, datePicker, descriptionTextView].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayoutConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func configurePrimaryActions() {
        doneButton.primaryAction = UIAction { [weak self] _ in 
            guard let self else { return }
            
            self.viewModel.savePlan(
                title: self.titleTextField.text ?? String(),
                deadline: self.datePicker.date,
                description: self.descriptionTextView.text
            )
            self.dismiss(animated: true)
        }
        editButton.primaryAction = UIAction { [weak self] _ in 
            guard let self else { return }
            
            self.viewModel.setEditable(true)
        }
        cancelButton.primaryAction = UIAction { [weak self] _ in 
            guard let self else { return }
            
            self.viewModel.setEditable(false)
            self.setContents()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = doneButton
    }
}
