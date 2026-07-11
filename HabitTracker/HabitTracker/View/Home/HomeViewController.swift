import UIKit
import Combine

final class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Streaks"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupTableView()
        setupEmptyLabel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        viewModel.$habits.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tableView.reloadData()
            self?.updateEmptyState()
        }.store(in: &viewModel.cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHabits()
    }

    private func setupTableView() {
        tableView.register(HabitCell.self, forCellReuseIdentifier: "HabitCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyLabel() {
        emptyLabel.text = "No habits yet.\nTap + to add one."
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyLabel.isHidden = true
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !viewModel.habits.isEmpty
        tableView.isHidden = viewModel.habits.isEmpty
    }

    @objc private func addTapped() {
        navigationController?.pushViewController(AddEditHabitViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitCell
        let habit = viewModel.habits[indexPath.row]
        cell.configure(icon: habit.iconName, name: habit.name, streak: viewModel.streak(for: habit), isCompleted: viewModel.isCompletedToday(habit), colorHex: habit.colorHex)
        cell.checkAction = { [weak self] in
            self?.viewModel.toggleCompletion(for: habit)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = HabitDetailViewController(habit: viewModel.habits[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let del = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else { return }
            self.viewModel.deleteHabit(self.viewModel.habits[indexPath.row])
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [del])
    }

    func tableView(_ tableView: UITableView, moveRowAt source: IndexPath, to dest: IndexPath) {
        viewModel.moveHabit(from: source.row, to: dest.row)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
}

