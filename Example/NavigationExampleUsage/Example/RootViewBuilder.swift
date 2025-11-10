import Foundation
import SwiftUI
import DI
import ViewRouting

enum RootState: ViewState {
    case one
    case two(color: Color)
    
    var order: Int {
        switch self {
        case .one: 0
        case .two: 1
        }
    }
}

struct RootViewBuilder: ViewRouterBuilder {
    typealias State = RootState
    
    func animation(to: State, from: State) -> Animation? {
        if from == .two {
            .spring
        } else {
            .linear
        }
    }
    
    func transition(to: State, from: State) -> AnyTransition {
        if from.order < to.order {
            return .backslide
        } else {
            return .slide
        }
    }
    
    @ViewBuilder
    func build(state: State) -> some View {
        switch state {
        case .one:
            ViewOne()
        case .two(let color):
            ViewTwo(color: color):
        }
    }
    
    /// Example of self-registration to DI when you need it for the first time
    /// Also you can rewrite it with another `initial` state
    static func register() {
        let container = DI.sharedInstance
        container.register(ViewRouter<RootViewBuilder>.self, instanceType: .sharedInstance, factory: { _ in
            return ViewRouter(for: RootViewBuilder.self, initial: RootState.one)
        })
    }
}
