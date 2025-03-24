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
                    .padding()
                Spacer()
                Text(Strings.onboardingWelcomeTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(ConstantColors.primary)
                Text(Strings.onboardingWelcomeBody)
                    .font(.body)
                    .fontWeight(.regular)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                Spacer()
                NavigationLink {
                    HomeView()
                        .navigationBarBackButtonHidden(true) // Hide navigation back button
                } label: {
                    Text("Lanjutkan")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(ConstantColors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
//            .sheet(isPresented: $presentSheet) {
//                PayDebtView(modelContext: sharedModelContainer.mainContext)
//            }
        }
    }
}

#Preview {
    OnboardingView()
}
