public struct KobaConfig {
    public var cacheControl: CacheControl?
    public var csp: CSP?
    public var expectCT: ExpectCT?
    public var featurePolicy: FeaturePolicy?
    public var hsts: HSTS?
    public var referrerPolicy: ReferrerPolicy?
    public var xcto: XCTO?
    public var xfo: XFO?
    public var xxp: XXP?

    public init(
        cacheControl: CacheControl? = CacheControl().default(),
        csp: CSP? = nil,
        expectCT: ExpectCT? = nil,
        featurePolicy: FeaturePolicy? = nil,
        hsts: HSTS? = HSTS().default(),
        referrerPolicy: ReferrerPolicy? = ReferrerPolicy().default(),
        xcto: XCTO? = XCTO().default(),
        xfo: XFO? = XFO().default(),
        xxp: XXP? = XXP().default()
    ) {
        self.cacheControl = cacheControl
        self.csp = csp
        self.expectCT = expectCT
        self.featurePolicy = featurePolicy
        self.hsts = hsts
        self.referrerPolicy = referrerPolicy
        self.xcto = xcto
        self.xfo = xfo
        self.xxp = xxp
    }
}

extension Koba {
    public struct Source {
        public static let data = "data:"
        public static let mediastream = "mediastream:"
        public static let https = "https:"
        public static let blob = "blob:"
        public static let filesystem = "filesystem:"
        public static let none = "'none'"
        public static let sameOrigin = "'self'"
        public static let src = "'src'"
        public static let strictDynamic = "'strict-dynamic'"
        public static let unsafeEval = "'unsafe-eval'"
        public static let unsafeInline = "'unsafe-inline'"
        public static let script = "'script"
        public static let wildcard = "*"
    }

    public struct Time {
        public static let fiveMinutes = 60 * 5
        public static let oneDay = 60 * 60 * 24
        public static let oneWeek = 60 * 60 * 24 * 7
        public static let oneMonth = 60 * 60 * 24 * 30
        public static let oneYear = 60 * 60 * 24 * 365
        public static let twoYears = 60 * 60 * 24 * 365 * 2
    }
}

extension CSP {
    public struct ReportTo: Codable {
        private let group: String?
        private let maxAge: Int
        private let endpoints: [ReportToEndpoint]
        private let includeSubdomains: Bool?

        public init(group: String? = nil, maxAge: Int,
                    endpoints: [ReportToEndpoint], includeSubdomains: Bool? = nil) {
            self.group = group
            self.maxAge = maxAge
            self.endpoints = endpoints
            self.includeSubdomains = includeSubdomains
        }
    }

    public struct ReportToEndpoint: Codable {
        private let url: String

        public init(url: String) {
            self.url = url
        }
    }
}

extension CSP.ReportToEndpoint: Equatable {
    public static func == (lhs: CSP.ReportToEndpoint, rhs: CSP.ReportToEndpoint) -> Bool {
        return lhs.url == rhs.url
    }
}

extension CSP.ReportTo: Equatable {
    public static func == (lhs: CSP.ReportTo, rhs: CSP.ReportTo) -> Bool {
        return lhs.group == rhs.group &&
            lhs.maxAge == rhs.maxAge &&
            lhs.endpoints == rhs.endpoints &&
            lhs.includeSubdomains == rhs.includeSubdomains
    }
}
