import Foundation
import Kitura

public class Koba: RouterMiddleware {
    private let config: KobaConfig

    public init(config: KobaConfig = KobaConfig()) {
        self.config = config
    }

    public func handle(request _: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        if let cacheControl = config.cacheControl {
            response.headers.append("Cache-control", value: cacheControl.value)
        }
        if let csp = config.csp {
            response.headers.append("Content-Security-Policy", value: csp.value)
        }
        if let featurePolicy = config.featurePolicy {
            response.headers.append("Feature-Policy", value: featurePolicy.value)
        }
        if let hsts = config.hsts {
            response.headers.append("Strict-Transport-Security", value: hsts.value)
        }
        if let referrerPolicy = config.referrerPolicy {
            response.headers.append("Referrer-Policy", value: referrerPolicy.value)
        }
        if let xcto = config.xcto {
            response.headers.append("X-Content-Type-Options", value: xcto.value)
        }
        if let xfo = config.xfo {
            response.headers.append("X-Frame-Options", value: xfo.value)
        }
        if let xxp = config.xxp {
            response.headers.append("X-XSS-Protection", value: xxp.value)
        }

        next()
    }
}
