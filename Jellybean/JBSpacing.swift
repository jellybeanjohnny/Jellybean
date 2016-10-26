//
//  JBSpacing.swift
//  Jellybean
//
//  Created by Matt Amerige on 10/24/16.
//  Copyright © 2016 BuildThings. All rights reserved.
//

import Foundation

/**
 JBSpacing provides the API through which the spacing for reviewing items is set.
 There are only two public methods, increaseSpacing and decreaseSpacing,
 and two public property, the daysUntilRepetition, and dueDate.
 
 As items are recalled correctly the daysUntilRepetition roughly doubles, 
 and if incorrectly recalled the value is halved.
 
 This is a simple implementation based on the Leitner System for spaced repetition
 
 */
public class JBSpacing: NSObject, NSCoding {
  
  /// Starts at zero
  private(set) public var daysUntilRepetition = 0
  
  /// Starts at today
  private(set) public var dueDate = Date()

  public override var description: String {
    return "Days until repetition: \(daysUntilRepetition)\nDueDate: \(dueDate)"
  }
  
  public override init() {
    super.init()
  }

  
  /// Call this after a card is recalled correctly to increment the spacing.
  public func increaseSpacing() {
    daysUntilRepetition = daysUntilRepetition * 2 + 1
    adjustDueDate(forValue: daysUntilRepetition)
  }
  
  /// Call  this after a card is recalled incorrectly to decrement the spacing
  public func decreaseSpacing() {
    // since this is integer division the answer will always discard any remainder, that is intentional.
    daysUntilRepetition = daysUntilRepetition / 2
    adjustDueDate(forValue: daysUntilRepetition)
  }
  
  func adjustDueDate(forValue spacing: Int) {
    
    if spacing <= 0 {
      dueDate = Date()
    } else if let nextDueDate = Calendar.current.date(byAdding: .day, value: spacing, to: dueDate) {
      dueDate = nextDueDate      
    }
  }
  
  // MARK: - NSCoding
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.daysUntilRepetition, forKey: "daysUntilRepetition")
    aCoder.encode(self.dueDate, forKey: "dueDate")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    self.daysUntilRepetition = Int(aDecoder.decodeInt64(forKey: "daysUntilRepetition"))
    self.dueDate = aDecoder.decodeObject(forKey: "dueDate") as! Date
  }

  
}
