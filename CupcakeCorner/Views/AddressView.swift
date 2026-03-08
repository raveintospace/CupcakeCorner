//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Uri on 7/3/26.
//

import SwiftUI

struct AddressView: View {

    @Bindable var order: Order

    enum Field {
        case name, streetAddress, city, zip
    }

    @FocusState private var focusedField: Field?

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .focused($focusedField, equals: .name)
                    .onSubmit { focusedField = .streetAddress }
                    .submitLabel(.next)
                TextField("Street Address", text: $order.streetAddress)
                    .focused($focusedField, equals: .city)
                    .onSubmit { focusedField = .city }
                    .submitLabel(.next)
                TextField("City", text: $order.city)
                    .focused($focusedField, equals: .zip)
                    .onSubmit { focusedField = .zip }
                    .submitLabel(.next)
                TextField("Zip", text: $order.zip)
                    .focused($focusedField, equals: .zip)
                    .submitLabel(.done)
            }
            .autocorrectionDisabled()

            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasInvalidAddress)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            focusedField = .name
        }
    }
}

#Preview {
    AddressView(order: Order())
}

/*
 @Bindable allows us to receive and edit an object class.
 If it was only a property, we would use @Binding
 If it was read-only, we would use "var"
 With @Bindable, the values of the class properties are stored and kept even when navigating back & forward
 */
