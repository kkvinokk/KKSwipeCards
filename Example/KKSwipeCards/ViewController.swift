//
//  ViewController.swift
//  KKSwipeCards
//
//  Created by Vinoth Anandan on 09/30/2017.
//  Copyright (c) 2017 Vinoth Anandan. All rights reserved.
//

import UIKit
import KKSwipeCards

class ViewController: UIViewController {

  /*
   * In this example we're using `Dictionary [String: String]` as a card detail.
   * You can use KKSwipeCardsView though with any custom class.
   */

  private var arrayOfCardDetails: [[String: String]] = [
    ["name": "Metallica Concert", "image": "image1.png", "location": "Palace Grounds"],
    ["name": "Wine Tasting", "image": "image2.png", "location": "Links Brewery"],
    ["name": "Summer Noon Party", "image": "image3.png", "location": "Electronic City"],
    ["name": "Saree Exhibition ", "image": "image4.png", "location": "Sarjapur Road"],
    ["name": "Impressions & Expressions", "image": "image5.png", "location": "Malleswaram Grounds"],
    ["name": "Summer workshop", "image": "image6.png", "location": "Whitefield"],
    ["name": "Wine Tasting", "image": "image7.png", "location": "MG Road"],
    ["name": "Barbecue Fridays", "image": "image8.png", "location": "Links Brewery"],
    ["name": "Impressions & Expressions", "image": "image9.png", "location": "Palace Grounds"],
    ["name": "Metallica Concert", "image": "image1.png", "location": "Indiranagar"],
    ["name": "Rock and Roll nights", "image": "image2.png", "location": "Electronic City"],
    ["name": "Summer workshop", "image": "image3.png", "location": "Malleswaram Grounds"],
    ["name": "Startups Meet", "image": "image4.png", "location": "Indiranagar"],
    ["name": "Italian carnival", "image": "image5.png", "location": "Whitefield"],
    ["name": "Summer Noon Party", "image": "image6.png", "location": "MG Road"],
    ["name": "Wine Tasting", "image": "image7.png", "location": "Palace Grounds"],
    ["name": "Barbecue Fridays", "image": "image8.png", "location": "Links Brewery"],
    ["name": "Saree Exhibition ", "image": "image9.png", "location": "Kanteerava Indoor Stadium "],
    ["name": "Rock and Roll nights", "image": "image1.png", "location": "Sarjapur Road"],
    ["name": "Impressions & Expressions", "image": "image2.png", "location": "Kumara Park"],
    ["name": "Metallica Concert", "image": "image3.png", "location": "Links Brewery"],
    ["name": "Italian carnival", "image": "image4.png", "location": "Electronic City"],
    ["name": "Summer workshop", "image": "image5.png", "location": "Malleswaram Grounds"],
    ["name": "Barbecue Fridays", "image": "image6.png", "location": "MG Road"],
    ["name": "Italian carnival", "image": "image7.png", "location": "Links Brewery"],
    ["name": "Wine Tasting", "image": "image8.png", "location": "Palace Grounds"],
    ["name": "Rock and Roll nights", "image": "image9.png", "location": "Indiranagar"],
    ["name": "Summer Noon Party", "image": "image1.png", "location": "Whitefield"],
    ["name": "Metallica Concert", "image": "image2.png", "location": "Sarjapur Road"],
    ["name": "Summer workshop", "image": "image3.png", "location": "Electronic City"],
    ["name": "Startups Meet", "image": "image4.png", "location": "Malleswaram Grounds"]
    ]
  private var actionTexts: [SwipeMode: String] = [.left: "👍", .right: "👎", .top: "👆", .bottom: "👇"]
  private var actionColors: [SwipeMode: UIColor] = [.left: .init(red: 145/255, green: 85/255, blue: 77/255, alpha: 0.7),
                                                    .right: .init(red: 78/255, green: 105/255, blue: 26/255, alpha: 0.7),
                                                    .top: .init(red: 106/255, green: 26/255, blue: 74/255, alpha: 0.7),
                                                    .bottom: .init(red: 90/255, green: 39/255, blue: 41/255, alpha: 0.7)]
  private var previousContacts = [[String: String]]()
  private var swipeView: KKSwipeCardsView<[String: String]>!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSwipeView()
    setupLoadCards()
    self.swipeView.addCards(arrayOfCardDetails, onTop: true)
    self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
  }

  private func setupSwipeView() {
    let viewGenerator: ([String: String], CGRect) -> (UIView) = { (element: [String: String], frame: CGRect) -> (UIView) in
      let container = UIView(frame: CGRect(x: 30, y: 0, width: frame.width - 60, height: frame.height - 40))
      container.clipsToBounds = true
      container.layer.cornerRadius = 16
      container.backgroundColor = .white

      let label = UILabel(frame: CGRect(x: 10, y: 0, width: container.frame.width - 20, height: container.frame.height - container.frame.width))
      label.text = element["name", default: ""] + "\n\n" + element["location", default: ""]
      label.textAlignment = .center
      label.numberOfLines = 0
      label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
      container.addSubview(label)

      let imageView = UIImageView(image: UIImage(named: element["image", default: "image1.png"]))
      imageView.frame = CGRect(x: 0, y: container.frame.height - container.frame.width, width: container.frame.width, height: container.frame.width)
      imageView.contentMode = .scaleAspectFit
      container.addSubview(imageView)

      return container
    }

    let overlayGenerator: ([String: String], SwipeMode, CGRect) -> (UIView) = { (element: [String: String], mode: SwipeMode, frame: CGRect) -> (UIView) in
      let label = UILabel()
      label.frame.size = CGSize(width: 100, height: 100)
      label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
      label.layer.cornerRadius = label.frame.width / 2
      label.backgroundColor = self.actionColors[mode]!.withAlphaComponent(0.7)
      label.clipsToBounds = true
      label.text = self.actionTexts[mode]
      label.font = UIFont.systemFont(ofSize: 24)
      label.textAlignment = .center
      return label
    }

    let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
    swipeView = KKSwipeCardsView<[String: String]>(frame: frame,
                                                   viewGenerator: viewGenerator,
                                                   overlayGenerator: overlayGenerator)
    swipeView.delegate = self
    self.view.addSubview(swipeView)
  }

  private func setupLoadCards() {
    let button = UIButton(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 40))
    button.setTitle("Load cards", for: .normal)
    button.setTitleColor(.brown, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    self.view.addSubview(button)
  }

  @objc private func buttonTapped() {
    let ac = UIAlertController(title: "Load on top / on bottom?", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "On Top", style: .default, handler: { (_: UIAlertAction) in
      self.swipeView.addCards(self.arrayOfCardDetails, onTop: true)
    }))
    ac.addAction(UIAlertAction(title: "On Bottom", style: .default, handler: { (_: UIAlertAction) in
      self.swipeView.addCards(self.arrayOfCardDetails, onTop: false)
    }))
    self.present(ac, animated: true, completion: nil)
  }
}

extension ViewController: KKSwipeCardsViewDelegate {
  func swipedTop(_ object: Any) {
    let contact = object as! [String: String]
    previousContacts.insert(contact, at: 0)
  }

  func swipedBottom(_ object: Any) {
    let contact = object as! [String: String]
    if previousContacts.count > 0 {
      let previousContact = previousContacts[0]
      previousContacts.remove(at: 0)
      swipeView.addCards([previousContact, contact], onTop: true)
    } else {
      swipeView.addCards([contact], onTop: true)
    }
  }

  func swipedLeft(_ object: Any) {
    let contact = object as! [String: String]
    previousContacts.insert(contact, at: 0)
  }

  func swipedRight(_ object: Any) {
    let contact = object as! [String: String]
    previousContacts.insert(contact, at: 0)
  }

  func cardTapped(_ object: Any) {
    print("Tapped on: \(object)")
  }

  func reachedEndOfStack() {
    print("Reached end of stack")
  }
}
