//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        let usd: Int = convertToUSD(self)
        return Money(amount: toConvert(usd, target: to), currency: to)
    }
    
    /*
     USD to USD =  1 : 1
     GBP to USD = .5 : 1
     EUR to USD =  2/3 : 1
     CAN to USD =  4/5 : 1 */
    // Converts current currency to USD
    private func convertToUSD(_ cur: Money) -> Int {
        switch cur.currency {
        case "GBP":
            return cur.amount * 2
        case "EUR":
            return cur.amount * 2 / 3
        case "CAN":
            return cur.amount * 4 / 5
        default: //"USD"
            return cur.amount
        }
    }
   
       /*USD to GBP     0.5
         USD to EUR     1.5
         USD to CAN     1.25 */
    // Converts USD to target currency
    private func toConvert (_ usd: Int, target: String) -> Int {
        var result: Int = usd
        switch target {
        case "GBP":
            result = usd / 2
        case "EUR":
            result = Int(Double(usd) * 1.5)
        case "CAN":
            result = Int(Double(usd) * 1.25)
        default:
            return result
        }
        return result
    }
    
    // converts currency to same as added currency, adds then returns
    public func add(_ to: Money) -> Money {
        return Money(amount: convert(to.currency).amount + to.amount, currency: to.currency)
    }
    
    // converts currency to same as subtracted currency, subtracts then returns
    public func subtract(_ from: Money) -> Money {
        return Money(amount: convert(from.currency).amount - from.amount, currency: from.currency)
    }
}

//////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let rate):
        return Int(rate * Double(hours))
    case .Salary(let wage):
        return wage
    }
  }

  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let rate):
        type = JobType.Hourly(rate + amt)
    case .Salary(let wage):
        type = JobType.Salary(wage + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return self._job
        }
        set(value) {
            if(age >= 16) {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return self._spouse
        }
        set(value) {
            if(age >= 18) {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job)) spouse:\(String(describing: self._spouse))]"
    }
}
////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    for mem in members {
        if mem.age >= 21 {
            members.append(child)
            return true
        }
    }
    return false
  }

  open func householdIncome() -> Int {
    var total = 0
    for mem in members {
        if((mem.job) != nil) {
            total += (mem.job?.calculateIncome(2000))!
        }
    }
    return total
  }
}





