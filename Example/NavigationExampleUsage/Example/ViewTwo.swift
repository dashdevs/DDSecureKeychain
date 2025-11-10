import SwiftUI
import DI
import ViewRouting

struct ViewTwo: View {
    @Injected var router: ViewRouter<RootViewBuilder>
    @State var color: Color = .black
    
    var body: some View {
        VStack {
            Text("View Two")
                .foregroundStyle(color)
            HStack {
                Spacer()
                Button {
                    router.route(to: .one)
                } label: {
                    Text("Go to first")
                }
                Spacer()
            }
        }
        // There must be modified custom nav bar with back button
        // that has to change state of router to previous one
        // and follow by the `viewOrder` of the screens
    }
}

#Preview {
    ViewTwo(color: .purple)
}
