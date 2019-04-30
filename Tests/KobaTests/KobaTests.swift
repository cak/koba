import XCTest
import Kitura

@testable import Koba

final class KobaTests: XCTestCase {

    override func tearDown() {
        doTearDown()
    }

    func testKobaDefault() {
        let koba = Koba()
        let router = Router()
        router.all(middleware: koba)

        performServerTest(router) { expectation in
            self.performRequest("get", path: "/", callback: {response in

                guard let XCTOHeader = response!.headers["X-Content-Type-Options"]?.first else {
                    return
                }

                XCTAssertEqual(XCTOHeader, "nosniff")

                guard let XXPHeader = response!.headers["X-XSS-Protection"]?.first else {
                    return
                }

                XCTAssertEqual(XXPHeader, "1; mode=block")

                guard let referrerHeader = response!.headers["Referrer-Policy"]?.first else {
                    return
                }

                XCTAssertEqual(referrerHeader, "no-referrer, strict-origin-when-cross-origin")

                guard let XFOHeader = response!.headers["X-Frame-Options"]?.first else {
                    return
                }

                XCTAssertEqual(XFOHeader, "SAMEORIGIN")

                guard let cacheHeader = response!.headers["Cache-control"]?.first else {
                    return
                }

                XCTAssertEqual(cacheHeader, "no-cache, no-store, must-revalidate, max-age=0")

                guard let HSTSHeader = response!.headers["Strict-Transport-Security"]?.first else {
                    return
                }
                XCTAssertEqual(HSTSHeader, "max-age=86400; includeSubDomains")

                expectation.fulfill()
            })
        }
    }

    func testKobaCustom() {
        let config = KobaConfig(
            cacheControl: CacheControl()
                .noStore()
                .mustRevalidate()
                .proxyRevalidate(),
            csp: CSP()
                .defaultSrc(Koba.Source.none)
                .blockAllMixedContent()
                .connectSrc(Koba.Source.sameOrigin, "api.swiftserver.dev"),
            expectCT: ExpectCT()
                .maxAge(Koba.Time.fiveMinutes)
                .enforce(),
            featurePolicy: FeaturePolicy()
                .geolocation(Koba.Source.sameOrigin, "swiftserver.dev")
                .vibrate(Koba.Source.none),
            hsts: HSTS()
                .includeSubdomains()
                .preload()
                .maxAge(Koba.Time.oneWeek),
            referrerPolicy: ReferrerPolicy()
                .noReferrer(),
            xcto: nil,
            xfo: XFO()
                .deny(),
            xxp: XXP()
                .enabledBlock()
        )

        let koba = Koba(config: config)

        let router = Router()
        router.all(middleware: koba)

        performServerTest(router) { expectation in
            self.performRequest("get", path: "/", callback: {response in

                guard let CSPHeader = response!.headers["Content-Security-Policy"]?.first else {
                    return
                }

                XCTAssertEqual(CSPHeader, "default-src 'none'; block-all-mixed-content; connect-src 'self' api.swiftserver.dev")

                guard let featureHeader = response!.headers["Feature-Policy"]?.first else {
                    return
                }

                XCTAssertEqual(featureHeader, "geolocation 'self' swiftserver.dev; vibrate 'none'")

                XCTAssertNil(response!.headers["X-Content-Type-Options"]?.first)

                guard let XXPHeader = response!.headers["X-XSS-Protection"]?.first else {
                    return
                }

                XCTAssertEqual(XXPHeader, "1; mode=block")

                guard let referrerHeader = response!.headers["Referrer-Policy"]?.first else {
                    return
                }

                XCTAssertEqual(referrerHeader, "no-referrer")

                guard let XFOHeader = response!.headers["X-Frame-Options"]?.first else {
                    return
                }

                XCTAssertEqual(XFOHeader, "DENY")

                guard let cacheHeader = response!.headers["Cache-control"]?.first else {
                    return
                }

                XCTAssertEqual(cacheHeader, "no-store, must-revalidate, proxy-revalidate")

                guard let HSTSHeader = response!.headers["Strict-Transport-Security"]?.first else {
                    return
                }
                XCTAssertEqual(HSTSHeader, "includeSubDomains; preload; max-age=604800")

                expectation.fulfill()
            })
        }
    }

    static var allTests = [
        ("testKobaDefault", testKobaDefault),
        ("testKobaCustom", testKobaCustom)
    ]
}
