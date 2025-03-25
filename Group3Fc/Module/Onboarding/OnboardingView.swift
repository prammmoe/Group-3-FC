//
//  OnboardingView.swift
//  Group3Fc
//
//  Created by Pramuditha Muhammad Ikhwan on 22/03/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var presentSheet: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Image("LogoOnboarding")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(Strings.onboardingWelcomeTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(ConstantColors.primary)
                HStack {
                    Text(Strings.onboardingWelcomeBody)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                }
                .frame(width: 300)
                
                Spacer()
//                NavigationLink {
//                    HomeView()
//                        .navigationBarBackButtonHidden(true) // Hide navigation back button
//                } label: {
//                    Text("Lanjutkan")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.white)
//                        .padding(.vertical, 20)
//                        .frame(maxWidth: .infinity)
//                        .background(ConstantColors.primary)
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
//                }
//                .padding()
            }
        }
    }
}

#Preview {
    OnboardingView()
}
