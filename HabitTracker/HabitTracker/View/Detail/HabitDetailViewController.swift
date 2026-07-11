import UIKit

final class HabitDetailViewController: UIViewController {
    private let viewModel: HabitDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let currentLabel = UILabel()
    private let longestLabel = UILabel()
    private let heatmapView = HeatmapView()
    private let chartView = BarChartView()

    init(habit: Habit) {
        self.viewModel = HabitDetailViewModel(habit: habit)
        super.init(nibName: nil, bundle: nil)
        title = habit.name
    }

    required init?(coder: NSCoder) { fatalError("init(coder:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        setupScrollView()
        setupContent()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func makeStatBox(title: String, value: String, unit: String) -> UIView {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 0
        let bold = NSAttributedString(string: value, attributes: [.font: UIFont.systemFont(ofSize: 36, weight: .bold)])
        let mid = NSAttributedString(string: "\n\(unit)\n", attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1), .foregroundColor: UIColor.secondaryLabel])
        let top = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption2), .foregroundColor: UIColor.secondaryLabel])
        let ma = NSMutableAttributedString(attributedString: top)
        ma.append(mid)
        ma.append(bold)
        v.attributedText = ma
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 12
        v.clipsToBounds = true
        return v
    }

    private func setupContent() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        // Stats row
        let stats = UIStackView(arrangedSubviews: [
            makeStatBox(title: "Current Streak", value: "\(viewModel.currentStreak)", unit: "days"),
            makeStatBox(title: "Longest Streak", value: "\(viewModel.longestStreak)", unit: "days")
        ])
        stats.axis = .horizontal
        stats.spacing = 16
        stats.distribution = .fillEqually
        stack.addArrangedSubview(stats)

        // Heatmap
        let heatLabel = UILabel()
        heatLabel.text = "History"
        heatLabel.font = .preferredFont(forTextStyle: .headline)
        stack.addArrangedSubview(heatLabel)

        heatmapView.heatmapDays = viewModel.heatmapDays
        heatmapView.colorHex = viewModel.habit.colorHex
        heatmapView.translatesAutoresizingMaskIntoConstraints = false
        heatmapView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stack.addArrangedSubview(heatmapView)

        // Chart
        let chartLabel = UILabel()
        chartLabel.text = "Weekly Completions"
        chartLabel.font = .preferredFont(forTextStyle: .headline)
        stack.addArrangedSubview(chartLabel)

        chartView.weeklyData = viewModel.weeklyData
        chartView.colorHex = viewModel.habit.colorHex
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(chartView)
    }

    @objc private func editTapped() {
        let vc = AddEditHabitViewController(habit: viewModel.habit)
        navigationController?.pushViewController(vc, animated: true)
    }
}
