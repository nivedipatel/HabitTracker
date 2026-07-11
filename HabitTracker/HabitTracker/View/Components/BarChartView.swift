import UIKit

final class BarChartView: UIView {
    var weeklyData: [WeeklyChartData] = [] { didSet { setNeedsDisplay() } }
    var colorHex: String = "#4CAF50" { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        guard !weeklyData.isEmpty else { return }
        let ctx = UIGraphicsGetCurrentContext()
        let color = UIColor(hex: colorHex).cgColor

        let maxVal = max(weeklyData.map { $0.count }.max() ?? 1, 1)
        let barSpacing: CGFloat = 4
        let labelHeight: CGFloat = 20
        let topMargin: CGFloat = 8
        let chartHeight = rect.height - labelHeight - topMargin
        let barWidth = (rect.width - barSpacing * CGFloat(weeklyData.count + 1)) / CGFloat(weeklyData.count)
        let barWidthClamped = max(4, min(barWidth, 30))
        let totalWidth = barWidthClamped * CGFloat(weeklyData.count) + barSpacing * CGFloat(weeklyData.count + 1)
        let offsetX = max(0, (rect.width - totalWidth) / 2)

        for (i, item) in weeklyData.enumerated() {
            let barH = maxVal > 0 ? (CGFloat(item.count) / CGFloat(maxVal)) * chartHeight : 0
            let x = offsetX + barSpacing + CGFloat(i) * (barWidthClamped + barSpacing)
            let y = topMargin + chartHeight - barH
            let bar = CGRect(x: x, y: y, width: barWidthClamped, height: barH)
            ctx?.setFillColor(color)
            ctx?.fill(bar)

            // label
            let label = item.label as NSString
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 8), .foregroundColor: UIColor.secondaryLabel]
            let size = label.size(withAttributes: attrs)
            label.draw(at: CGPoint(x: x + (barWidthClamped - size.width) / 2, y: topMargin + chartHeight + 4), withAttributes: attrs)
        }
    }
}
