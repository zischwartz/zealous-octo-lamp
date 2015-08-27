# map = L.map('map').setView([51.505, -0.09], 13)`

# # L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
# #     attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
# #     maxZoom: 18,
# #     id: 'your.mapbox.project.id',
# #     accessToken: 'your.mapbox.public.access.token'
# # }).addTo(map);

# map.addLayer new L.StamenTileLayer "toner", 
#                         detectRetina: true
 

start = [40.6294862,-74.022639]

layer = new L.StamenTileLayer "toner-lite", 
	attribution: """Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://www.openstreetmap.org/copyright">ODbL</a>."""
map = new L.Map "map", 
  center: new L.LatLng(start[0], start[1])
  zoom: 12
map.addLayer(layer)



greenIcon = L.icon
  iconUrl: 'leaf-orange.png'
  shadowUrl: 'leaf-shadow.png'
  iconSize:     [38, 95], # size of the icon
  shadowSize:   [50, 64], # size of the shadow
  iconAnchor:   [22, 94], # point of the icon which will correspond to marker's location
  # iconAnchor:   [22, 94], # point of the icon which will correspond to marker's location
  shadowAnchor: [4, 62],  # the same for the shadow
  popupAnchor:  [-3, -76] # point from which the popup should open relative to the iconAnchor

L.marker(start, {icon: greenIcon}).addTo(map);

# todo, generalize size, have it adjust on zoom
# also ask for location

GeneralIcon = L.Icon.extend
	options: 
	    shadowUrl: 'skull_shadow.png',
	    iconSize:     [80, 106],
	    shadowSize:   [143, 112],
	    iconAnchor:   [0, 0], # point of the icon which will correspond to marker's location
	    # iconAnchor:   [22, 94], # point of the icon which will correspond to marker's location
	    # shadowAnchor: [4, 62],  # the same for the shadow
	    shadowAnchor: [-30, 5],  # the same for the shadow
	    popupAnchor:  [-3, -76]

skullIcon = new GeneralIcon({iconUrl: 'skull_small.png'})
    # redIcon = new GeneralIcon({iconUrl: 'leaf-red.png'}),
    # orangeIcon = new GeneralIcon({iconUrl: 'leaf-orange.png'})

reqListener =()->
	data = JSON.parse this.responseText
	# console.log data
	for x, i in data
		# console.log i
		L.marker([x.lat, x.long], {icon: skullIcon}).addTo(map);
		# console.log x,i


url = "motor_related_deaths.json"

oReq = new XMLHttpRequest()
oReq.addEventListener('load', reqListener)
oReq.open("get", url, true)
oReq.send()

# var myMarker = new L.CircleMarker([10,10], { /* Options */ });

# map.on('zoomend', function() {
#   var currentZoom = map.getZoom();
#   myMarker.setRadius(currentZoom);
# });






