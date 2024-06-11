const esmf = require("./cpuminer-nodeapi");
const path = require("path");
//console.info("esm", esm, esm.onRuntimeInitialized);
(async () => {
  let esm = await esmf();
  console.info("e", esm.onRuntimeInitialized);
  var cipher = esm.cwrap("cipher", "string", ["string", "string"]);
  console.info("test squqre", cipher("light", "abc"));
  esm.onRuntimeInitialized = () => {};
})();
