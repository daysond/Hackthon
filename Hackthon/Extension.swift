//
//  Extension.swift
//  Hackthon
//
//  Created by Dayson Dong on 2022-02-12.
//

import Foundation
import UIKit

extension UIColor {
    
    static let offWhite = UIColor(red: 248, green: 238, blue: 255, alpha: 1)
    static let whiteSmoke =  UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    static let ghostWhite = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
    static let black85 = UIColor(red: 0/255.0, green: 0/255.0, blue:  0/255.0, alpha: 0.85)
    
    func isEqualToColor(_ color: UIColor) -> Bool {
        
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255) )
        
        
    }
    
    
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension String {
    
    static func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
      }
    
    func textHeightFor(font: UIFont, width: CGFloat) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
        
    }
    
}
