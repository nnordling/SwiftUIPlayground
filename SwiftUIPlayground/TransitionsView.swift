import SwiftUI

struct TransitionsView: View {
    @State var viewModel = TransitionsViewModel()
    @Namespace private var namespace

    var body: some View {
        NavigationStack {
            List(viewModel.movies) { movie in
                NavigationLink {
                    TransitionsDetailsView(movie: movie)
                    #if os(iOS)
                        .navigationTransition(.zoom(sourceID: movie.id, in: namespace))
                    #endif
                } label: {
                    VStack(alignment: .leading) {
                        Group {
                            Text(movie.title)
                            Text(movie.genre)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .matchedTransitionSource(id: movie.id, in: namespace)
                }
                .listRowSeparator(.hidden)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black.opacity(0.5))
                        .fill(.white)
                )
                .compositingGroup()
                .shadow(radius: 2, x: 2, y: 2)
            }
            .listStyle(.plain)
        }
    }
}

struct TransitionsDetailsView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            Image(.bird)
                .resizable()
                .ignoresSafeArea(.all, edges: .top)
                .frame(height: 300)
            Group {
                Text(movie.title)
                    .font(.title)
                Text(movie.genre)
                    .font(.subheadline)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@Observable final class TransitionsViewModel: Sendable {
    let movies = [
        Movie(title: "Old School", genre: "Comedy"),
        Movie(title: "Shawshank Redemption", genre: "Drama"),
        Movie(title: "Star Wars", genre: "Sci-Fi"),
        Movie(title: "It", genre: "Horror"),
    ]
}

struct Movie: Identifiable {
    let id: UUID
    let title: String
    let genre: String

    init(id: UUID = UUID(), title: String, genre: String) {
        self.id = id
        self.title = title
        self.genre = genre
    }
}
