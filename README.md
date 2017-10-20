# KKSwipeCards

![Screenshot](Screens/example.gif)

[![Version](https://img.shields.io/cocoapods/v/KKSwipeCards.svg?style=flat)](http://cocoapods.org/pods/KKSwipeCards)
[![License](https://img.shields.io/cocoapods/l/KKSwipeCards.svg?style=flat)](http://cocoapods.org/pods/KKSwipeCards)
[![Platform](https://img.shields.io/cocoapods/p/KKSwipeCards.svg?style=flat)](http://cocoapods.org/pods/KKSwipeCards)

## Example

To run the example project, clone the repo and run `pod install` from the Example directory first.

## Requirements
- iOS 8 or later
- Swift 4.0

## Installation

KKSwipeCards is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "KKSwipeCards"
```

## How to use

First import the module:
```swift
import KKSwipeCards
```
Next create an instance of a `KKSwipeCardsView`:
(`Element` can be your custom model, or just `[String: String]`)
```swift
let swipeView = KKSwipeCardsView<Element>(frame: frame,
                                          viewGenerator: viewGenerator,
                                          overlayGenerator: overlayGenerator)
```
Views get loaded lazy, so you have to provide `KKSwipeCardsView` with a ViewGenerator and optionally an OverlayGenerator.
```swift
let viewGenerator: ([String: String], CGRect) -> (UIView) = { (element: [String: String], frame: CGRect) -> (UIView) in
  // return a Card(UIView)
}

let overlayGenerator: ([String: String], SwipeMode, CGRect) -> (UIView) = { (element: [String: String], mode: SwipeMode, frame: CGRect) -> (UIView) in
  // return a Overlay design(UIView)
}
```
### Adding cards

To add new cards, just call the `addCards` method with an array of the previously defined `Element`:
```swift
swipeView.addCards([String: String], onTop: true)
```
### Delegate

`KKSwipeCardsView` has a delegate property so you can get informed when a card has been swiped. The delegate has to implement following methods:
```swift
func swipedLeft(_ object: Any)
func swipedRight(_ object: Any)
func swipedTop(_ object: Any)
func swipedBottom(_ object: Any)
func cardTapped(_ object: Any)
func reachedEndOfStack()
```
The `object` parameter is guaranteed to have the type `Element`. Making `Element` as generics in delegate will increase complexity.

## Example

For a nice working demo sample, please take a look the [Example](https://github.com/kkvinokk/KKSwipeCards/tree/master/Example) project.
Run `pod install` to run the example in the `Example` directory.

## Credits

### Added features over [DMSwipeCards](https://github.com/D-32/DMSwipeCards)

- Swipe top and bottom
- Passing data in `overlayGenerator`
- Card won't swipe if user touch in scrollView part of card (In GestureRecognizer, shouldRecognizeSimultaneouslyWith is made false)
- Example with retaining the previous card when swiping in bottom

## Author

Vinoth Anandan, kkvinokk@gmail.com

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kkvinokk/KKSwipeCards.

## License

KKSwipeCards is available under the [MIT License](http://opensource.org/licenses/MIT). See the [License](https://github.com/kkvinokk/KKSwipeCards/blob/master/LICENSE) file for more info.