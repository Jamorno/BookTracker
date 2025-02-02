//
//  HeaderView.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 31/1/2568 BE.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var statusSelection: BookStatusModel
    @Namespace var aniamtion
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                HStack {
                    ForEach(BookStatusModel.allCases, id: \.self) {status in
                        ZStack {
                            if statusSelection == status {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .frame(height: 45)
                                    .foregroundStyle(Color("color6"))
                                    .matchedGeometryEffect(id: "item", in: aniamtion)
                                    .shadow(radius: 2, x: 1, y: 3)
                            } else {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .foregroundStyle(.clear)
                            }
                            
                            Text(status.rawValue)
                                .font(.headline)
                                .foregroundStyle(statusSelection == status ? Color("color1") : Color("color6"))
                        }
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)) {
                                statusSelection = status
                            }
                        }
                    }
                }
                .padding(.top, 50)
                .frame(maxWidth: .infinity)
                .background(Color("color2"))
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .ignoresSafeArea()
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    HeaderView(statusSelection: .constant(.unread))
}
