@MainActor
public final class PlayerManager {

    public static let shared = PlayerManager()

    private let pool: PlayerPool

    private let orchestrator: PlaybackOrchestrator

    private let environmentManager = EnvironmentManager()
    private let audioSession = AudioSessionManager()
    private let mediaSessionProvider = MediaSessionProvider()

    public private(set) var activeMediaId: String?

    public init() {

        let pool = PlayerPool()

        self.pool = pool

        self.orchestrator = PlaybackOrchestrator(
            pool: pool,
            streamingPipeline: DefaultStreamingPipeline()
        )
    }

    public func play(
        mediaId: String,
        source: MediaSource,
        title: String? = nil,
        artist: String? = nil
    ) async throws {

        mediaSessionProvider.configureNowPlaying(
            title: title,
            artist: artist
        )

        audioSession.request()

        try await orchestrator.play(
            mediaId: mediaId,
            source: source
        )

        activeMediaId = orchestrator.activeMediaId
    }

    public func pause() async {

        await orchestrator.pauseCurrent()

        audioSession.abandon()
    }

    public func preload(
        mediaId: String,
        source: MediaSource
    ) async {

        await orchestrator.preload(
            mediaId: mediaId,
            source: source
        )
    }

    public func observeState(
        mediaId: String
    ) async -> AsyncStream<PlayerState>? {

        await orchestrator.observeState(
            mediaId: mediaId
        )
    }

    public func shutdown() async {

        audioSession.cleanup()

        await orchestrator.shutdown()

        environmentManager.stop()

        activeMediaId = nil
    }
}
