import Foundation
import ComposableArchitecture
import SwiftUI

struct AccountListView: View {
    let store: StoreOf<AccountListFeature>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Accounts")
                .typography(.urbanistSemibold20)
                .foregroundStyle(Color.c000000)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 8, trailing: 20))
            ScrollView {
                LazyVStack {
                    ForEach(store.filteredAccounts ?? store.accounts) { account in
                        Button(action: {
                            store.send(.onAccount(account))
                        }) {
                            AccountListItem(account: account)
                        }
                    }
                }
            }
        }
    }
}

private struct AccountListItem: View {
    let account: Account

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundStyle(Color.cD2D2D2)
                Image("LOGO", bundle: .module)
                    .padding(7)
            }
            .padding(.leading, 16)
            .padding(.vertical, 8)
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(account.accountName)
                        .typography(.sfProMedium16)
                        .foregroundStyle(Color.c171717)
                    Text(account.description)
                        .typography(.sfProRegular13)
                        .foregroundStyle(Color.c171717_60)
                }
                Spacer()
                Text(account.amount.currencyFormatted())
                    .typography(.sfProMedium16)
                    .foregroundStyle(Color.c171717)
            }
            .padding(.vertical, 12)
            .padding(.trailing, 16)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.c171717_12),
                alignment: .bottom
            )
            .padding(.leading, 16)
        }
    }
}
