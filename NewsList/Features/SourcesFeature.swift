import Foundation
import ComposableArchitecture

struct SourcesFeature: ReducerProtocol {
      
    struct State: Equatable {
        
        var sources: [Source]
        var alertSourcesMoreThan20: Bool
    }
    
    enum Action {
        case load
        case on(Int)
        case off(Int)
        case set([Source])
        case closeAlert
    }
    
    @Dependency(\.sources) var sourcesNetworkClient
    
    func reduce(into state: inout State,
                action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            return .run{ send in
                do {
                    let sources = try await self.sourcesNetworkClient.load()
                    await send(.set(sources))
                }
            }
        case .on(let index):
            state.sources[index] = Source(state.sources[index], include: true)
            if state.sources.filter({ $0.include }).count > 20 {
                state.sources[index] = Source(state.sources[index], include: false)
                state.alertSourcesMoreThan20 = true
            }
        case .off(let index):
            state.sources[index] = Source(state.sources[index], include: false)
        case .set(let sources):
            state.sources = sources
        case .closeAlert:
            state.alertSourcesMoreThan20 = false
        }
        return .none
    }
}
