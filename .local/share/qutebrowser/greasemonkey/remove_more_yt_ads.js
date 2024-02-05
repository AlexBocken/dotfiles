// ==UserScript==
// @name         Auto Remove Ads
// @version      1.0.0
// @description  Autoremove static ads
// @author       Alexander Bocken
// @match        *://*.youtube.com/*
// @exclude      *://*.youtube.com/subscribe_embed?*
// ==/UserScript==
setInterval(() => {
    document.querySelectorAll('.ytd-page-top-ad-layout-renderer,.ytd-video-display-full-buttoned-renderer, ytd-display-ad-renderer,.ytd-banner-promo-renderer-background,.ytd-player-legacy-desktop-watch-ads-renderer').forEach(
	el => {
			el.remove();
	})
}, 50)
