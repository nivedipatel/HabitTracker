import UIKit

final class IconPickerViewController: UICollectionViewController {
    private let selectedIcon: String
    private let onSelect: (String) -> Void
    private let icons = ["star","heart","flame","bolt","book","pencil","figure.run","figure.walk","figure.yoga","bed.double","cup.and.saucer","fork.knife","drop","leaf","moon","sun.max","pill","dumbbell","book.closed","guitars","paintpalette","camera","music.note","brain.head.profile","hand.wave","globe","house","cart","bag","gift"]

    init(selected: String, onSelect: @escaping (String) -> Void) {
        self.selectedIcon = selected
        self.onSelect = onSelect
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        super.init(collectionViewLayout: layout)
        title = "Choose Icon"
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .systemBackground
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { icons.count }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let icon = icons[indexPath.item]
        let iv = UIImageView(image: UIImage(systemName: icon))
        iv.contentMode = .center
        iv.tintColor = selectedIcon == icon ? .tintColor : .label
        iv.frame = cell.contentView.bounds
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(iv)
        cell.backgroundColor = selectedIcon == icon ? UIColor.tintColor.withAlphaComponent(0.1) : .systemGray6
        cell.layer.cornerRadius = 8
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect(icons[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
}
