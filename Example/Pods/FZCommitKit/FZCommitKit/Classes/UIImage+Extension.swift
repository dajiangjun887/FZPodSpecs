//
//  UIImage+Extension.swift
//  DXCommonServiceKit
//
//  Created by Jack on 2021/10/8.
//

import UIKit

extension UIImage {
    
    /// 通过颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 图片尺寸
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let imageRef = image.cgImage else { return nil }
        self.init(cgImage: imageRef)
    }
    
    /// 更改图片颜色
    func fz_TintColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
//        draw(in: bounds, blendMode: CGBlendMode.overlay, alpha: 1.0)
        draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)

        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return tintedImage
    }
    
    /// 获取图片某一点的颜色
    ///
    /// - Parameter point: 目标点，x、y为0-1之间的数，表示在图片中的点的比例位置
    /// - Returns: 得到的颜色
    open func fz_Color(at point: CGPoint) -> UIColor? {
        guard let imageRef = cgImage else { return nil }
        let realPointX = Int(CGFloat(imageRef.width) * point.x) + 1
        let realPointY = Int(CGFloat(imageRef.height) * point.y) + 1
        let rect = CGRect(x: 0, y: 0, width: CGFloat(imageRef.width), height: CGFloat(imageRef.height))
        let realPoint = CGPoint(x: realPointX, y: realPointY)
        guard rect.contains(realPoint) else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        guard let context = CGContext(data: pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        context.setBlendMode(.copy)
        context.translateBy(x:  -CGFloat(realPointX), y: CGFloat(realPointY - imageRef.height))
        context.draw(imageRef, in: rect)
        let red = CGFloat(pixelData[0]) / 255
        let green = CGFloat(pixelData[1]) / 255
        let blue = CGFloat(pixelData[2]) / 255
        let alpha = CGFloat(pixelData[3]) / 255
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
}

extension UIImage {
    
    /// 按比例缩放图片
    ///
    /// - Parameter scale: 缩放比例
    /// - Returns: 缩放后的图片
    open func fz_Resize(with scale: CGFloat) -> UIImage {
        let newSize = size.applying(CGAffineTransform(scaleX: scale, y: scale))
        return fz_Resize(to: newSize)
    }
    
    /// 图片缩放到指定尺寸
    ///
    /// - Parameter newSize: 新尺寸
    /// - Returns: 缩放后的图片
    open func fz_Resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return newImage
    }
    
    /// 剪切图片
    ///
    /// - Parameter rect: 剪切的范围
    /// - Returns: 剪切后的图片
    open func fz_CutImage(to rect: CGRect) -> UIImage {
        guard let cgImage = cgImage,
        let imageRef = cgImage.cropping(to: rect) else { return self }
        let refRect = CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height)
        UIGraphicsBeginImageContext(refRect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(imageRef, in: refRect)
        let image = UIImage(cgImage: imageRef)
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIImage {
    /// 对头像进行圆角返回高性能圆形图片
    /// 直接用image调用该方法
    public func fz_Cirled() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let path = UIBezierPath.init(ovalIn: .init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        path.addClip()
        self.draw(at: .zero)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func cirle(image named:String) -> UIImage? {
        return self.init(named:named)?.fz_Cirled()
    }
    
    class func circle(image file:String) -> UIImage? {
        return UIImage.init(contentsOfFile: file)?.fz_Cirled()
    }
}


extension UIImage {
    ///图片压缩限制大小，压缩图片质量（二分压缩法，压缩图片质量的优点在于，尽可能保留图片清晰度，图片不会明显模糊；缺点在于，图片过大时压到一定程度将不会再压缩，因此不能保证图片压缩后小于指定大小）
    /// - Parameter maxLength: 最大长度byte字节（比如限制1M大小，传入1024*1024）
    /// - Returns: 图片数据
    open func fz_CompressByQuality(maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression), data.count > maxLength else { return self }
        FZLog("压缩前kb: \( Double((data.count)/1024))")
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression) ?? Data()
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        FZLog("压缩后kb: \( Double((data.count)/1024))")
        let resultImage: UIImage = UIImage(data: data) ?? self
        return resultImage
    }
    
    ///图片压缩限制大小，压缩图片尺寸（压缩图片尺寸可以使图片小于指定大小，但会使图片明显模糊）
    /// - Parameter maxLength: 最大长度byte字节（比如限制1M大小，传入1024*1024）
    /// - Returns: 图片数据
    open func fz_CompressBySize(maxLength: Int) -> UIImage {
        var resultImage = self
        var lastDataLength: Int = 0
        guard var data = self.jpegData(compressionQuality: 1), data.count > maxLength else { return self }
        debugPrint("压缩前kb: \( Double((data.count)/1024))")
        while data.count > maxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: 1) ?? Data()
        }
        FZLog("压缩后kb: \( Double((data.count)/1024))")
        return resultImage
    }
    
    /// 图片压缩限制大小，压缩图片质量+尺寸（先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸）
    /// - Parameter maxLength: 最大长度byte字节（比如限制1M大小，传入1024*1024）
    /// - Returns: 图片数据
    open func fz_Compress(maxLength: Int) -> UIImage {
        // 压缩质量
        var compression: CGFloat = 1
        guard var data = self.jpegData(compressionQuality: compression), data.count > maxLength else { return self }
        FZLog("压缩前kb: \( Double((data.count)/1024))")
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression) ?? Data()
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data) ?? self
        if data.count < maxLength {
            FZLog("压缩后kb: \( Double((data.count)/1024))")
            return resultImage
        }
        
        // 压缩尺寸
        var lastDataLength: Int = 0
        while data.count > maxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression) ?? Data()
        }
        FZLog("压缩后kb: \( Double((data.count)/1024))")
        return resultImage
    }
}
