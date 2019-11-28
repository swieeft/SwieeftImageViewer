# SwieeftImageViewer

iOS image viewer similar to Facebook.
<br><br>
<img src="Resource/SwieeftImageViewerExampleImage1.gif" width="300"/> <img src="Resource/SwieeftImageViewerExampleImage2.gif" width="300"/>

## Usages
```swift
public func show(originImageView: UIImageView?, contentsText: String?)
```
```swift
import SwieeftImageViewer
class ViewController: UIViewController {

  var imageViewer: SwieeftImageViewer!

  // init
  override func viewDidLoad() {
    super.viewDidLoad()
  
    imageViewer = SwieeftImageViewer(parentView: self.view)
  }
  
  func showImageViewer(imageView: UIImageView?, text: String?) {
    imageViewer.show(originImageView: imageView, contentsText: text)
  }
}
```

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install SwieeftImageViewer, simply add the following line to your Podfile:

```ruby
pod 'SwieeftImageViewer', '~> 1.0.2'
```
