import UIKit

final class AddEditHabitViewController: UITableViewController {
    private let viewModel: AddEditHabitViewModel
    private let frequencies: [HabitFrequency] = HabitFrequency.allCases

    init(viewModel: AddEditHabitViewModel = AddEditHabitViewModel()) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
        title = viewModel.title
    }

    convenience init(habit: Habit) {
        self.init(viewModel: AddEditHabitViewModel(habit: habit))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "text")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "freq")
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 4 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 2
        case 2: return 1
        case 3: return 2
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ["Name", "Appearance", "Frequency", "Reminder"][section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextFieldCell
            cell.textField.text = viewModel.name
            cell.textField.placeholder = "Habit name"
            cell.onChange = { [weak self] in self?.viewModel.name = $0 }
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Icon"
            cell.detailTextLabel?.text = viewModel.iconName
            cell.accessoryType = .disclosureIndicator
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Color"
            let container = UIView()
            let swatch = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            swatch.backgroundColor = UIColor(hex: viewModel.colorHex)
            swatch.layer.cornerRadius = 12
            container.addSubview(swatch)
            cell.accessoryView = container
            cell.accessoryType = .disclosureIndicator
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "freq", for: indexPath)
            let seg = UISegmentedControl(items: frequencies.map { $0.rawValue })
            seg.selectedSegmentIndex = frequencies.firstIndex(of: viewModel.frequency) ?? 0
            seg.addTarget(self, action: #selector(freqChanged(_:)), for: .valueChanged)
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            seg.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(seg)
            NSLayoutConstraint.activate([
                seg.leadingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leadingAnchor),
                seg.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
                seg.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
                seg.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor)
            ])
            return cell
        case (3, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Time"
            let dp = UIDatePicker()
            dp.datePickerMode = .time
            dp.date = viewModel.reminderDate ?? Date()
            dp.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
            cell.accessoryView = dp
            return cell
        case (3, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let sw = UISwitch()
            sw.isOn = viewModel.reminderDate != nil
            sw.addTarget(self, action: #selector(reminderToggle(_:)), for: .valueChanged)
            cell.textLabel?.text = "Enable"
            cell.accessoryView = sw
            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == IndexPath(row: 0, section: 1) {
            let vc = IconPickerViewController(selected: viewModel.iconName) { [weak self] in self?.viewModel.iconName = $0; self?.tableView.reloadRows(at: [indexPath], with: .none) }
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath == IndexPath(row: 1, section: 1) {
            let vc = ColorPickerViewController(selected: viewModel.colorHex) { [weak self] in self?.viewModel.colorHex = $0; self?.tableView.reloadRows(at: [indexPath], with: .none) }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc private func freqChanged(_ sender: UISegmentedControl) {
        viewModel.frequency = frequencies[sender.selectedSegmentIndex]
    }

    @objc private func timeChanged(_ sender: UIDatePicker) {
        viewModel.reminderDate = sender.date
    }

    @objc private func reminderToggle(_ sender: UISwitch) {
        if !sender.isOn { viewModel.reminderDate = nil }
        else if viewModel.reminderDate == nil { viewModel.reminderDate = Date() }
    }

    @objc private func saveTapped() {
        guard viewModel.save() else {
            let alert = UIAlertController(title: "Name required", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }
}
