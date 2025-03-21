import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Scrollable Tab Bar", destination: ScrollableTabBarView())
                NavigationLink("Mail App Opener", destination: MailAppOpenerView())
            }
        }
    }
}

#Preview {
    ContentView()
}
