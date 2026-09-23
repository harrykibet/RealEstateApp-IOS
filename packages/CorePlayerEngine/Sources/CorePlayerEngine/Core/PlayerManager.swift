@MainActor
public final class PlayerManager {
    
    public static let shared = PlayerManager()
    
    private let pool: PlayerPool
    
    private let orchestrator: PlaybackOrchestrator
    
    private let networkMonitor: NetworkConnectivityProviding
    
    private let networkRecovery: NetworkRecoveryCoordinator
    
    private let environmentManager = EnvironmentManager()
    private let audioSession = AudioSessionManager()
    private let mediaSessionProvider = MediaSessionProvider()
    
    public private(set) var activeMediaId: String?
    
    public init() {
        
        let pool = PlayerPool()
        
        let cacheDirectory =
            FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask
            )[0]
            .appendingPathComponent(
                "Estatia/PlayerMediaCache/v1",
                isDirectory: true
            )

        let cacheStore =
            FileMediaCacheStore(
                rootDirectory:
                    cacheDirectory
            )

        let cacheWarmer =
            MediaCacheWarmer(
                store:
                    cacheStore
            )

        let streamingPipeline =
            DefaultStreamingPipeline(
                cacheWarmer:
                    cacheWarmer
            )
        
        let orchestrator =
            PlaybackOrchestrator(
                pool: pool,
                streamingPipeline: streamingPipeline
            )
        
        let networkMonitor = NetworkConnectivityMonitor()
        
        self.pool = pool
        self.orchestrator = orchestrator
        self.networkMonitor = networkMonitor
        self.networkRecovery = NetworkRecoveryCoordinator(
            network: networkMonitor,
            playback: orchestrator
        )
    }
    
    public func start() {
        
        networkRecovery.start()
        
        environmentManager.start(
            onAppBackgrounded: { [weak self] in
                Task {
                    await self?.pause()
                }
            },
            onAppForegrounded: { [weak self] in
                // Recovery coordinator handles transport recovery.
                // Do not automatically resume user-paused media.
                _ = self
            }
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
        
        networkRecovery.stop()
        
        audioSession.cleanup()
        
        await orchestrator.shutdown()
        
        environmentManager.stop()
        
        activeMediaId = nil
    }
}
