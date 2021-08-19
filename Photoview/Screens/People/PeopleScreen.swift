//
//  PeopleScreen.swift
//  Photoview
//
//  Created by Viktor Strate Kløvedal on 24/07/2021.
//

import SwiftUI

struct PeopleScreen: View {
  
  @State var faceGroups: [MyFacesThumbnailsQuery.Data.MyFaceGroup]? = nil
  
  func fetchFaces() {
    Network.shared.apollo?.fetch(query: MyFacesThumbnailsQuery()) { result in
      switch result {
      case let .success(data):
        DispatchQueue.main.async {
          faceGroups = data.data?.myFaceGroups ?? []
        }
      case let .failure(error):
        fatalError("Failed to fetch faces: \(error)")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      if let faceGroups = faceGroups {
        ScrollView {
          FaceGrid(faceGroups: faceGroups)
            .padding(.top)
        }
        .navigationTitle("People")
      } else {
        ProgressView("Loading people")
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      if (faceGroups == nil) {
        fetchFaces()
      }
    }
  }
}

struct PeopleScreen_Previews: PreviewProvider {
  static var previews: some View {
    PeopleScreen()
  }
}
