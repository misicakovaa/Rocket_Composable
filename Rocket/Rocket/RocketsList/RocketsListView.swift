//
//  RocketsListView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 11.07.2022.
//

import SwiftUI
import ComposableArchitecture
import ComposablePresentation

//MARK: - State

struct AppState: Equatable {
    var presentDetail = false
    var detailState: DetailState? = nil
    var fetchingState = FetchingState.na
    var alert: AlertState<AppAction>?
    
    enum FetchingState: Equatable {
        case na
        case loading
        case success(IdentifiedArrayOf<DetailState>)
        case error(String)
    }
}

//MARK: - Action

enum AppAction: Equatable {
    case detailAction(DetailAction)
    case showDetail(DetailState)
    case dismissDetail
    case retry
    case getRockets
    case rocketsResponse(Result<[Rocket], RocketsManager.Failure>)
    case detail(id: UUID, action: DetailAction)
}

//MARK: - View

struct RocketsListView: View {
    
    var store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                switch viewStore.fetchingState {
                case .loading:
                    ProgressView()
                    
                case .success(let detailStates):
                    ZStack {
                        Color.ui.lightGrayList
                        
                        //MARK: -  Rocket info row containing:
                        // image, rocket name, first flight
                        
                        List(detailStates) { detailState in
                            NavigationLink(
                                destination: IfLetStore(
                                    self.store.scope(
                                        state: \.detailState,
                                        action: AppAction.detailAction)
                                ) {
                                    RocketDetailView(store: $0)
                                },
                                isActive: Binding(
                                    get: { viewStore.presentDetail },
                                    set: { viewStore.send($0 ? .showDetail(detailState) : .dismissDetail) }
                                )
                            ) {
                                RocketRow(rocketName: detailState.rocket.rocketName,
                                          firstFlight: detailState.rocket.firstFlight)
                            }
                        }
                        .navigationTitle("Rockets")
                    }
                    
                case .na, .error:
                    EmptyView()
                }
            }
            .task {
                viewStore.send(.getRockets)
            }
            .alert(self.store.scope(state: \.alert), dismiss: .retry)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct RocketsListView_Previews: PreviewProvider {
    static var previews: some View {
        RocketsListView(store: Store(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .main,
                rocketsManager: .live,
                motionManager: .live,
                uuid: UUID.init)
        )
        )
    }
}
