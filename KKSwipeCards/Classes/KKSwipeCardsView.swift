//
//  KKSwipeCardsView.swift
//  KKSwipeCards
//
//  Created by Vinoth on 30/09/17.
//

import Foundation
import UIKit

public enum SwipeMode {
  case left
  case right
  case top
  case bottom
}

public protocol KKSwipeCardsViewDelegate: class {
  func swipedLeft(_ object: Any)
  func swipedRight(_ object: Any)
  func swipedTop(_ object: Any)
  func swipedBottom(_ object: Any)
  func cardTapped(_ object: Any)
  func reachedEndOfStack()
}

public class KKSwipeCardsView<Element>: UIView {

  public weak var delegate: KKSwipeCardsViewDelegate?
  public var bufferSize: Int = 2

  fileprivate let viewGenerator: ViewGenerator
  fileprivate let overlayGenerator: OverlayGenerator?
  var allCards = [Element]()
  var loadedCards = [KKSwipeCard]()

  public typealias ViewGenerator = (_ element: Element, _ frame: CGRect) -> (UIView)
  public typealias OverlayGenerator = (_ element: Element, _ mode: SwipeMode, _ frame: CGRect) -> (UIView)
  public init(frame: CGRect,
              viewGenerator: @escaping ViewGenerator,
              overlayGenerator: OverlayGenerator? = nil) {
    self.overlayGenerator = overlayGenerator
    self.viewGenerator = viewGenerator
    super.init(frame: frame)
    self.isUserInteractionEnabled = false
  }

  override private init(frame: CGRect) {
    fatalError("Please use init(frame:,viewGenerator)")
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("Please use init(frame:,viewGenerator)")
  }

  public func addCards(_ elements: [Element], onTop: Bool = false) {
    if elements.isEmpty {
      return
    }

    self.isUserInteractionEnabled = true

    if onTop {
      for element in elements.reversed() {
        allCards.insert(element, at: 0)
      }
    } else {
      for element in elements {
        allCards.append(element)
      }
    }

    if onTop && loadedCards.count > 0 {
      for cv in loadedCards {
        cv.removeFromSuperview()
      }
      loadedCards.removeAll()
    }

    for element in elements {
      if loadedCards.count < bufferSize {
        let cardView = self.createCardView(element: element)
        if loadedCards.isEmpty {
          self.addSubview(cardView)
        } else {
          self.insertSubview(cardView, belowSubview: loadedCards.last!)
        }
        self.loadedCards.append(cardView)
      }
    }
  }

  func swipeTopCardRight() {
    // TODO: not yet supported
    fatalError("Not yet supported")
  }

  func swipeTopCardLeft() {
    // TODO: not yet supported
    fatalError("Not yet supported")
  }
}

extension KKSwipeCardsView: KKSwipeCardDelegate {
  func cardSwipedTop(_ card: KKSwipeCard) {
    self.handleSwipedCard(card)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
      self.delegate?.swipedTop(card.obj)
      self.loadNextCard()
    }
  }

  func cardSwipedBottom(_ card: KKSwipeCard) {
    self.handleSwipedCard(card)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
      self.delegate?.swipedBottom(card.obj)
      self.loadNextCard()
    }
  }

  func cardSwipedLeft(_ card: KKSwipeCard) {
    self.handleSwipedCard(card)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
      self.delegate?.swipedLeft(card.obj)
      self.loadNextCard()
    }
  }

  func cardSwipedRight(_ card: KKSwipeCard) {
    self.handleSwipedCard(card)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
      self.delegate?.swipedRight(card.obj)
      self.loadNextCard()
    }
  }

  func cardTapped(_ card: KKSwipeCard) {
    self.delegate?.cardTapped(card.obj)
  }
}

extension KKSwipeCardsView {
  fileprivate func handleSwipedCard(_ card: KKSwipeCard) {
    self.loadedCards.removeFirst()
    self.allCards.removeFirst()
    if self.allCards.isEmpty {
      self.isUserInteractionEnabled = false
      self.delegate?.reachedEndOfStack()
    }
  }

  fileprivate func loadNextCard() {
    if self.allCards.count - self.loadedCards.count > 0 {
      let next = self.allCards[loadedCards.count]
      let nextView = self.createCardView(element: next)
      let below = self.loadedCards.last!
      self.loadedCards.append(nextView)
      self.insertSubview(nextView, belowSubview: below)
    }
  }

  fileprivate func createCardView(element: Element) -> KKSwipeCard {
    let cardView = KKSwipeCard(frame: self.bounds)
    cardView.delegate = self
    cardView.obj = element
    let sv = self.viewGenerator(element, cardView.bounds)
    cardView.addSubview(sv)
    cardView.leftOverlay = self.overlayGenerator?(element, .left, cardView.bounds)
    cardView.rightOverlay = self.overlayGenerator?(element, .right, cardView.bounds)
    cardView.topOverlay = self.overlayGenerator?(element, .top, cardView.bounds)
    cardView.bottomOverlay = self.overlayGenerator?(element, .bottom, cardView.bounds)
    cardView.configureOverlays()
    return cardView
  }
}
