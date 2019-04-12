import Foundation

public class CacheControl {
    private var directives: [String] = []

    var value: String {
        return directives.joined(separator: ", ")
    }

    public func set(_ value: String) -> CacheControl {
        directives.append(value)
        return self
    }

    public func `default`() -> CacheControl {
        directives.append("no-cache, no-store, must-revalidate, max-age=0")
        return self
    }

    public func immutable() -> CacheControl {
        directives.append("immutable")
        return self
    }

    public func maxAge(_ seconds: String) -> CacheControl {
        directives.append("max-age=\(seconds)")
        return self
    }

    public func maxStale(_ seconds: String) -> CacheControl {
        directives.append("max-stale=\(seconds)")
        return self
    }

    public func minFresh(_ seconds: String) -> CacheControl {
        directives.append("min-fresh=\(seconds)")
        return self
    }

    public func mustRevalidate() -> CacheControl {
        directives.append("must-revalidate")
        return self
    }

    public func noCache() -> CacheControl {
        directives.append("no-cache")
        return self
    }

    public func noStore() -> CacheControl {
        directives.append("no-store")
        return self
    }

    public func noTransform() -> CacheControl {
        directives.append("no-transform")
        return self
    }

    public func onlyIfCached() -> CacheControl {
        directives.append("only-if-cached")
        return self
    }

    public func `private`() -> CacheControl {
        directives.append("private")
        return self
    }

    public func proxyRevalidate() -> CacheControl {
        directives.append("proxy-revalidate")
        return self
    }

    public func `public`() -> CacheControl {
        directives.append("public")
        return self
    }

    public func sMaxage(_ seconds: String) -> CacheControl {
        directives.append("s-maxage=\(seconds)")
        return self
    }

    public func staleIfError(_ seconds: String) -> CacheControl {
        directives.append("stale-if-error=\(seconds)")
        return self
    }

    public func staleWhileRevalidate(_ seconds: String) -> CacheControl {
        directives.append("stale-while-revalidate=\(seconds)")
        return self
    }

    public init() {}
}

public class CSP {
    private var directives: [String] = []

    var value: String {
        return directives.joined(separator: "; ")
    }

    public func set(_ value: String) -> CSP {
        directives.append(value)
        return self
    }

    public func `default`() -> CSP {
        directives.append("script-src 'self'; object-src 'self'")
        return self
    }

    public func baseUri(_ sources: String...) -> CSP {
        directives.append("base-uri \(sources.joined(separator: " "))")
        return self
    }

    public func blockAllMixedContent() -> CSP {
        directives.append("block-all-mixed-content")
        return self
    }

    public func connectSrc(_ sources: String...) -> CSP {
        directives.append("connect-src \(sources.joined(separator: " "))")
        return self
    }

    public func defaultSrc(_ sources: String...) -> CSP {
        directives.append("default-src \(sources.joined(separator: " "))")
        return self
    }

    public func fontSrc(_ sources: String...) -> CSP {
        directives.append("font-src \(sources.joined(separator: " "))")
        return self
    }

    public func formAction(_ sources: String...) -> CSP {
        directives.append("form-action \(sources.joined(separator: " "))")
        return self
    }

    public func frameAncestors(_ sources: String...) -> CSP {
        directives.append("frame-ancestors \(sources.joined(separator: " "))")
        return self
    }

    public func frameSrc(_ sources: String...) -> CSP {
        directives.append("frame-src \(sources.joined(separator: " "))")
        return self
    }

    public func imgSrc(_ sources: String...) -> CSP {
        directives.append("img-src \(sources.joined(separator: " "))")
        return self
    }

    public func manifestSrc(_ sources: String...) -> CSP {
        directives.append("manifest-src \(sources.joined(separator: " "))")
        return self
    }

    public func mediaSrc(_ sources: String...) -> CSP {
        directives.append("media-src \(sources.joined(separator: " "))")
        return self
    }

    public func objectSrc(_ sources: String...) -> CSP {
        directives.append("object-src \(sources.joined(separator: " "))")
        return self
    }

    public func pluginTypes(types: String...) -> CSP {
        directives.append("plugin-types \(types.joined(separator: " "))")
        return self
    }

    public func requireSriFor(_ values: String...) -> CSP {
        directives.append("require-sri-for \(values.joined(separator: " "))")
        return self
    }

    public func reportTo(_ reportTo: ReportTo) -> CSP {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(reportTo) else { return self }
        guard let jsonString = String(data: data, encoding: .utf8) else { return self }
        directives.append("report-to \(String(describing: jsonString))")
        return self
    }

    public func reportUri(_ uri: String) -> CSP {
        directives.append("report-uri \(uri)")
        return self
    }

    public func sandbox(_ values: String...) -> CSP {
        directives.append("sandbox \(values.joined(separator: " "))")
        return self
    }

    public func scriptSrc(_ sources: String...) -> CSP {
        directives.append("script-src \(sources.joined(separator: " "))")
        return self
    }

    public func styleSrc(_ sources: String...) -> CSP {
        directives.append("style-src \(sources.joined(separator: " "))")
        return self
    }

    public func upgradeInsecureRequests() -> CSP {
        directives.append("upgrade-insecure-requests")
        return self
    }

    public func workerSrc(_ sources: String...) -> CSP {
        directives.append("worker-src \(sources.joined(separator: " "))")
        return self
    }

    public init() {}
}

public class FeaturePolicy {
    private var directives: [String] = []

    var value: String {
        return directives.joined(separator: "; ")
    }

    public func set(_ value: String) -> FeaturePolicy {
        directives.append(value)
        return self
    }

    public func `default`() -> FeaturePolicy {
        directives.append("accelerometer 'none'; ambient-light-sensor 'none'; autoplay 'none'; "
            + "camera 'none'; encrypted-media 'none'; fullscreen 'none'; geolocation 'none'; "
            + "gyroscope 'none'; magnetometer 'none'; microphone 'none'; midi 'none'; "
            + "payment 'none'; picture-in-picture 'none'; speaker 'none'; sync-xhr 'none'; "
            + "usb 'none'; vr 'none';")
        return self
    }

    public func accelerometer(_ allowlist: String...) -> FeaturePolicy {
        directives.append("accelerometer \(allowlist.joined(separator: " "))")
        return self
    }

    public func ambientLightSensor(_ allowlist: String...) -> FeaturePolicy {
        directives.append("ambient-light-sensor \(allowlist.joined(separator: " "))")
        return self
    }

    public func autoplay(_ allowlist: String...) -> FeaturePolicy {
        directives.append("autoplay \(allowlist.joined(separator: " "))")
        return self
    }

    public func camera(_ allowlist: String...) -> FeaturePolicy {
        directives.append("camera \(allowlist.joined(separator: " "))")
        return self
    }

    public func documentDomain(_ allowlist: String...) -> FeaturePolicy {
        directives.append("document-domain \(allowlist.joined(separator: " "))")
        return self
    }

    public func encryptedMedia(_ allowlist: String...) -> FeaturePolicy {
        directives.append("encrypted-media \(allowlist.joined(separator: " "))")
        return self
    }

    public func fullscreen(_ allowlist: String...) -> FeaturePolicy {
        directives.append("fullscreen \(allowlist.joined(separator: " "))")
        return self
    }

    public func geolocation(_ allowlist: String...) -> FeaturePolicy {
        directives.append("geolocation \(allowlist.joined(separator: " "))")
        return self
    }

    public func gyroscope(_ allowlist: String...) -> FeaturePolicy {
        directives.append("gyroscope \(allowlist.joined(separator: " "))")
        return self
    }

    public func magnetometer(_ allowlist: String...) -> FeaturePolicy {
        directives.append("magnetometer \(allowlist.joined(separator: " "))")
        return self
    }

    public func microphone(_ allowlist: String...) -> FeaturePolicy {
        directives.append("microphone \(allowlist.joined(separator: " "))")
        return self
    }

    public func midi(_ allowlist: String...) -> FeaturePolicy {
        directives.append("midi \(allowlist.joined(separator: " "))")
        return self
    }

    public func payment(_ allowlist: String...) -> FeaturePolicy {
        directives.append("payment \(allowlist.joined(separator: " "))")
        return self
    }

    public func pictureInPicture(_ allowlist: String...) -> FeaturePolicy {
        directives.append("picture-in-picture \(allowlist.joined(separator: " "))")
        return self
    }

    public func speaker(_ allowlist: String...) -> FeaturePolicy {
        directives.append("speaker \(allowlist.joined(separator: " "))")
        return self
    }

    public func syncXhr(_ allowlist: String...) -> FeaturePolicy {
        directives.append("sync-xhr \(allowlist.joined(separator: " "))")
        return self
    }

    public func usb(_ allowlist: String...) -> FeaturePolicy {
        directives.append("usb \(allowlist.joined(separator: " "))")
        return self
    }

    public func vibrate(_ allowlist: String...) -> FeaturePolicy {
        directives.append("vibrate \(allowlist.joined(separator: " "))")
        return self
    }

    public func vr(_ allowlist: String...) -> FeaturePolicy {
        directives.append("vr \(allowlist.joined(separator: " "))")
        return self
    }

    public init() {}
}

public class HSTS {
    private var directives: [String] = []

    var value: String {
        return directives.joined(separator: "; ")
    }

    public func set(_ value: String) -> HSTS {
        directives.append(value)
        return self
    }

    public func `default`() -> HSTS {
        directives.append("max-age=63072000; includeSubdomains")
        return self
    }

    public func includeSubdomains() -> HSTS {
        directives.append("includeSubDomains")
        return self
    }

    public func maxAge(_ seconds: String) -> HSTS {
        directives.append("max-age=\(seconds)")
        return self
    }

    public func preload() -> HSTS {
        directives.append("preload")
        return self
    }

    public init() {}
}

public class ReferrerPolicy {
    private var directives: [String] = []

    var value: String {
        return directives.joined(separator: ", ")
    }

    public func set(_ value: String) -> ReferrerPolicy {
        directives.append(value)
        return self
    }

    public func `default`() -> ReferrerPolicy {
        directives.append("no-referrer, strict-origin-when-cross-origin")
        return self
    }

    public func noReferrer() -> ReferrerPolicy {
        directives.append("no-referrer")
        return self
    }

    public func noReferrerWhenDowngrade() -> ReferrerPolicy {
        directives.append("no-referrer-when-downgrade")
        return self
    }

    public func origin() -> ReferrerPolicy {
        directives.append("origin")
        return self
    }

    public func originWhenCrossOrigin() -> ReferrerPolicy {
        directives.append("origin-when-cross-origin")
        return self
    }

    public func sameOrigin() -> ReferrerPolicy {
        directives.append("same-origin")
        return self
    }

    public func strictOrigin() -> ReferrerPolicy {
        directives.append("strict-origin")
        return self
    }

    public func strictOriginWhenCrossOrigin() -> ReferrerPolicy {
        directives.append("strict-origin-when-cross-origin")
        return self
    }

    public func unsafeUrl() -> ReferrerPolicy {
        directives.append("unsafe-url")
        return self
    }

    public init() {}
}

public class XCTO {
    private var directive: String = ""

    var value: String {
        return directive
    }

    public func set(_ value: String) -> XCTO {
        directive = value
        return self
    }

    public func `default`() -> XCTO {
        directive = "nosniff"
        return self
    }

        public init() {}

}

public class XFO {
    private var directive: String = ""

    var value: String {
        return directive
    }

    public func set(_ value: String) -> XFO {
        directive = value
        return self
    }

    public func `default`() -> XFO {
        directive = "SAMEORIGIN"
        return self
    }

    public func allowFrom(_ uri: String) -> XFO {
        directive = "ALLOW-FROM \(uri)"
        return self
    }

    public func deny() -> XFO {
        directive = "DENY"
        return self
    }

    public func sameorigin() -> XFO {
        directive = "SAMEORIGIN"
        return self
    }

    public init() {}
}

public class XXP {
    private var directive: String = ""

    var value: String {
        return directive
    }

    public func set(_ value: String) -> XXP {
        directive = value
        return self
    }

    public func `default`() -> XXP {
        directive = "1; mode=block"
        return self
    }

    public func disabled() -> XXP {
        directive = "0"
        return self
    }

    public func enabled() -> XXP {
        directive = "1"
        return self
    }

    public func enabledBlock() -> XXP {
        directive = "1 mode=block"
        return self
    }

    public func enabledReport(_ uri: String) -> XXP {
        directive = "1 report=\(uri)"
        return self
    }

    public init() {}
}
