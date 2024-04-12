export function onRequest(context) {
    const data = [
      {
        "relation": ["delegate_permission/common.handle_all_urls"],
        "target": {
          "namespace": "android_app",
          "package_name": "com.pigsare.pink.calculator.calculator",
          "sha256_cert_fingerprints":
            ["B1:98:B9:4C:AE:12:06:6D:29:39:48:1B:AF:F1:C1:57:48:81:CB:FD:31:3B:EB:FC:35:2B:5D:E0:65:C9:E9:A5"]
        }
      }
    ];
    return new Response.json(data);
}