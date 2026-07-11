import UIKit

final class HabitCell: UITableViewCell {
    let iconLabel = UILabel()
    let nameLabel = UILabel()
    let streakLabel = UILabel()
    let checkButton = UIButton(type: .system)
    var checkAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:)") }

    private func setup() {
        iconLabel.font = .systemFont(ofSize: 28)
        nameLabel.font = .preferredFont(forTextStyle: .body)
        streakLabel.font = .preferredFont(forTextStyle: .caption1)
        streakLabel.textColor = .secondaryLabel
        checkButton.addTarget(self, action: #selector(checkTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [iconLabel, nameLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center

        let vStack = UIStackView(arrangedSubviews: [stack, streakLabel])
        vStack.axis = .vertical
        vStack.spacing = 2

        contentView.addSubview(vStack)
        contentView.addSubview(checkButton)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            checkButton.leadingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: 12),
            checkButton.widthAnchor.constraint(equalToConstant: 44),
            checkButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(icon: String, name: String, streak: Int, isCompleted: Bool, colorHex: String) {
        iconLabel.text = icon
        nameLabel.text = name
        streakLabel.text = "Streak: \(streak) days"
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkButton.tintColor = UIColor(hex: colorHex)
    }

    @objc private func checkTapped() {
        checkAction?()
    }
}
