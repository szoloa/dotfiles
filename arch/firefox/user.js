// user.js (firefox)
// @author nate zhou
// @since 2023,2024,2025

user_pref("layout.css.devPixelsPerPx", "1.00");
// enable userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("font.name.serif.x-western", "JetBrains Mono"); // font
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org"); // theme
user_pref("browser.search.region", "US"); //region
user_pref("browser.region.update.region", "US");
user_pref("full-screen-api.ignore-widgets", true); // full screen restrict to firefox window
user_pref("browser.tabs.closeWindowWithLastTab", false); // last tab
user_pref("browser.newtab.extensionControlled", true); // new tab
user_pref("browser.newtab.privateAllowed", true);
user_pref("browser.download.dir", "/home/szoloa/Downloads/firefox"); // dls dir
user_pref("browser.download.folderList", 2);
user_pref("browser.download.lastDir", "/home/szoloa/Downloads/firefox");
user_pref("browser.urlbar.placeholderName", "Bing"); // urlbar search engine
user_pref("browser.urlbar.placeholderName.private", "Bing");
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.toolbars.bookmarks.showOtherBookmarks", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");
// Longer interval between session information record
user_pref("browser.sessionstore.interval", 600000);
// disable full screen warning
user_pref("full-screen-api.warning.timeout", 0);
// telemetry
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", false);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", false);
// ads
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showWeather", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
// autofill off
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
// privacy
user_pref("network.captive-portal-service.enabled", false);
user_pref("dom.security.https_only_mode_pbm", true);
user_pref("privacy.annotate_channels.strict_list.enabled", true);
user_pref("privacy.clearHistory.cache", false);
user_pref("privacy.clearHistory.cookiesAndStorage", false);
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.history.custom", true);
user_pref("privacy.purge_trackers.date_in_cookie_database", "0");
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
// extension
user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.addon@darkreader.org", true);
user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.idcac-pub@guus.ninja", true);
user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.screenshots@mozilla.org", true);
user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.tridactyl.vim@cmcaine.co.uk", true);
user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.uBlock0@raymondhill.net", true);
