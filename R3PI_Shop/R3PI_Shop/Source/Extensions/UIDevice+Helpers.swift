//  UIDevice+Helpers.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 24.06.17.
//  Copyright © 2017 Private. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    enum DeviceModel : String {
        case iPodTouch5   = "iPod Touch 5"
        case iPodTouch6   = "iPod Touch 6"
        case iPhone4      = "iPhone 4"
        case iPhone4s     = "iPhone 4s"
        case iPhone5      = "iPhone 5"
        case iPhone5c     = "iPhone 5c"
        case iPhone5s     = "iPhone 5s"
        case iPhone6      = "iPhone 6"
        case iPhone6Plus  = "iPhone 6 Plus"
        case iPhone6s     = "iPhone 6s"
        case iPhone6sPlus = "iPhone 6s Plus"
        case iPhoneSE     = "iPhone SE"
        case iPhone7      = "iPhone 7"
        case iPhone7Plus  = "iPhone 7 Plus"
        
        case iPad2        = "iPad 2"
        case iPad3        = "iPad 3"
        case iPad4        = "iPad 4"
        case iPadAir      = "iPad Air"
        case iPadAir2     = "iPad Air 2"
        case iPadMini     = "iPad Mini"
        case iPadMini2    = "iPad Mini 2"
        case iPadMini3    = "iPad Mini 3"
        case iPadMini4    = "iPad Mini 4"
        case iPadPro      = "iPad Pro"
        case AppleTV      = "Apple TV"
        case Simulator    = "Simulator"
        case Unknown      = "Unknown"
    }
    
    var isCompactiPhone : Bool {
        switch UIDevice.current.modelName {
        case DeviceModel.iPhone5.rawValue,
             DeviceModel.iPhone5c.rawValue,
             DeviceModel.iPhone5s.rawValue,
             DeviceModel.iPhoneSE.rawValue :
            return true
            
        default:
            return false
        }
    }
    
    var isMidSizeiPhone : Bool {
        switch UIDevice.current.modelName {
        case DeviceModel.iPhone6.rawValue,
             DeviceModel.iPhone6s.rawValue,
             DeviceModel.iPhone7.rawValue :
            return true
            
        default:
            return false
        }
    }
    
    var isLargeiPhone : Bool {
        switch UIDevice.current.modelName {
        case DeviceModel.iPhone6Plus.rawValue,
             DeviceModel.iPhone6sPlus.rawValue,
             DeviceModel.iPhone7Plus.rawValue :
            return true
            
        default:
            return false
        }
    }
    
    // NOTE: zoomed mode makes each iPhone show the same UI as the standard mode of the next smaller iPhone, Theme class should be chosen properly
    var isInDisplayZoomMode : Bool {
        
        if self.isMidSizeiPhone {
            return UIScreen.main.nativeScale != UIScreen.main.scale
        }
        else if self.isLargeiPhone {
            return UIScreen.main.nativeScale > 2.8 // 2.88 zoomed, 2.6 normal
        }
        
        return false
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return DeviceModel.iPodTouch5.rawValue
        case "iPod7,1":                                 return DeviceModel.iPodTouch6.rawValue
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return DeviceModel.iPhone4.rawValue
        case "iPhone4,1":                               return DeviceModel.iPhone4s.rawValue
        case "iPhone5,1", "iPhone5,2":                  return DeviceModel.iPhone5.rawValue
        case "iPhone5,3", "iPhone5,4":                  return DeviceModel.iPhone5c.rawValue
        case "iPhone6,1", "iPhone6,2":                  return DeviceModel.iPhone5s.rawValue
        case "iPhone7,2":                               return DeviceModel.iPhone6.rawValue
        case "iPhone7,1":                               return DeviceModel.iPhone6Plus.rawValue
        case "iPhone8,1":                               return DeviceModel.iPhone6s.rawValue
        case "iPhone8,2":                               return DeviceModel.iPhone6sPlus.rawValue
        case "iPhone8,4":                               return DeviceModel.iPhoneSE.rawValue
        case "iPhone9,1", "iPhone9,3":                  return DeviceModel.iPhone7.rawValue
        case "iPhone9,2", "iPhone9,4":                  return DeviceModel.iPhone7Plus.rawValue
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return DeviceModel.iPad2.rawValue
        case "iPad3,1", "iPad3,2", "iPad3,3":           return DeviceModel.iPad3.rawValue
        case "iPad3,4", "iPad3,5", "iPad3,6":           return DeviceModel.iPad4.rawValue
        case "iPad4,1", "iPad4,2", "iPad4,3":           return DeviceModel.iPadAir.rawValue
        case "iPad5,3", "iPad5,4":                      return DeviceModel.iPadAir2.rawValue
        case "iPad2,5", "iPad2,6", "iPad2,7":           return DeviceModel.iPadMini.rawValue
        case "iPad4,4", "iPad4,5", "iPad4,6":           return DeviceModel.iPadMini2.rawValue
        case "iPad4,7", "iPad4,8", "iPad4,9":           return DeviceModel.iPadMini3.rawValue
        case "iPad5,1", "iPad5,2":                      return DeviceModel.iPadMini4.rawValue
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return DeviceModel.iPadPro.rawValue
        case "AppleTV5,3":                              return DeviceModel.AppleTV.rawValue
        case "i386", "x86_64":                          return DeviceModel.Simulator.rawValue
        default:                                        return DeviceModel.Unknown.rawValue
        }
    }
    
}
