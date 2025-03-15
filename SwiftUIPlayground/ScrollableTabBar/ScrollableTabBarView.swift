import SwiftUI

// Tutorial: https://youtu.be/sCK0W39nVEk?si=Bg61kiF6V_ZDQVUt

struct ScrollableTabBarView: View {
    @State private var tabs: [TabModel] = [
        .init(id: .research),
        .init(id: .development),
        .init(id: .analytics),
        .init(id: .audience),
        .init(id: .privacy)
    ]
    @State private var activeTab: TabModel.Tab = .research
    @State private var tabBarScrollState: TabModel.Tab?
    @State private var mainViewScrollState: TabModel.Tab?
    @State private var progress: CGFloat = .zero

    var body: some View {
        VStack(spacing: 0) {
            customTabBar()
            GeometryReader {
                let size = $0.size

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(tabs) { tab in
                            Text(tab.id.rawValue)
                                .frame(width: size.width, height: size.height)
                                .contentShape(.rect)
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / size.width
                    }
                }
                .scrollPosition(id: $mainViewScrollState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollState) { oldValue, newValue in
                    if let newValue {
                        withAnimation(.snappy) {
                            tabBarScrollState = newValue
                            activeTab = newValue
                        }
                    }
                }

            }
        }
    }

    @ViewBuilder
    func customTabBar() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach($tabs) { $tab in
                    Button {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    } label: {
                        Text(tab.id.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(activeTab == tab.id ? Color.primary : .gray)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .rect { rect in
                        tab.size = rect.size
                        tab.minX = rect.minX
                    }
                }
            }
            .scrollTargetLayout()
        }
        // Centers the tab bar when clicked
        .scrollPosition(id: .init(get: {
            return tabBarScrollState
        }, set: { _ in }), anchor: .center)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0))
                    .frame(height: 1)

                // number of tabs
                let inputRange = tabs.indices.compactMap { return CGFloat($0) }
                // width of each tab
                let outputRange = tabs.compactMap { return $0.size.width }
                // x position of each tab
                let outputPositionRange = tabs.compactMap { return $0.minX }
                // width of indicator
                let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
                // x position of indicator
                let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)

                Rectangle()
                    .fill(.primary)
                    .frame(width: indicatorWidth, height: 1.5)
                    .offset(x: indicatorPosition)
            }
        }
        .safeAreaPadding(.horizontal, 15)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ScrollableTabBarView()
}
