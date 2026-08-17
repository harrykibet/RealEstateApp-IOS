import Foundation

/// High-level manager that coordinates multiple PlayerEngine instances (a player pool), environment, audio session, and streaming pipeline.
public final class PlayerManager {
    public static let shared = PlayerManager()

    private let pool = PlayerPool()
    private let environmentManager = EnvironmentManager()
    private let audioSession = AudioSessionManager()
    private let bitrateController = DynamicBitrateController()
    private let streamingPipeline: StreamingPipeline = DefaultStreamingPipeline()
    private let mediaSessionProvider = MediaSessionProvider()

    public private(set) var activeMediaId: String? = nil
    private var composedMediaIds = Set<String>()

    public init() {}

    public func start() {
        environmentManager.start(onAppBackgrounded: { [weak self] in
            Task { await self?.handleAppBackgrounded() }
        }, onAppForegrounded: { [weak self] in
            Task { await self?.handleAppForegrounded() }
        })
    }

    private func handleAppBackgrounded() async {
        // Pause active player
        if let active = activeMediaId, let managed = await pool.get(mediaId: active) {
            managed.engine.pause()
        }
    }

    private func handleAppForegrounded() async {
        // No-op: do not auto-resume by default
    }

    public func play(mediaId: String, source: MediaSource, title: String? = nil, artist: String? = nil) async throws {
        let managed = try await pool.getOrCreate(mediaId: mediaId, source: source, loadSource: true)
        mediaSessionProvider.configureNowPlaying(title: title, artist: artist)
        audioSession.request()
        managed.engine.play()
        activeMediaId = mediaId
        // warm streaming pipeline
        await streamingPipeline.warm(mediaId: mediaId, source: source, priority: .visible)
    }

    public func preload(mediaId: String, source: MediaSource) async {
        _ = await pool.prewarm(mediaId: mediaId, source: source)
    }

    public func pause() async {
        if let active = activeMediaId, let managed = await pool.get(mediaId: active) {
            managed.engine.pause()
            audioSession.abandon()
        }
    }

    public func getEngine(mediaId: String) async -> PlayerEngine? {
        await pool.get(mediaId: mediaId)?.engine
    }

    public func observeState(mediaId: String) async -> AsyncStream<PlayerState>? {
        guard let managed = await pool.get(mediaId: mediaId) else { return nil }
        return managed.engine.state
    }

    public func shutdown() async {
        audioSession.cleanup()
        await pool.releaseAll()
        environmentManager.stop()
    }

    public func notifyMediaBound(mediaId: String) async {
        composedMediaIds.insert(mediaId)
        await pool.updatePinnedIds(composedMediaIds)
    }

    public func notifyMediaUnbound(mediaId: String) async {
        composedMediaIds.remove(mediaId)
        await pool.updatePinnedIds(composedMediaIds)
    }
}
