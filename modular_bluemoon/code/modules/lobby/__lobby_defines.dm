// Пути
#define BM_LOBBY_HTML_FILE "config/bluemoon/lobby_html.txt"

#define BM_LOBBY_IMAGES_SFW "config/title_screens/"

#define BM_LOBBY_IMAGES_NSFW "config/title_screens/NSFW/"

#define BM_LOBBY_DEFAULT_IMAGE 'icons/runtime/default_title.dmi'

#define BM_LOBBY_LOADING_GIF "config/title_screens/cyberpunk_cityscape.gif"

#define BM_DEFAULT_LOBBY_HTML_PREAMBLE {"<!DOCTYPE html>
<html lang='ru'>
<head>
<meta charset='UTF-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0'>
<title>BlueMoon Station</title>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{width:100%;height:100%;overflow:hidden;background:#000;font-family:'Courier New',monospace;user-select:none;cursor:default}
.bg{position:absolute;width:auto;height:100vmin;min-width:100vmin;min-height:100vmin;top:50%;left:50%;transform:translate(-50%,-50%);z-index:0}
#bm-overlay{position:fixed;top:0;left:0;width:100%;height:100%;background:linear-gradient(135deg,rgba(0,0,0,0.5) 0%,rgba(0,5,20,0.28) 50%,rgba(0,0,0,0.6) 100%);z-index:2;pointer-events:none}
#bm-sidebar{position:fixed;top:0;right:0;height:100%;width:clamp(200px,28vmin,340px);z-index:15;display:flex;flex-direction:column;justify-content:center;background:rgba(5,10,40,0.88);border-left:1px solid rgba(100,160,255,0.25)}
.bm-btn{display:block;width:100%;background:none;border:none;text-decoration:none;color:#cce;font-family:'Courier New',monospace;font-size:clamp(10px,1.8vmin,18px);padding:1vmin 1vmin 1vmin 2.5vmin;cursor:pointer;white-space:nowrap;text-overflow:ellipsis;overflow:hidden}
.bm-btn:hover{color:#ffe}.bm-btn .bm-checked{color:#4f4}.bm-btn .bm-unchecked{color:#f44}
@keyframes bm-ms-rainbow{0%{filter:hue-rotate(0deg);color:#8cf}100%{filter:hue-rotate(360deg);color:#fc8}}
@keyframes bm-ms-pulse{0%,100%{opacity:1;letter-spacing:3px}50%{opacity:.75;letter-spacing:6px}}
@keyframes bm-ms-shimmer{0%{text-shadow:0 0 4px #4af}50%{text-shadow:0 0 14px #fff,0 0 20px #4af}100%{text-shadow:0 0 4px #4af}}
@keyframes bm-ms-blink{0%,49%{opacity:1}50%,100%{opacity:.35}}
@keyframes bm-ms-wave{0%,100%{transform:translateX(0)}50%{transform:translateX(3px)}}
@keyframes bm-ms-glow{0%,100%{color:#9cf}33%{color:#f9c}66%{color:#9fc}}
.bm-metashop{font-weight:bold}
.bm-ms-1{animation:bm-ms-rainbow 5s linear infinite}
.bm-ms-2{animation:bm-ms-pulse 2.5s ease-in-out infinite}
.bm-ms-3{animation:bm-ms-shimmer 2.8s ease-in-out infinite}
.bm-ms-4{animation:bm-ms-blink 1.1s step-end infinite}
.bm-ms-5{animation:bm-ms-wave 2s ease-in-out infinite}
.bm-ms-6{animation:bm-ms-glow 3.5s ease-in-out infinite}
.bm-ms-7{background:linear-gradient(90deg,#8af,#faf,#8af);background-size:200% 100%;-webkit-background-clip:text;background-clip:text;color:transparent!important;animation:bm-ms-rainbow 4s linear infinite}
.bm-ms-8{text-shadow:0 0 6px #0ff,0 0 12px #f0f;animation:bm-ms-shimmer 1.8s ease-in-out infinite}
</style>
</head><body>
"}


