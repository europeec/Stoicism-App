import UIKit

extension CGImage {
    var isDark: Bool {
        guard let imageData = dataProvider?.data else { return false }
        guard let ptr = CFDataGetBytePtr(imageData) else { return false }
        let length = CFDataGetLength(imageData)
        let threshold = Int(Double(width * height) * 0.45)
        var darkPixels = 0
        for i in stride(from: 0, to: length, by: 4) {
            let r = ptr[i]
            let g = ptr[i + 1]
            let b = ptr[i + 2]
            let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
            if luminance < 150 {
                darkPixels += 1
                if darkPixels > threshold {
                    return true
                }
            }
        }
        return false
    }
}

extension UIImage {
    var isDark: Bool {
        self.cgImage?.isDark ?? false
    }
}
