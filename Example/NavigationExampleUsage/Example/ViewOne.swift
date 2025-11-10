import SwiftUI
import DI
import ViewRouting

/// In case if you want transit between modules you can just add a case
/// to RootViewCases and make a transition
struct ViewOne: View {
    @Injected var router: ViewRouter<RootViewBuilder>
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    router.route(to: .four(color: .yellow))
                } label: {
                    Text("Go to second")
                }
                Spacer()
            }
            .frame(height: 80)
        }
    }
}

#Preview {
    ViewOne()
}
