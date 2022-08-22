var map = L.map('map').setView([0, 0], 0)

L.tileLayer('tiles/{fractal}/{z}/{x}/{y}', {
    attribution: 'Web Fractale by Hugoo',
    maxZoom: 18,
    fractal: fractal,
    tileSize: 512,
    zoomOffset: -1,
}).addTo(map);