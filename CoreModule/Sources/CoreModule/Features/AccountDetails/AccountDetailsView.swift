import Foundation
import SwiftUI
import ComposableArchitecture

struct AccountDetailsView: View {
    let store: StoreOf<AccountDetailsFeature>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .padding(10)
                    }
                    Spacer()
                }
                Text("Details")
                    .typography(.sfProTextSemibold17)
                    .padding(.top, 14)
                    .padding(.bottom, 13)
            }
            .foregroundStyle(Color.c000000)

            Circle()
                .frame(width: 80, height: 80)
                .foregroundStyle(Color.cD2D2D2)
                .overlay {
                    Image("LOGO", bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(12)
                }

            VStack(spacing: 4) {
                Text(store.account.accountName)
                    .typography(.urbanistMedium24)
                    .foregroundStyle(Color.c171717)
                Text(store.account.description)
                    .typography(.sfProRegular16)
                    .foregroundStyle(Color.c171717_60)
            }

            Text(store.account.amount.currencyFormatted())
                .typography(.sfProDisplayRegular40)
                .foregroundStyle(Color.c171717)
            
            Spacer()
        }
    }
}
