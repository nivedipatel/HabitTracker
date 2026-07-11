import UIKit

final class HeatmapView: UIView {
    var heatmapDays: [[HeatmapDay]] = [] { didSet { setNeedsDisplay() } }
    var colorHex: String = "#4CAF50" { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        guard !heatmapDays.isEmpty else { return }
        let ctx = UIGraphicsGetCurrentContext()
        let cols = heatmapDays.count
        let rows = 7
        let spacing: CGFloat = 2
        let totalSpacingW = spacing * CGFloat(cols - 1)
        let totalSpacingH = spacing * CGFloat(rows - 1)
        let cellSize = min((rect.width - 20 - totalSpacingW) / CGFloat(cols),
                           (rect.height - totalSpacingH) / CGFloat(rows))
        let size = max(8, cellSize)

        let color = UIColor(hex: colorHex)

        for col in 0..<cols {
            for row in 0..<rows {
                guard row < heatmapDays[col].count else { continue }
                let d = heatmapDays[col][row]
                let x = 20 + CGFloat(col) * (size + spacing)
                let y = CGFloat(row) * (size + spacing)
                let r = CGRect(x: x, y: y, width: size, height: size)
                let path = UIBezierPath(roundedRect: r, cornerRadius: 2)
                if d.isFuture {
                    UIColor.systemGray6.setFill()
                } else if d.completed {
                    color.withAlphaComponent(0.7).setFill()
                } else {
                    UIColor.systemGray4.withAlphaComponent(0.3).setFill()
                }
                path.fill()
            }
        }
    }
}
