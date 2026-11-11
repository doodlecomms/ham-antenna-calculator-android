/*
 * Android bridge for the offline app build (not part of the upstream web app).
 * The in-app WebView has no print dialog, ignores <a download> links and may
 * not expose navigator.clipboard, so route those three features to native code.
 */
(function () {
  var A = window.AndroidBridge;
  if (!A) return;

  // Print -> Android's print screen (includes Save as PDF).
  window.print = function () { A.print(); };

  // Clipboard -> Android clipboard.
  var clip = {
    writeText: function (text) {
      try { A.copyText(String(text)); return Promise.resolve(); }
      catch (e) { return Promise.reject(e); }
    }
  };
  try {
    Object.defineProperty(navigator, 'clipboard', { value: clip, configurable: true });
  } catch (e) { /* leave as is */ }

  // <a download href="blob:..."> -> "Save as" dialog.
  var origClick = HTMLAnchorElement.prototype.click;
  HTMLAnchorElement.prototype.click = function () {
    var href = this.href || '';
    if (this.hasAttribute('download') && (href.indexOf('blob:') === 0 || href.indexOf('data:') === 0)) {
      var name = this.getAttribute('download') || 'export.csv';
      fetch(href).then(function (r) { return r.text(); }).then(function (text) {
        A.saveFile(name, text);
      });
      return;
    }
    return origClick.apply(this, arguments);
  };
})();
