import UIKit

extension UIImage {

    func rotateLeft() -> UIImage? {
        switch self.imageOrientation {
        case .right:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .up)
        case .down:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
        case .left:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
        default:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
        }
    }

    func rotateRight() -> UIImage? {
        switch self.imageOrientation {
        case .right:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
        case .down:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
        case .left:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .up)
        default:
            return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
        }
    }

    func flipVertically() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: 1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
