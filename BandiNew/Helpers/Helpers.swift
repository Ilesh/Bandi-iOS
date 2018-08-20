//
//  Helpers.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

// MARK: Set view anchorpoint
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}

// MARK: Model of device
extension NSObject {
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}

// MARK: Notification.Name
extension Notification.Name {
    static let newUpNextPlaylist = Notification.Name("newUpNextPlaylist")
    static let songFinished = Notification.Name("songFinished")
    static let currentlyPlayingIndexChanged = Notification.Name("currentlyPlayingIndexChanged")
    static let currentlyPlayingPlaylistChanged = Notification.Name("currentlyPlayingPlaylistChanged")
    static let addToPlaylistSongsNumberChanged = Notification.Name("addToPlaylistSongsNumberChanged")
}

// MARK: UImage
extension UIImage {
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}


// MARK: Array rearrange
extension Array {
    mutating func rearrange(from: Int, to: Int){
        if from == to { return }
        insert(remove(at: from), at: to)
//        if from == to { return }
//        else if from > to {
//            let element = self.remove(at: from)
//            self.insert(element, at: to)
//        } else {
//            self.insert(self[from], at: to)
//            self.remove(at: from)
//        }
        
    }
}

// MARK: shuffling
extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension UITableView {
    
    // created to reduce if/else code for row and sections in table
    static func getArrayResult<T: Any>(type: T.Type, array: [Any], indexPath: IndexPath) -> T {
        if let arrayElement = array[indexPath.section] as? [T] {
            return arrayElement[indexPath.row]
        }
        else {
            let element = array[indexPath.section] as! T
            return element
        }
    }
    
    func scrollToFirstRow(animated: Bool) {
        if numberOfRows(inSection: 0) > 0 {
            DispatchQueue.main.async {
                self.setContentOffset(CGPoint(x: 0, y: -self.contentInset.top), animated: animated)
                //self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
        }
    }
    
}

class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
//    func parseVideoDurationOfYoutubeAPI(videoDuration: String?) -> String {
//
//        var videoDurationString = videoDuration! as NSString
//
//        var days: Int = 0
//        var hours: Int = 0
//        var minutes: Int = 0
//        var seconds: Int = 0
//        let timeRange = videoDurationString.replacingOccurrences(of: "P", with: "").replacingOccurrences(of: "T", with: "")
//
//        videoDurationString = timeRange as NSString
//        while videoDurationString.length > 1 {
//
//            videoDurationString = videoDurationString.substring(from: 1) as NSString
//
//            let scanner = Scanner(string: videoDurationString as String) as Scanner
//            var part: NSString?
//
//            scanner.scanCharacters(from: NSCharacterSet.decimalDigits, into: &part)
//
//            let partRange: NSRange = videoDurationString.range(of: part! as String)
//
//            videoDurationString = videoDurationString.substring(from: partRange.location + partRange.length) as NSString
//            let timeUnit: String = videoDurationString.substring(to: 1)
//
//
//            if (timeUnit == "H") {
//                hours = Int(part! as String)!
//            }
//            else if (timeUnit == "M") {
//                minutes = Int(part! as String)!
//            }
//            else if (timeUnit == "S") {
//                seconds   = Int(part! as String)!
//            }
//            else if (timeUnit == "D"){
//                days = Int(part! as String)!
//            }
//
//        }
//
//        return String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
//    }
    
    func decodedYoutubeTime() -> String {
        let trimmedTime = self.replacingOccurrences(of: "P", with: "").replacingOccurrences(of: "T", with: "")
        
        var timeComponents = trimmedTime.components(separatedBy: CharacterSet(charactersIn: "DHMS"))
        if timeComponents[timeComponents.count - 1] == "" {
            timeComponents.remove(at: timeComponents.count - 1)
        }
        timeComponents = timeComponents.reversed()
        var time = ""
        for i in 0..<timeComponents.count {
            var component = timeComponents[i]
            if i < timeComponents.count - 1 || (i == 0 && timeComponents.count == 1){
                if component.count < 2 {
                    component = "0\(component)"
                }
                component = ":\(component)"
            }
            if timeComponents.count - 1 <= i + 1 && component == "" {
                component = ":00"
            }
            time = component + time
        }
        if timeComponents.count == 1 {
            time = "0\(time)"
        }
        return time
    }
}

extension UINavigationBar {
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}

extension UIView {
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
    
    func removeSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}


