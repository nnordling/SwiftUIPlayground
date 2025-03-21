import SwiftUI

struct MailAppOpenerView: View {
    @State var errorText = ""

    var body: some View {
        #if os(iOS)
        VStack(spacing: 16) {
            Text(errorText)
            Button("Mail") {
                if let mailURL = URL(string: "message://"), UIApplication.shared.canOpenURL(mailURL) {
                    UIApplication.shared.open(mailURL)
                } else {
                    errorText = "Mail app not installed"
                }
            }
            .buttonStyle(.bordered)

            Button("Gmail") {
                if let mailURL = URL(string: "googlegmail://"), UIApplication.shared.canOpenURL(mailURL) {
                    UIApplication.shared.open(mailURL)
                } else {
                    errorText = "Gmail app not installed"
                }
            }
            .buttonStyle(.bordered)

            Button("Outlook") {
                if let mailURL = URL(string: "ms-outlook://"), UIApplication.shared.canOpenURL(mailURL) {
                    UIApplication.shared.open(mailURL)
                } else {
                    errorText = "Outlook app not installed"
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        #else
        Text("Only supported on iOS")
        #endif
    }
}

#Preview {
    MailAppOpenerView()
}


