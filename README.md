# Koba

Security Headers for [Kitura](https://www.kitura.io) 

*Kob'a (ko'-bah) is the Hebrew word for helmet, a nod to [Helmet.js](https://helmetjs.github.io/).* 

Looking for security headers for Vapor? Check out [Vapor Security Headers](https://github.com/brokenhandsio/VaporSecurityHeaders).

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

### Feature-Policy
Disable browser features and APIs  
*Default Value:* `accelerometer 'none'; ambient-light-sensor 'none'; autoplay 'none'; camera 'none'; encrypted-media 'none'; fullscreen 'none'; geolocation 'none'; gyroscope 'none'; magnetometer 'none'; microphone 'none'; midi 'none'; payment 'none'; picture-in-picture 'none'; speaker 'none'; sync-xhr 'none'; usb 'none'; vr 'none'` *(not included by default)*

### Strict-Transport-Security (HSTS)
Ensure application communication is sent over HTTPS  
*Default Value:* `max-age=63072000` includeSubdomains

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
.package(url: "https://github.com/cak/koba", from: "0.0.1"),
```

**Add to target dependencies**

```swift
.target(name: "name", dependencies: ["Koba"]),
```

**Import package**

```swift
import Koba
```


*Default configuration*

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
Strict-Transport-Security: max-age=63072000; includeSubdomains
```

### Options
You can toggle the setting of headers with default values by passing an object with `Header().default()` or `nil` to remove the header. You can override default values by passing `Header().set("custom")` for a custom header value or using the policy builder for the following options:	

* **cacheControl** - set the Cache-control header
* **csp** - set the Content-Security-Policy
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
    cacheControl:CacheControl()
        .noStore()
        .mustRevalidate()
        .proxyRevalidate(),
    csp: CSP()
        .defaultSrc(Sources.none)
        .blockAllMixedContent()
        .connectSrc(Sources.sameOrigin, "api.serverswift.dev"),
    featurePolicy: FeaturePolicy()
        .geolocation(Sources.sameOrigin, "serverswift.dev")
        .vibrate(Sources.none),
    hsts: HSTS()
        .includeSubdomains()
        .preload()
        .maxAge(Seconds.oneWeek),
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
```

```HTTP
Content-Security-Policy: default-src 'none'; block-all-mixed-content; connect-src 'self' api.serverswift.dev
Cache-control: no-store, must-revalidate, proxy-revalidate
Strict-Transport-Security: includeSubDomains; preload; max-age=604800
Referrer-Policy: no-referrer
X-XSS-Protection: 1 mode=block
X-Frame-Options: DENY
Feature-Policy: geolocation 'self' serverswift.dev; vibrate 'none'
```

## Policy Builder

### Helpers

#### Sources

* data - data:
* none - 'none'
* sameOrigin - 'self'
* src - 'src'
* strictDynamic - 'strict-dynamic'
* unsafeEval - 'unsafe-eval'
* unsafeInline - 'unsafe-inline'
* wildcard - *

#### Seconds

* fiveMinutes - 300
* oneDay - 86400
* oneWeek - 604800
* oneMonth - 2592000
* oneYear - 31536000
* twoYears - 63072000

*Example*

```swift
let config = KobaConfig(
    csp: CSP().defaultSrc(Sources.sameOrigin),
    hsts: HSTS().maxAge(Seconds.oneDay)
)

let koba = Koba(config: config)
```

```HTTP
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=86400
```

### CacheControl()

* default() - *script-src 'self'; object-src 'self'*
* set(value) - *custom value*

**Directives:** private(), public(), immutable(), maxAge(seconds), maxStale(seconds), minFresh(seconds), mustRevalidate(), noCache(), noStore(), noTransform(), onlyIfCached(), proxyRevalidate(), sMaxage(seconds), staleIfError(seconds), staleWhileRevalidate(seconds)

### CSP()  

* default() - *script-src 'self'; object-src 'self'*
* set(value) - *custom value*

**Directives:** baseUri(sources), blockAllMixedContent(), connectSrc(sources), defaultSrc(sources), fontSrc(sources), formAction(sources), frameAncestors(sources), frameSrc(sources), imgSrc(sources), manifestSrc(sources), mediaSrc(sources), objectSrc(sources), pluginTypes(types), reportTo(ReportTo), reportUri(uri), requireSriFor(values), sandbox(values), scriptSrc(sources), styleSrc(sources), upgradeInsecureRequests(), workerSrc(sources)

You can check the effectiveness of your CSP Policy at the
[CSP Evaluator](https://csp-evaluator.withgoogle.com/)

### FeaturePolicy()  

* default() - *accelerometer 'none'; ambient-light-sensor 'none'; autoplay 'none'; camera 'none'; encrypted-media 'none'; fullscreen 'none'; geolocation 'none'; gyroscope 'none'; magnetometer 'none'; microphone 'none'; midi 'none'; payment 'none'; picture-in-picture 'none'; speaker 'none'; sync-xhr 'none'; usb 'none'; vr 'none';*
* set(value) - *custom value*

**Directives:** accelerometer(allowlist), ambientLightSensor(allowlist), autoplay(allowlist), camera(allowlist), documentDomain(allowlist), encryptedMedia(allowlist), fullscreen(allowlist), geolocation(allowlist), gyroscope(allowlist), magnetometer(allowlist), microphone(allowlist), midi(allowlist), payment(allowlist), pictureInPicture(allowlist), speaker(allowlist), syncXhr(allowlist), usb(allowlist), vibrate(allowlist), vr(allowlist)

### HSTS()  

* default() - *max-age=63072000; includeSubdomains*
* set(value) - *custom value*

**Directives:** includeSubdomains(), maxAge(seconds), preload()

### ReferrerPolicy()  

* default() - *no-referrer, strict-origin-when-cross-origin*
* set(value) - *custom value*

**Directives:**, noReferrer(), noReferrerWhenDowngrade(), origin(), originWhenCrossOrigin(), sameOrigin(), strictOrigin(), strictOriginWhenCrossOrigin(), unsafeUrl()

### XCTO()  

* default() - *nosniff*
* set(value) - *custom value*

### XFO()

* default() - *SAMEORIGIN*
* set(value) - *custom value*

**Directives:** allowFrom(), deny(), sameorigin()

### XXP()

* default() - *1; mode=block*
* set(value) - *custom value*

**Directives:** disabled(), enabled(), enabledBlock(), enabledReport(uri)

## Resources:

* [Kitura](https://www.kitura.io)
* [OWASP](https://www.owasp.org/index.php/Main_Page)
* [OWASP Secure Headers Project](https://www.owasp.org/index.php/OWASP_Secure_Headers_Project)
* [Mozilla Web Security](https://infosec.mozilla.org/guidelines/web_security)