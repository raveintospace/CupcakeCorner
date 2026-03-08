//
//  CodableObservable.swift
//  CupcakeCorner
//  https://youtu.be/bS1KfZeUvsM
//  Created by Uri on 7/3/26.
//

import SwiftUI

@Observable
class User: Codable {

    var name = "Taylor"

    enum CodingKeys: String, CodingKey {
        case _name = "name"
    }
}

struct CodableObservable: View {
    var body: some View {
        Button("Encode Taylor") {
            encodeTaylor()
        }
    }

    func encodeTaylor() {
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        debugPrint(str)
    }
}

#Preview {
    CodableObservable()
}

// when encoding an @Observable class, it is saved by default as _name, instead of name, therefore we are using enum CodingKeys
