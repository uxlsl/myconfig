// ==UserScript==
// @name         禁止知乎首页的推荐
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @require      https://cdn.staticfile.org/jquery/1.12.4/jquery.min.js
// @match        https://www.zhihu.com/
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // Your code here...
    $('.App-main').css('display','none');
})();