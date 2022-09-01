//
//  RocketDetailView.swift
//  Rocket
//
//  Created by Adela Mišicáková on 11.07.2022.
//

import SwiftUI
import ComposableArchitecture
import ComposableCoreMotion

//MARK: - State

struct DetailState: Equatable, Identifiable {
    var id: UUID
    var rocket: Rocket
    var launchState = LaunchState()
}

//MARK: - Action

enum DetailAction: Equatable {
    case launchAction(LaunchAction)
}

//MARK: - View

struct RocketDetailView: View {
    
    var store: Store<DetailState, DetailAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                
                let rocket = viewStore.rocket
                
                //MARK: - Overview section
                
                TitledSection(title: "Overview") {
                    Text(rocket.description)
                        .padding([.leading, .trailing])
                }
                
                //MARK: - Parameters section
                
                TitledSection(title: "Parameters") {
                    parametersSectionView
                        .padding(.bottom)
                }
                
                //MARK: - First Stage section
                
                StageView(
                    stage: "First",
                    reusable: rocket.firstStage.reusable,
                    engines: rocket.firstStage.engines,
                    fuelTons: Int(rocket.firstStage.fuel),
                    burnTime: rocket.firstStage.burnTime ?? 0)
                .padding([.leading, .trailing, .bottom])
                
                //MARK: - Second Stage section
                
                StageView(
                    stage: "Second",
                    reusable: rocket.secondStage.reusable,
                    engines: rocket.secondStage.engines,
                    fuelTons: Int(rocket.firstStage.fuel),
                    burnTime: rocket.secondStage.burnTime ?? 0)
                .padding([.leading, .trailing, .bottom])
                
                //MARK: - Photos section
                
                TitledSection(title: "Photos") {
                    PhotosSectionView(images: rocket.flickrImages)
                }
            }
            .navigationTitle(viewStore.rocket.rocketName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Title <- Rocket name
                ToolbarItem(placement: .principal) {
                    Text(viewStore.rocket.rocketName)
                        .font(.headline)
                }
                
                // Launch button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: RocketLaunchView(
                            store: store.scope(state: \.launchState, action: DetailAction.launchAction)
                        )
                    ) {
                        Text("Launch")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
    
    var parametersSectionView: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                ParameterView(
                    name: "height", number: Int(viewStore.rocket.height.meters), unit: "m")
                .padding(.leading)
                
                Spacer()
                
                ParameterView(
                    name: "diameter", number: Int(viewStore.rocket.diameter.meters), unit: "m")
                
                Spacer()
                
                ParameterView(
                    name: "mass", number: viewStore.rocket.mass.kg/1000, unit: "t")
                .padding(.trailing)
            }
        }
    }
}

struct RocketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RocketDetailView(
            store: Store(
                initialState: DetailState(id: .init(), rocket: exampleRocket1),
                reducer: detailReducer,
                environment: DetailEnvironment(motionManager: .live)
            )
        )
    }
}

