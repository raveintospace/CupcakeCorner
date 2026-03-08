//
//  CheckoutView.swift
//  CupcakeCorner
//  https://youtu.be/o_srROOXXgQ
//  Created by Uri on 8/3/26.
//

import SwiftUI

struct CheckoutView: View {

    var order: Order

    @State private var confirmationMessage: String = ""
    @State private var showingConfirmation: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)

                Text("Your total cost is \(order.cost, format: .currency(code: "EUR"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}

extension CheckoutView {

    private func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            debugPrint("Failed to encode order")
            return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("reqres_95c4ab1ce3a34043a80685b1534cb33c", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            // handle our result
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity) \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true

        } catch {
            confirmationMessage = "Check out failed: \(error.localizedDescription)"
            showingConfirmation = true
            debugPrint("Check out failed: \(error.localizedDescription)")
        }
    }
}

/*
 p String(decoding: encoded, as: UTF8.self)
 That converts our encoded data back to a string, and prints it out.
 */
