//
//  PlanListViewController.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

final class PlanListViewController: UIViewController {
    
    typealias CellRegistration = UICollectionView.CellRegistration<PlanCell, Content>
    typealias DataSource = UICollectionViewDiffableDataSource<State, Content>
    typealias Snapshot = NSDiffableDataSourceSnapshot<State, Content>
    
    private let viewModel: ListViewModel
    private let titleView = PlanListTitleView()
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var currentIDs = [Int : [UUID]]()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureCollectionView()
        bindData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: planLayout()
        )
        collectionView.isPagingEnabled = true
        collectionView.register(
            PlanCell.self,
            forCellWithReuseIdentifier: PlanCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func planLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration(scrollDirection: .horizontal)
        
        return UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: configuration
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        configureLayoutConstraint()
        configureDataSource()
        configureNavigationBar()
        configureLongPressGestureRecognizer()
    }
    
    private func configureViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureLayoutConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            primaryAction: UIAction { _ in 
                self.presentDetailView()
            }
        )
    }
    
    private func configureDataSource() {
        let cellRegistration = CellRegistration { (cell, indexPath, content) in
            cell.configure(
                title: content.title,
                description: content.description,
                deadline: content.deadline,
                isOverdue: content.isOverdue
            )
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, content: Content) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: content
            )
        }
        
        configureSnapshot()
    }
    
    private func configureSnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections(State.allCases)
        State.allCases.forEach {
            let contents = viewModel.fetchContents(of: $0)
            
            snapshot.appendItems(
                contents,
                toSection: $0
            )
            currentIDs[$0.rawValue] = contents.map { $0.id }
        }
        dataSource?.apply(snapshot)
    }
    
    private func bindData() {
        viewModel.listHandler = {
            self.configureSnapshot()
            self.scrollViewDidScroll(self.collectionView)
        }
    }
    
    private func presentDetailView(isEditable: Bool = true) {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        
        let detailViewController = PlanDetailViewController(viewModel: viewModel)
        
        viewModel.setEditable(isEditable)
        present(
            UINavigationController(rootViewController: detailViewController),
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegate
extension PlanListViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainder = scrollView.contentOffset.x.truncatingRemainder(
            dividingBy: view.frame.width
        )
        var index = Int(scrollView.contentOffset.x / view.frame.width)
        
        if remainder > view.frame.width / 2,
           index < State.allCases.count-1 {
            index += 1
        }
        
        let keys = currentIDs.keys.filter { currentIDs[$0] != [] }.sorted()
        let rawValue = keys.isEmpty ? 0 : keys[index] 
        let state = State(rawValue: rawValue) ?? State.allCases[0]
        
        titleView.setContents(
            title: state.name,
            count: currentIDs[rawValue]?.count ?? 0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = currentIDs[indexPath.section, default: []][indexPath.item]
        
        viewModel.selectPlan(ofID: id)
        presentDetailView(isEditable: false)
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PlanListViewController: UIGestureRecognizerDelegate {
    
    private func configureLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didLongPress)
        )
        gestureRecognizer.minimumPressDuration = 0.5
        gestureRecognizer.delegate = self
        gestureRecognizer.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let tappedPoint = gestureRecognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: tappedPoint) else { return }
        
        switch gestureRecognizer.state {
        case .began:
            presentActionSheet(indexPath: indexPath)
        default:
            return
        }
    }
    
    private func presentActionSheet(indexPath: IndexPath) {
        let tappedState = State(rawValue: indexPath.section) ?? State.allCases[0]
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let id = currentIDs[indexPath.section, default: []][indexPath.item]
        
        makeMoveActions(
            for: id,
            from: tappedState
        ).forEach { alertController.addAction($0) }
        alertController.addAction(makeDeleteAction(id: id))
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func makeMoveActions(for id: UUID, from state: State) -> [UIAlertAction] {
        State.allCases.compactMap {
            guard $0 != state else { return nil }
            
            return makeMoveAction(id: id, to: $0)
        }
    }
    
    private func makeMoveAction(id: UUID, to state: State) -> UIAlertAction {
        UIAlertAction(
            title: "Move To " + state.name,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.movePlan(ofID: id, to: state)
        }
    }
    
    private func makeDeleteAction(id: UUID) -> UIAlertAction {
        UIAlertAction(
            title: "Delete",
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.deletePlan(ofID: id)
        }
    }
}
