import UIKit

final class ColorPickerViewController: UICollectionViewController {
    private let selectedColor: String
    private let onSelect: (String) -> Void
    private let colors = ["#FF3B30","#FF9500","#FFCC00","#34C759","#007AFF","#5856D6","#AF52DE","#FF2D55","#5AC8FA","#00C7BE","#FF6482","#FFD60A","#32D74B","#64D2FF","#BF5AF2","#FF9F0A","#0A84FF","#6E6E6E","#AEAEB2","#636366"]

    init(selected: String, onSelect: @escaping (String) -> Void) {
        self.selectedColor = selected
        self.onSelect = onSelect
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        super.init(collectionViewLayout: layout)
        title = "Choose Color"
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .systemBackground
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { colors.count }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let hex = colors[indexPath.item]
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let swatch = UIView(frame: cell.contentView.bounds.insetBy(dx: 4, dy: 4))
        swatch.backgroundColor = UIColor(hex: hex)
        swatch.layer.cornerRadius = (52 - 8) / 2
        cell.contentView.addSubview(swatch)
        if hex == selectedColor {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor(hex: hex).cgColor
            cell.layer.cornerRadius = 8
        } else {
            cell.layer.borderWidth = 0
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect(colors[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
}
