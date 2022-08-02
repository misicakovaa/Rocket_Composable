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
    var detailState: DetailState? = nil
    var fetchingState = FetchingState.na
    var rockets = [Rocket]()
    var alert: AlertState<AppAction>?
    
    enum FetchingState: Equatable {
        case na
        case loading
        case success([Rocket])
        case error(String)
    }
}

//MARK: - Action

enum AppAction: Equatable {
    case retry
    case getRockets
    case rocketsResponse(Result<[Rocket], RocketsManager.Failure>)
    case detailAction(DetailAction)
    case showDetail(Rocket?)
    case dismissDetail
}

//MARK: - View

struct RocketsListView: View {
    
    var store: Store<AppState, AppAction>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
    }
    
    var body: some View {
        
        WithViewStore(self.store) { viewStore in
            NavigationView {
                switch viewStore.fetchingState {
                    
                case .loading:
                    ProgressView()
                    
                case .success(let rockets):
                    ZStack {
                        Color.ui.lightGrayList
                        
                        List(rockets) { rocket in
                            
                            //MARK: -  Rocket info row containing:
                            // image, rocket name, first flight
                            
                            NavigationLink(destination: IfLetStore(self.store.scope(state: \.detailState, action: AppAction.detailAction), then: RocketDetailView.init(store:)),
                                           isActive: Binding(
                                            get: { viewStore.state.detailState == nil ? false : true },
                                            set: { active in
                                                if active {
                                                    viewStore.send(.showDetail(rocket))
                                                } else {
                                                    viewStore.send(.dismissDetail)
                                                }
                                            }
                                           )) {
                                               RocketRow(rocketName: rocket.rocketName, firstFlight: rocket.firstFlight)
                                           }
                        }
                        .navigationTitle("Rockets")
                    }
                    
                case .na:
                    EmptyView()
                    
                case .error(_):
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
        RocketsListView(store: Store(initialState: AppState(),
                                     reducer: appReducer,
                                     environment: AppEnvironment(mainQueue: .main,
                                                                 rocketsManager: .live,
                                                                 motionManager: .live)
                                    )
        )
    }
}
