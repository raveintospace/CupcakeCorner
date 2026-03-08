//
//  FormValidation.swift
//  CupcakeCorner
//  https://youtu.be/5_zu0NxQZjE
//  Created by Uri on 7/3/26.
//

import SwiftUI

struct FormValidation: View {

    @State private var userName: String = ""
    @State private var email: String = ""

    var disableForm: Bool {
        userName.count < 5 || email.count < 5
    }

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $userName)
                TextField("Email", text: $email)
            }

            Section {
                Button("Create account") {
                    debugPrint("Creating account")
                }
            }
            //.disabled(userName.isEmpty || email.isEmpty)
            .disabled(disableForm)
        }
    }
}

#Preview {
    FormValidation()
}
