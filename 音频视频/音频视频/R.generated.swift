//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `Info.plist`.
    static let infoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "Info", pathExtension: "plist")
    
    /// `bundle.url(forResource: "Info", withExtension: "plist")`
    static func infoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.infoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 9 images.
  struct image {
    /// Image `ImageError`.
    static let imageError = Rswift.ImageResource(bundle: R.hostingBundle, name: "ImageError")
    /// Image `ImageSelectedSmallOff`.
    static let imageSelectedSmallOff = Rswift.ImageResource(bundle: R.hostingBundle, name: "ImageSelectedSmallOff")
    /// Image `ImageSelectedSmallOn`.
    static let imageSelectedSmallOn = Rswift.ImageResource(bundle: R.hostingBundle, name: "ImageSelectedSmallOn")
    /// Image `PlayButtonOverlayLargeTap`.
    static let playButtonOverlayLargeTap = Rswift.ImageResource(bundle: R.hostingBundle, name: "PlayButtonOverlayLargeTap")
    /// Image `PlayButtonOverlayLarge`.
    static let playButtonOverlayLarge = Rswift.ImageResource(bundle: R.hostingBundle, name: "PlayButtonOverlayLarge")
    /// Image `UIBarButtonItemArrowLeft`.
    static let uiBarButtonItemArrowLeft = Rswift.ImageResource(bundle: R.hostingBundle, name: "UIBarButtonItemArrowLeft")
    /// Image `UIBarButtonItemArrowRight`.
    static let uiBarButtonItemArrowRight = Rswift.ImageResource(bundle: R.hostingBundle, name: "UIBarButtonItemArrowRight")
    /// Image `UIBarButtonItemGrid`.
    static let uiBarButtonItemGrid = Rswift.ImageResource(bundle: R.hostingBundle, name: "UIBarButtonItemGrid")
    /// Image `VideoOverlay`.
    static let videoOverlay = Rswift.ImageResource(bundle: R.hostingBundle, name: "VideoOverlay")
    
    /// `UIImage(named: "ImageError", bundle: ..., traitCollection: ...)`
    static func imageError(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imageError, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ImageSelectedSmallOff", bundle: ..., traitCollection: ...)`
    static func imageSelectedSmallOff(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imageSelectedSmallOff, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "ImageSelectedSmallOn", bundle: ..., traitCollection: ...)`
    static func imageSelectedSmallOn(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.imageSelectedSmallOn, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "PlayButtonOverlayLarge", bundle: ..., traitCollection: ...)`
    static func playButtonOverlayLarge(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.playButtonOverlayLarge, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "PlayButtonOverlayLargeTap", bundle: ..., traitCollection: ...)`
    static func playButtonOverlayLargeTap(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.playButtonOverlayLargeTap, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "UIBarButtonItemArrowLeft", bundle: ..., traitCollection: ...)`
    static func uiBarButtonItemArrowLeft(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.uiBarButtonItemArrowLeft, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "UIBarButtonItemArrowRight", bundle: ..., traitCollection: ...)`
    static func uiBarButtonItemArrowRight(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.uiBarButtonItemArrowRight, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "UIBarButtonItemGrid", bundle: ..., traitCollection: ...)`
    static func uiBarButtonItemGrid(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.uiBarButtonItemGrid, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "VideoOverlay", bundle: ..., traitCollection: ...)`
    static func videoOverlay(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.videoOverlay, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R {
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard {
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
