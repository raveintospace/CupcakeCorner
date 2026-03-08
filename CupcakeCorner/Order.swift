//
//  Order.swift
//  CupcakeCorner
//  ViewModel
//  Created by Uri on 7/3/26.
//

import Foundation

@Observable
class Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type: Int = 0
    var quantity: Int = 3

    var specialRequestEnabled: Bool = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting: Bool = false
    var addSprinkles: Bool = false

    var name: String = ""
    var streetAddress: String = ""
    var city: String = ""
    var zip: String = ""

    var hasInvalidAddress: Bool {
        [name, streetAddress, city, zip].contains {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    // Decimal is more accurate than Double
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // Complicated cakes cost more
        cost += Decimal(type) / 2

        // $1 per cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.5 per cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }

    // Required because using @Observable encodes the variables with an _ as prefix
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
}
