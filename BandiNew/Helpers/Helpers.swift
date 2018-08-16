//
//  Helpers.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/5/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

// MARK: Notification.Name
extension Notification.Name {
    static let newUpNextPlaylist = Notification.Name("newUpNextPlaylist")
    static let songFinished = Notification.Name("songFinished")
    static let currentlyPlayingIndexChanged = Notification.Name("currentlyPlayingIndexChanged")
    static let currentlyPlayingPlaylistChanged = Notification.Name("currentlyPlayingPlaylistChanged")
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
    mutating func rearrange(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indexes")
        insert(remove(at: from), at: to)
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
    
    func decodeYoutubeTime() -> String {
        let trimmedTime = self[2..<self.count]
        var timeComponents = trimmedTime.components(separatedBy: CharacterSet(charactersIn: "DHMS"))
        timeComponents.remove(at: timeComponents.count - 1)
        var time = ""
        for i in 0..<timeComponents.count {
            var component = timeComponents[i]
            if i != 0 && component.count < 2 && i <= 2 {
                component = "0\(component)"
            }
            time.append(component)
            if i != timeComponents.count - 1 {
                time.append(":")
            }
        }
        if timeComponents.count == 1 {
            time = "0:\(time)"
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
}


