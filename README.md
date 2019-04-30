# Koba

Koba is a [Kitura](https://www.kitura.io) middleware for setting HTTP security headers to help mitigate vulnerabilities and protect against attackers. It contains a strict default configuration and a policy builder for designing and overriding security header values. 

## Secure Headers

Security Headers are HTTP response headers that, when set, can enhance the security of your web application by enabling browser security policies.

You can assess the security of your HTTP response headers at  [securityheaders.com](https://securityheaders.com/) or at the [Mozilla Observatory](https://observatory.mozilla.org)

*Recommendations used by Koba and more information regarding security headers can be found at the [OWASP Secure Headers Project](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project) and [Mozilla Web Security](https://infosec.mozilla.org/guidelines/web_security)*

### Cache-control
Prevent cacheable HTTPS response  
*Default Value:* `no-cache, no-store, must-revalidate, max-age=0`

### Content-Security-Policy (CSP)
Prevent cross-site injections  
*Default Value:* `script-src 'self'; object-src 'self'` *(not included by default)*

### Expect-CT
Enforcement of Certificate Transparency
*Default Value:* `max-age=0` *(not included by default)*

### Feature-Policy
Disable browser features and APIs  
*Default Value:* `accelerometer 'none'; ambient-light-sensor 'none'; autoplay 'none'; camera 'none'; encrypted-media 'none'; fullscreen 'none'; geolocation 'none'; gyroscope 'none'; magnetometer 'none'; microphone 'none'; midi 'none'; payment 'none'; picture-in-picture 'none'; speaker 'none'; sync-xhr 'none'; usb 'none'; vr 'none'` *(not included by default)*

### Strict-Transport-Security (HSTS)
Ensure application communication is sent over HTTPS  
*Default Value:* `max-age=86400; includeSubDomains`

### Referrer-Policy
Enable full referrer if same origin, remove path for cross origin and disable referrer in unsupported browsers  
*Default Value:* `no-referrer, strict-origin-when-cross-origin`

### X-Content-Type-Options (XCTO)
Prevent MIME-sniffing  
*Default Value:* `nosniff`

### X-Frame-Options (XFO)
Disable framing from different origins (clickjacking defense)  
*Default Value:* `SAMEORIGIN`

### X-XSS-Protection (XXP)
Enable browser cross-site scripting filters  
*Default Value:* `1; mode=block`

#### Important information
* 	The **Strict-Transport-Security (HSTS)** header will tell the browser to *only* utilize secure HTTPS connections for the domain, and in the default configuration, including all subdomains. The HSTS header requires trusted certificates and users will unable to connect to the site if using self-signed or expired certificates. The browser will honor the HSTS header for the time directed in the max-age attribute *(default = 2 years)*, and setting the max-age to 0 will disable an already set HSTS header. Use `hsts: nil` in the KobaConfig to not include the HSTS header.
* 	The **Content-Security-Policy (CSP)** header can break functionality and can (and should) be carefully constructed, use the `csp: CSP().default()` in the KobaConfig to enable default values.

## Usage

## Add Koba to your Package.swift

**Add to dependencies**

```swift
.package(url: "https://github.com/cak/koba", from: "0.1.0"),
```

**Add to target dependencies**

```swift
.target(name: "name", dependencies: ["Koba"]),
```

**Import package**

```swift
import Koba
```


*Default configuration:*

```swift
import Kitura
import Koba

let koba = Koba()

let router = Router()
router.all(middleware: koba)
```

*Default HTTP response headers:*

```HTTP
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: no-referrer, strict-origin-when-cross-origin
X-Frame-Options: SAMEORIGIN
Cache-control: no-cache, no-store, must-revalidate, max-age=0
Strict-Transport-Security: max-age=86400; includeSubDomains
```

### Options
You can toggle the setting of headers with default values by passing an object with `Header().default()` or `nil` to remove the header. You can override default values by passing `Header().set("custom")` for a custom header value or using the policy builder for the following options:	

* **cacheControl** - set the Cache-control header
* **csp** - set the Content-Security-Policy
* **expectCT** - set the Expect-CT header
* **featurePolicy** - set the Feature-Policy header
* **hsts** - set the Strict-Transport-Security header
* **referrerPolicy** - set the Referrer-Policy header
* **xcto** - set the X-Content-Type-Options header
* 	**xfo** - set the X-Frame-Options header
* 	**xxp** - set the X-XSS-Protection header

*Example:*

```swift
import Kitura
import Koba

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
router.all(middleware: koba)
```

```HTTP
Referrer-Policy: no-referrer
Strict-Transport-Security: includeSubDomains; preload; max-age=604800
Cache-control: no-store, must-revalidate, proxy-revalidate
Expect-CT: max-age=300; enforce
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'none'; block-all-mixed-content; connect-src 'self' api.swiftserver.dev
Feature-Policy: geolocation 'self' swiftserver.dev; vibrate 'none'
X-Frame-Options: DENY
```

## Policy Builder

### Helpers

#### Koba.Source

* data - `data:`
* mediastream - `mediastream:`
* https - `https:`
* blob - `blob:`
* filesystem - `filesystem:`
* none - `'none'`
* sameOrigin - `'self'`
* src - `'src'`
* strictDynamic - `'strict-dynamic'`
* unsafeEval - `'unsafe-eval'`
* unsafeInline - `'unsafe-inline'`
* wildcard - `*`

#### Koba.Time

* fiveMinutes - `300`
* oneDay - `86400`
* oneWeek - `604800`
* oneMonth - `2592000`
* oneYear - `31536000`
* twoYears - `63072000`

*Example*

```swift
let config = KobaConfig(
    csp: CSP().defaultSrc(Koba.Source.sameOrigin),
    hsts: HSTS().maxAge(Koba.Time.oneDay)
)

let koba = Koba(config: config)
```

```HTTP
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=86400
```

### CacheControl()

* **default()** - *script-src 'self'; object-src 'self'*
* **custom(value)** - *custom value*

**Directives:** private(), public(), immutable(), maxAge(seconds), maxStale(seconds), minFresh(seconds), mustRevalidate(), noCache(), noStore(), noTransform(), onlyIfCached(), proxyRevalidate(), sMaxage(seconds), staleIfError(seconds), staleWhileRevalidate(seconds)

**Example:**

```swift
let policy = CacheControl()
    .noStore()
    .mustRevalidate()
    .proxyRevalidate()

// no-store, must-revalidate, proxy-revalidate
```

**Resources:**  [Cache-Control | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control) 

### CSP()  

* **default()** - *script-src 'self'; object-src 'self'*
* **custom(value)** - *custom value*
* **reportOnly()** - *change header to Content-Security-Policy-Report-Only*

**Directives:** baseUri(sources), blockAllMixedContent(), connectSrc(sources), defaultSrc(sources), fontSrc(sources), formAction(sources), frameAncestors(sources), frameSrc(sources), imgSrc(sources), manifestSrc(sources), mediaSrc(sources), objectSrc(sources), pluginTypes(types), reportTo(ReportTo), reportUri(uri), requireSriFor(values), sandbox(values), scriptSrc(sources), styleSrc(sources), upgradeInsecureRequests(), workerSrc(sources)

You can check the effectiveness of your CSP Policy at the
[CSP Evaluator](https://csp-evaluator.withgoogle.com/)

**Example:**

```swift
let policy = CSP()
    .defaultSrc(Koba.Source.none)
    .baseUri(Koba.Source.sameOrigin)
    .blockAllMixedContent()
    .connectSrc(Koba.Source.sameOrigin, "api.swiftserver.dev")
    .frameSrc(Koba.Source.none)
    .imgSrc(Koba.Source.sameOrigin, "static.swiftserver.dev");

// default-src 'none'; base-uri 'self'; block-all-mixed-content; connect-src 'self' api.swiftserver.dev; frame-src 'none'; img-src 'self' static.swiftserver.dev
```


#### Reporting

**Content-Security-Policy-Report-Only**

Using `reportOnly()` will change the header to `Content-Security-Policy-Report-Only`

**Example:**

```swift
let policy = CSP()
    .defaultSrc(Koba.Source.none)
    .baseUri(Koba.Source.sameOrigin)
    .reportOnly()
    
let config = KobaConfig(csp: policy)
let koba = Koba(config: config)
router.all(middleware: koba)
```

```HTTP
Cache-control: no-cache, no-store, must-revalidate, max-age=0
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Security-Policy-Report-Only: default-src 'none'; base-uri 'self'
Referrer-Policy: no-referrer, strict-origin-when-cross-origin
Strict-Transport-Security: max-age=63072000; includeSubdomains
X-Frame-Options: SAMEORIGIN
```

**report-to**

```swift
let reportToEndpoint = CSP.ReportToEndpoint(url: "https://swiftserver.dev/reports")

let reportTo = CSP.ReportTo(group: "CSP-Endpoint",
                            maxAge: Koba.Time.oneWeek,
                            endpoints: [reportToEndpoint],
                            includeSubdomains: true)

let policy = CSP()
    .defaultSrc(Koba.Source.none)
    .baseUri(Koba.Source.sameOrigin)
    .reportTo(reportTo)

// default-src 'none'; base-uri 'self'; report-to {"group":"CSP-Endpoint","endpoints":[{"url":"https:\/\/swiftserver.dev\/reports"}],"include_subdomains":true,"max_age":604800}
```

**report-uri**

```swift
let policy = CSP()
    .defaultSrc(Koba.Source.none)
    .baseUri(Koba.Source.sameOrigin)
    .reportUri("https://swiftserver.dev/reports")

// default-src 'none'; base-uri 'self'; report-uri https://swiftserver.dev/reports
```

 **Resources:**  [CSP Cheat Sheet | Scott Helme](https://scotthelme.co.uk/csp-cheat-sheet/) ,  [Content-Security-Policy | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) ,  [Content Security Policy Cheat Sheet | OWASP](https://www.owasp.org/index.php/Content_Security_Policy_Cheat_Sheet) ,  [Content Security Policy CSP Reference & Examples](https://content-security-policy.com/), **Reporting:** [The Reporting API | Google Developers](https://developers.google.com/web/updates/2018/09/reportingapi), [CSP: report-uri | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-uri), [report-to - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/report-to)


### ExpectCT()
* **default()** - *script-src 'self'; object-src 'self'*
* **custom(value)** - *custom value*

**Directives:** maxAge(seconds), enforce(), reportUri(uri)

**Example:**

```swift
let policy = ExpectCT()
    .maxAge(Koba.Time.oneDay)
    .enforce()
    .reportUri("https://swiftserver.dev")

// max-age=86400; enforce; report-uri="https://swiftserver.dev"
```

**Resources:**  [Expect-CT | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT)

### FeaturePolicy()  

* **default()** - *accelerometer 'none'; ambient-light-sensor 'none'; autoplay 'none'; camera 'none'; encrypted-media 'none'; fullscreen 'none'; geolocation 'none'; gyroscope 'none'; magnetometer 'none'; microphone 'none'; midi 'none'; payment 'none'; picture-in-picture 'none'; speaker 'none'; sync-xhr 'none'; usb 'none'; vr 'none';*
* **custom(value)** - *custom value*

**Directives:** accelerometer(allowlist), ambientLightSensor(allowlist), autoplay(allowlist), camera(allowlist), documentDomain(allowlist), encryptedMedia(allowlist), fullscreen(allowlist), geolocation(allowlist), gyroscope(allowlist), magnetometer(allowlist), microphone(allowlist), midi(allowlist), payment(allowlist), pictureInPicture(allowlist), speaker(allowlist), syncXhr(allowlist), usb(allowlist), vibrate(allowlist), vr(allowlist)

**Example:**

```swift
let policy = FeaturePolicy()
    .geolocation(Koba.Source.sameOrigin, "swiftserver.dev")
    .vibrate(Koba.Source.none)

// geolocation 'self' swiftserver.dev; vibrate 'none'
```

**Resources:**  [A new security header: Feature Policy | Scott Helme](https://scotthelme.co.uk/a-new-security-header-feature-policy/) ,  [Feature-Policy | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Feature-Policy) ,  [Introduction to Feature Policy | Google Developers](https://developers.google.com/web/updates/2018/06/feature-policy) 

### HSTS()  

* **default()** - *max-age=63072000; includeSubdomains*
* **custom(value)** - *custom value*

**Directives:** includeSubdomains(), maxAge(seconds), preload()

**Example:**

```swift
let policy = HSTS()
		.maxAge(Koba.Time.oneMonth)
    .includeSubdomains()
    .preload()

// max-age=2592000; includeSubDomains; preload
```

**Resources:**  [Strict-Transport-Security | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security) ,  [HTTP Strict Transport Security Cheat Sheet | OWASP](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet)

### ReferrerPolicy()  

* **default()** - *no-referrer, strict-origin-when-cross-origin*
* **custom(value)** - *custom value*

**Directives:**, noReferrer(), noReferrerWhenDowngrade(), origin(), originWhenCrossOrigin(), sameOrigin(), strictOrigin(), strictOriginWhenCrossOrigin(), unsafeUrl()

**Resources:**   [A new security header: Referrer Policy | Scott Helme](https://scotthelme.co.uk/a-new-security-header-referrer-policy/) ,  [Referrer-Policy | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy) 

### XCTO()  

* **default()** - *nosniff*
* **custom(value)** - *custom value*

**Examples:**

```swift
let policy = XCTO().default()

// nosniff
```

**Resources:**  [X-Content-Type-Options - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options)

### XFO()

* **default()** - *SAMEORIGIN*
* **custom(value)** - *custom value*

**Directives:** allowFrom(), deny(), sameorigin()

**Examples:**

```swift
let policy = XFO().deny()

// DENY
```

**Resources:**  [X-Frame-Options | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options) 

### XXP()

* **default()** - *1; mode=block*
* **custom(value)** - *custom value*

**Directives:** disabled(), enabled(), enabledBlock(), enabledReport(uri)

**Examples:**

```swift
let policy = XXP().enabledBlock()

// 1 mode=block
```

**Resources:**  [X-XSS-Protection | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection) 

## Contributing
	
Send a pull request, create an issue or discuss with me (@cak) on the the [Kitura Slack](http://slack.kitura.io/).

## Miscellaneous

*Kob'a (ko'-bah) is the Hebrew word for helmet, a nod to [Helmet.js](https://helmetjs.github.io/).* 

Looking for security headers for Vapor? Check out [Vapor Security Headers](https://github.com/brokenhandsio/VaporSecurityHeaders).

## Resources:

* [Kitura](https://www.kitura.io)
* [OWASP](https://www.owasp.org/index.php/Main_Page)
* [OWASP Secure Headers Project](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project)
* [Mozilla Web Security](https://infosec.mozilla.org/guidelines/web_security)