'From Cuis6.3 [latest update: #6253] on 9 March 2024 at 2:51:01 pm'!
'Description '!
!provides: 'RoadTrip' 1 9!
!requires: 'JSON' 1 26 nil!
SystemOrganization addCategory: #RoadTrip!


!classDefinition: #City category: #RoadTrip!
PlacedMorph subclass: #City
	instanceVariableNames: 'color population vehicleVisitCount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'City class' category: #RoadTrip!
City class
	instanceVariableNames: ''!

!classDefinition: #Vehicle category: #RoadTrip!
PlacedMorph subclass: #Vehicle
	instanceVariableNames: 'color destination'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'Vehicle class' category: #RoadTrip!
Vehicle class
	instanceVariableNames: ''!

!classDefinition: #ZoomPanMorph category: #RoadTrip!
PlacedMorph subclass: #ZoomPanMorph
	instanceVariableNames: 'origin width height panStartPixel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'ZoomPanMorph class' category: #RoadTrip!
ZoomPanMorph class
	instanceVariableNames: ''!

!classDefinition: #RoadTrip category: #RoadTrip!
ZoomPanMorph subclass: #RoadTrip
	instanceVariableNames: 'color vehicle usBorder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'RoadTrip class' category: #RoadTrip!
RoadTrip class
	instanceVariableNames: ''!

!classDefinition: #CityData category: #RoadTrip!
Object subclass: #CityData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'CityData class' category: #RoadTrip!
CityData class
	instanceVariableNames: ''!

!classDefinition: #USBorder category: #RoadTrip!
Object subclass: #USBorder
	instanceVariableNames: 'edges'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'RoadTrip'!
!classDefinition: 'USBorder class' category: #RoadTrip!
USBorder class
	instanceVariableNames: ''!


!ZoomPanMorph commentStamp: '<historical>' prior: 0!
A morph that shows a subset of itself with a zoomable and pannable rectangular viewport. Useful for things like geographical maps.

origin is the center of the viewport in the morph's local coordinates.

width and height are the viewport dimensions.

panStartPixel is set on mousedown. We require a threshold of mouse movement from this position for panning to begin. Each time that threshold is crossed before mouseup a pan occurs and this variable is set to a new position.

Doesn't clip submorphs.

Implementation note: if you do want to clip submorphs then you could write an alternate version of this using composition instead of inheritance. See PluggableScrollPane for inspiration (pointed out by Juan Vuletich).!

!City methodsFor: 'initialization' stamp: 'IGJ 2/27/2024 22:34:33'!
addLabel
	| layout |
	layout := LayoutMorph newColumn
		:: color: Color transparent
		:: morphPosition: -150@25
		:: morphExtent: 300@100.
	layout addMorph: (LabelMorph contents: self name).
	self addMorph: layout! !

!City methodsFor: 'initialization' stamp: 'IGJ 2/22/2024 22:18:25'!
defaultColor
	^ `Color white`! !

!City methodsFor: 'initialization' stamp: 'IGJ 2/29/2024 11:53:43'!
initialize
	super initialize.
	color := self defaultColor.
	vehicleVisitCount := 0	
! !

!City methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 15:59:41'!
morphExtent
	^ `30 @ 30`! !

!City methodsFor: 'accessing' stamp: 'IGJ 2/29/2024 11:15:05'!
name: newName
	super name: newName.
	self addLabel! !

!City methodsFor: 'accessing' stamp: 'IGJ 2/27/2024 22:45:07'!
population: pop
	population  := pop! !

!City methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 22:42:03'!
setColor: newColor
	color := newColor! !

!City methodsFor: 'geometry' stamp: 'IGJ 2/22/2024 16:17:24'!
morphLocalBounds
	^Rectangle center: 0@0 extent: self morphExtent! !

!City methodsFor: 'drawing' stamp: 'IGJ 2/29/2024 11:55:18'!
drawOn: canvas
	| radius |
	(self owner morphLocalBounds containsPoint: self morphPosition )
		ifTrue: [
			radius := self morphExtent // 2.
			canvas ellipseCenter: 0 @ 0
				radius: radius x @ radius y
				borderWidth: 3
				borderColor: Color black
				fillColor: ((vehicleVisitCount = 0) ifTrue: [color] ifFalse: [Color green]).
			self submorphsDo: [:each | each visible: true]]
		ifFalse: [self submorphsDo: [ :each | each visible: false]]
	
! !

!City methodsFor: 'game' stamp: 'IGJ 2/29/2024 11:51:58'!
visited: vehicle
	vehicleVisitCount := vehicleVisitCount + 1! !

!Vehicle methodsFor: 'initialization' stamp: 'IGJ 2/22/2024 19:11:11'!
defaultColor
	^ `Color black`! !

!Vehicle methodsFor: 'initialization' stamp: 'IGJ 2/23/2024 11:50:36'!
initialize
	super initialize.
	color := self defaultColor! !

!Vehicle methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 20:22:50'!
destination
	^ destination ! !

!Vehicle methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 19:27:17'!
destination: city
	destination := city
! !

!Vehicle methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 19:15:09'!
morphExtent
	^ `30 @ 20`! !

!Vehicle methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 22:44:51'!
setColor: newColor
	color := newColor! !

!Vehicle methodsFor: 'geometry' stamp: 'IGJ 2/22/2024 19:12:57'!
morphLocalBounds
	^Rectangle center: 0@0 extent: self morphExtent! !

!Vehicle methodsFor: 'drawing' stamp: 'IGJ 2/23/2024 10:33:34'!
drawHeadlights: aCanvas
	aCanvas strokeWidth: 1 color: Color black fillColor: Color yellow do: [
	aCanvas
		moveTo: 10 @ 0;
		lineTo: 35 @ -12;
		lineTo: 35 @ 12;
		lineTo: 10 @ 0 ]! !

!Vehicle methodsFor: 'drawing' stamp: 'IGJ 2/23/2024 10:23:29'!
drawOn: aCanvas
	self drawHeadlights: aCanvas.
	self drawVehicle: aCanvas
! !

!Vehicle methodsFor: 'drawing' stamp: 'IGJ 2/23/2024 10:07:54'!
drawVehicle: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/23/2024 11:16:34'!
destinationAngle
	| diffX diffY |
	diffX := destination morphPosition x - self morphPosition x.
	diffY := destination morphPosition y - self morphPosition y.
	^ diffY arcTan: diffX.! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/23/2024 10:53:59'!
destinationDistance
	| diffX diffY |
	diffX := self morphPosition x - destination morphPosition x.
	diffY := self morphPosition y - destination morphPosition y.
	^ (diffX squared + diffY squared) sqrt! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/23/2024 10:54:45'!
faceTowardsDestination
	self rotation: self destinationAngle! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/29/2024 11:49:23'!
moveTowardsDestination
	| angleRad |
	angleRad := self destinationAngle.
	(self destinationDistance < self speed)
		ifTrue: [self morphPosition: destination morphPosition. destination visited: self]
		ifFalse: [self morphPosition:
			(self morphPosition x + (angleRad cos * self speed))
			@
			(self morphPosition y + (angleRad sin * self speed))
			]! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/27/2024 20:21:02'!
newDestination
	destination := owner submorphs atRandom! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/29/2024 11:55:44'!
speed
	^ 60 * 0.001! !

!Vehicle methodsFor: 'update' stamp: 'IGJ 2/27/2024 20:21:16'!
update: millisecondSinceLast
	(self morphPosition = destination morphPosition)
		ifTrue: [self newDestination]
		"faceTowardsDestionation goes here so that if the user accesses
	 	the destionation city's halo and starts moving it,
		we'll stay pointed the correct way as we drive."
		ifFalse: [self faceTowardsDestination :: moveTowardsDestination]
! !

!ZoomPanMorph methodsFor: 'zoom' stamp: 'IGJ 2/29/2024 09:21:25'!
handlesMouseScroll: aMouseScrollEvent 
	^ true! !

!ZoomPanMorph methodsFor: 'zoom' stamp: 'IGJ 2/29/2024 12:33:05'!
mouseScroll: aMouseEvent localPosition: mouseLocalPosition
	aMouseEvent direction
		caseOf: {
			[ #up ] -> [ self zoom: 1.2 mouse: mouseLocalPosition.  self redrawNeeded ].
			[ #down ] -> 	[ self zoom: 0.8 mouse: mouseLocalPosition. self redrawNeeded ].
			[ #left ] -> [ ].
			[ #right ] -> [ ].
		}! !

!ZoomPanMorph methodsFor: 'zoom' stamp: 'IGJ 3/8/2024 12:22:51'!
zoom: amount mouse: mouseLocalPosition

	"For instance, zoom in might be:
	
		zoom: 1.1
		
	zoom out might be:
	
		zoom: 0.9"

	| pixelUnderMouse pixelForOrigin delta |
	pixelForOrigin := location externalizePosition: origin.
	width := width / amount.
	height := height / amount.
	pixelUnderMouse := location externalizePosition: mouseLocalPosition.
	self scaleBy: amount.
	delta := pixelUnderMouse - (location externalizePosition: mouseLocalPosition).
	location := location translatedBy: delta.
	origin := location internalizePosition: pixelForOrigin.
	self submorphsDo: [ :each |
		each scaleBy: 1 / amount
	].! !

!ZoomPanMorph methodsFor: 'pan' stamp: 'IGJ 2/29/2024 09:58:52'!
handlesMouseDown: aMouseEvent
	^ true! !

!ZoomPanMorph methodsFor: 'pan' stamp: 'IGJ 3/8/2024 12:49:23'!
mouseButton1Down: aMouseEvent localPosition: mouseLocalPosition
	panStartPixel := location externalizePosition: mouseLocalPosition! !

!ZoomPanMorph methodsFor: 'pan' stamp: 'IGJ 3/8/2024 13:08:31'!
mouseMove: aMouseEvent localPosition: mouseLocalPosition
	| pixelForOrigin pixelUnderMouse delta |
	
	"Let's walk through an example run.
	
	# Background
	
	We're looking at the map of the US.
	The origin is at Oklahoma City.
	Also, we've already mouse-downed over Oklahoma City,
		so panStartPixel is set to its equivalent coordinate.

	# Execution

	Now we move the mouse to the right, which calls this method.
	We set a new origin to the left of Oklahoma city.
	This would move the whole viewport to the left on the screen.
	To prevent that we move the morph to the right."

	pixelForOrigin := location externalizePosition: origin.
	pixelUnderMouse := location externalizePosition: mouseLocalPosition.
	delta := (panStartPixel - pixelUnderMouse) negated.

	( (delta x abs > (width / 10)) or: (delta y abs > (width / 10)))
		ifTrue: [
			origin := location internalizePosition: (pixelForOrigin - delta).

			location := location translatedBy: delta.
			panStartPixel := pixelUnderMouse.	
	]
! !

!ZoomPanMorph methodsFor: 'geometry' stamp: 'IGJ 2/29/2024 09:20:35'!
morphLocalBounds
	^ Rectangle center: origin extent: width@height! !

!RoadTrip methodsFor: 'initialization' stamp: 'IGJ 2/22/2024 22:02:05'!
defaultColor
	^ `Color white`! !

!RoadTrip methodsFor: 'initialization' stamp: 'IGJ 3/9/2024 13:52:42'!
initialize
	super initialize.
	color := self defaultColor.

	usBorder := USBorder new.

	CityData new :: asJsonArray :: first: 200 :: collect: [ :each |
		self addMorph:
			(City new
				name: (each at: 'city');
				morphPosition: (each at: 'longitude') @ (each at: 'latitude'); "note the flip, long/lat not lat/long"
				population: (each at: 'population');
				scale: 0.02)
	].

	vehicle := Vehicle new
		:: morphPosition: -80 @ 40
		:: scale: 0.05.
	self addMorph: vehicle.
	vehicle newDestination. "Calls subMorphs, so needs to come after addMorph: vehicle"

	location := location withScale: 12.

	"US long is bounded by -130 to -60
	US lat is bounded by 50 to 20
	center point is long x lat y"
	origin := -95 @ 35.
	width := 70.
	height := 30.

	self startSteppingStepTime: self stepTime! !

!RoadTrip methodsFor: 'accessing' stamp: 'IGJ 2/22/2024 22:44:40'!
setColor: newColor
	color := newColor! !

!RoadTrip methodsFor: 'drawing' stamp: 'IGJ 3/9/2024 13:53:11'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color.
	usBorder drawOn: aCanvas! !

!RoadTrip methodsFor: 'geometry' stamp: 'IGJ 2/27/2024 20:41:49'!
yAxisPointsUp 
	"You have to use this, not `location := self location withCurrentYAxisInverted`.
	The latter is undone as soon as you use the hand to move the morph even slightly."
	^ true! !

!RoadTrip methodsFor: 'stepping' stamp: 'IGJ 2/22/2024 19:59:44'!
stepAt: millisecondSinceLast
	vehicle update: millisecondSinceLast.
	self redrawNeeded
! !

!RoadTrip methodsFor: 'stepping' stamp: 'IGJ 3/9/2024 14:37:05'!
stepTime
"in milliseconds"
	^ 1000! !

!RoadTrip methodsFor: 'stepping' stamp: 'IGJ 2/22/2024 19:29:47'!
wantsSteps
	^ true! !

!CityData methodsFor: 'json' stamp: 'IGJ 2/24/2024 11:00:59'!
asJsonArray
	^ Json new readFrom:  self asString readStream! !

!CityData methodsFor: 'json' stamp: 'IGJ 2/24/2024 10:46:07'!
asString
	"Copied from https://gist.github.com/Miserlou/c5cd8364bf9b2420bb29
	`'`s replaced escaped as `''`
	"
	^ '[
    {
        "city": "New York",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 40.7127837,
        "longitude": -74.0059413,
        "population": "8405837",
        "rank": "1",
        "state": "New York"
    },
    {
        "city": "Los Angeles",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 34.0522342,
        "longitude": -118.2436849,
        "population": "3884307",
        "rank": "2",
        "state": "California"
    },
    {
        "city": "Chicago",
        "growth_from_2000_to_2013": "-6.1%",
        "latitude": 41.8781136,
        "longitude": -87.6297982,
        "population": "2718782",
        "rank": "3",
        "state": "Illinois"
    },
    {
        "city": "Houston",
        "growth_from_2000_to_2013": "11.0%",
        "latitude": 29.7604267,
        "longitude": -95.3698028,
        "population": "2195914",
        "rank": "4",
        "state": "Texas"
    },
    {
        "city": "Philadelphia",
        "growth_from_2000_to_2013": "2.6%",
        "latitude": 39.9525839,
        "longitude": -75.1652215,
        "population": "1553165",
        "rank": "5",
        "state": "Pennsylvania"
    },
    {
        "city": "Phoenix",
        "growth_from_2000_to_2013": "14.0%",
        "latitude": 33.4483771,
        "longitude": -112.0740373,
        "population": "1513367",
        "rank": "6",
        "state": "Arizona"
    },
    {
        "city": "San Antonio",
        "growth_from_2000_to_2013": "21.0%",
        "latitude": 29.4241219,
        "longitude": -98.49362819999999,
        "population": "1409019",
        "rank": "7",
        "state": "Texas"
    },
    {
        "city": "San Diego",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 32.715738,
        "longitude": -117.1610838,
        "population": "1355896",
        "rank": "8",
        "state": "California"
    },
    {
        "city": "Dallas",
        "growth_from_2000_to_2013": "5.6%",
        "latitude": 32.7766642,
        "longitude": -96.79698789999999,
        "population": "1257676",
        "rank": "9",
        "state": "Texas"
    },
    {
        "city": "San Jose",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 37.3382082,
        "longitude": -121.8863286,
        "population": "998537",
        "rank": "10",
        "state": "California"
    },
    {
        "city": "Austin",
        "growth_from_2000_to_2013": "31.7%",
        "latitude": 30.267153,
        "longitude": -97.7430608,
        "population": "885400",
        "rank": "11",
        "state": "Texas"
    },
    {
        "city": "Indianapolis",
        "growth_from_2000_to_2013": "7.8%",
        "latitude": 39.768403,
        "longitude": -86.158068,
        "population": "843393",
        "rank": "12",
        "state": "Indiana"
    },
    {
        "city": "Jacksonville",
        "growth_from_2000_to_2013": "14.3%",
        "latitude": 30.3321838,
        "longitude": -81.65565099999999,
        "population": "842583",
        "rank": "13",
        "state": "Florida"
    },
    {
        "city": "San Francisco",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 37.7749295,
        "longitude": -122.4194155,
        "population": "837442",
        "rank": "14",
        "state": "California"
    },
    {
        "city": "Columbus",
        "growth_from_2000_to_2013": "14.8%",
        "latitude": 39.9611755,
        "longitude": -82.99879419999999,
        "population": "822553",
        "rank": "15",
        "state": "Ohio"
    },
    {
        "city": "Charlotte",
        "growth_from_2000_to_2013": "39.1%",
        "latitude": 35.2270869,
        "longitude": -80.8431267,
        "population": "792862",
        "rank": "16",
        "state": "North Carolina"
    },
    {
        "city": "Fort Worth",
        "growth_from_2000_to_2013": "45.1%",
        "latitude": 32.7554883,
        "longitude": -97.3307658,
        "population": "792727",
        "rank": "17",
        "state": "Texas"
    },
    {
        "city": "Detroit",
        "growth_from_2000_to_2013": "-27.1%",
        "latitude": 42.331427,
        "longitude": -83.0457538,
        "population": "688701",
        "rank": "18",
        "state": "Michigan"
    },
    {
        "city": "El Paso",
        "growth_from_2000_to_2013": "19.4%",
        "latitude": 31.7775757,
        "longitude": -106.4424559,
        "population": "674433",
        "rank": "19",
        "state": "Texas"
    },
    {
        "city": "Memphis",
        "growth_from_2000_to_2013": "-5.3%",
        "latitude": 35.1495343,
        "longitude": -90.0489801,
        "population": "653450",
        "rank": "20",
        "state": "Tennessee"
    },
    {
        "city": "Seattle",
        "growth_from_2000_to_2013": "15.6%",
        "latitude": 47.6062095,
        "longitude": -122.3320708,
        "population": "652405",
        "rank": "21",
        "state": "Washington"
    },
    {
        "city": "Denver",
        "growth_from_2000_to_2013": "16.7%",
        "latitude": 39.7392358,
        "longitude": -104.990251,
        "population": "649495",
        "rank": "22",
        "state": "Colorado"
    },
    {
        "city": "Washington",
        "growth_from_2000_to_2013": "13.0%",
        "latitude": 38.9071923,
        "longitude": -77.0368707,
        "population": "646449",
        "rank": "23",
        "state": "District of Columbia"
    },
    {
        "city": "Boston",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 42.3600825,
        "longitude": -71.0588801,
        "population": "645966",
        "rank": "24",
        "state": "Massachusetts"
    },
    {
        "city": "Nashville-Davidson",
        "growth_from_2000_to_2013": "16.2%",
        "latitude": 36.1626638,
        "longitude": -86.7816016,
        "population": "634464",
        "rank": "25",
        "state": "Tennessee"
    },
    {
        "city": "Baltimore",
        "growth_from_2000_to_2013": "-4.0%",
        "latitude": 39.2903848,
        "longitude": -76.6121893,
        "population": "622104",
        "rank": "26",
        "state": "Maryland"
    },
    {
        "city": "Oklahoma City",
        "growth_from_2000_to_2013": "20.2%",
        "latitude": 35.4675602,
        "longitude": -97.5164276,
        "population": "610613",
        "rank": "27",
        "state": "Oklahoma"
    },
    {
        "city": "Louisville/Jefferson County",
        "growth_from_2000_to_2013": "10.0%",
        "latitude": 38.2526647,
        "longitude": -85.7584557,
        "population": "609893",
        "rank": "28",
        "state": "Kentucky"
    },
    {
        "city": "Portland",
        "growth_from_2000_to_2013": "15.0%",
        "latitude": 45.5230622,
        "longitude": -122.6764816,
        "population": "609456",
        "rank": "29",
        "state": "Oregon"
    },
    {
        "city": "Las Vegas",
        "growth_from_2000_to_2013": "24.5%",
        "latitude": 36.1699412,
        "longitude": -115.1398296,
        "population": "603488",
        "rank": "30",
        "state": "Nevada"
    },
    {
        "city": "Milwaukee",
        "growth_from_2000_to_2013": "0.3%",
        "latitude": 43.0389025,
        "longitude": -87.9064736,
        "population": "599164",
        "rank": "31",
        "state": "Wisconsin"
    },
    {
        "city": "Albuquerque",
        "growth_from_2000_to_2013": "23.5%",
        "latitude": 35.0853336,
        "longitude": -106.6055534,
        "population": "556495",
        "rank": "32",
        "state": "New Mexico"
    },
    {
        "city": "Tucson",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 32.2217429,
        "longitude": -110.926479,
        "population": "526116",
        "rank": "33",
        "state": "Arizona"
    },
    {
        "city": "Fresno",
        "growth_from_2000_to_2013": "18.3%",
        "latitude": 36.7468422,
        "longitude": -119.7725868,
        "population": "509924",
        "rank": "34",
        "state": "California"
    },
    {
        "city": "Sacramento",
        "growth_from_2000_to_2013": "17.2%",
        "latitude": 38.5815719,
        "longitude": -121.4943996,
        "population": "479686",
        "rank": "35",
        "state": "California"
    },
    {
        "city": "Long Beach",
        "growth_from_2000_to_2013": "1.5%",
        "latitude": 33.7700504,
        "longitude": -118.1937395,
        "population": "469428",
        "rank": "36",
        "state": "California"
    },
    {
        "city": "Kansas City",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 39.0997265,
        "longitude": -94.5785667,
        "population": "467007",
        "rank": "37",
        "state": "Missouri"
    },
    {
        "city": "Mesa",
        "growth_from_2000_to_2013": "13.5%",
        "latitude": 33.4151843,
        "longitude": -111.8314724,
        "population": "457587",
        "rank": "38",
        "state": "Arizona"
    },
    {
        "city": "Virginia Beach",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 36.8529263,
        "longitude": -75.97798499999999,
        "population": "448479",
        "rank": "39",
        "state": "Virginia"
    },
    {
        "city": "Atlanta",
        "growth_from_2000_to_2013": "6.2%",
        "latitude": 33.7489954,
        "longitude": -84.3879824,
        "population": "447841",
        "rank": "40",
        "state": "Georgia"
    },
    {
        "city": "Colorado Springs",
        "growth_from_2000_to_2013": "21.4%",
        "latitude": 38.8338816,
        "longitude": -104.8213634,
        "population": "439886",
        "rank": "41",
        "state": "Colorado"
    },
    {
        "city": "Omaha",
        "growth_from_2000_to_2013": "5.9%",
        "latitude": 41.2523634,
        "longitude": -95.99798829999999,
        "population": "434353",
        "rank": "42",
        "state": "Nebraska"
    },
    {
        "city": "Raleigh",
        "growth_from_2000_to_2013": "48.7%",
        "latitude": 35.7795897,
        "longitude": -78.6381787,
        "population": "431746",
        "rank": "43",
        "state": "North Carolina"
    },
    {
        "city": "Miami",
        "growth_from_2000_to_2013": "14.9%",
        "latitude": 25.7616798,
        "longitude": -80.1917902,
        "population": "417650",
        "rank": "44",
        "state": "Florida"
    },
    {
        "city": "Oakland",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 37.8043637,
        "longitude": -122.2711137,
        "population": "406253",
        "rank": "45",
        "state": "California"
    },
    {
        "city": "Minneapolis",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 44.977753,
        "longitude": -93.2650108,
        "population": "400070",
        "rank": "46",
        "state": "Minnesota"
    },
    {
        "city": "Tulsa",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 36.1539816,
        "longitude": -95.99277500000001,
        "population": "398121",
        "rank": "47",
        "state": "Oklahoma"
    },
    {
        "city": "Cleveland",
        "growth_from_2000_to_2013": "-18.1%",
        "latitude": 41.49932,
        "longitude": -81.6943605,
        "population": "390113",
        "rank": "48",
        "state": "Ohio"
    },
    {
        "city": "Wichita",
        "growth_from_2000_to_2013": "9.7%",
        "latitude": 37.688889,
        "longitude": -97.336111,
        "population": "386552",
        "rank": "49",
        "state": "Kansas"
    },
    {
        "city": "Arlington",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 32.735687,
        "longitude": -97.10806559999999,
        "population": "379577",
        "rank": "50",
        "state": "Texas"
    },
    {
        "city": "New Orleans",
        "growth_from_2000_to_2013": "-21.6%",
        "latitude": 29.95106579999999,
        "longitude": -90.0715323,
        "population": "378715",
        "rank": "51",
        "state": "Louisiana"
    },
    {
        "city": "Bakersfield",
        "growth_from_2000_to_2013": "48.4%",
        "latitude": 35.3732921,
        "longitude": -119.0187125,
        "population": "363630",
        "rank": "52",
        "state": "California"
    },
    {
        "city": "Tampa",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 27.950575,
        "longitude": -82.4571776,
        "population": "352957",
        "rank": "53",
        "state": "Florida"
    },
    {
        "city": "Honolulu",
        "growth_from_2000_to_2013": "-6.2%",
        "latitude": 21.3069444,
        "longitude": -157.8583333,
        "population": "347884",
        "rank": "54",
        "state": "Hawaii"
    },
    {
        "city": "Aurora",
        "growth_from_2000_to_2013": "24.4%",
        "latitude": 39.7294319,
        "longitude": -104.8319195,
        "population": "345803",
        "rank": "55",
        "state": "Colorado"
    },
    {
        "city": "Anaheim",
        "growth_from_2000_to_2013": "4.7%",
        "latitude": 33.8352932,
        "longitude": -117.9145036,
        "population": "345012",
        "rank": "56",
        "state": "California"
    },
    {
        "city": "Santa Ana",
        "growth_from_2000_to_2013": "-1.2%",
        "latitude": 33.7455731,
        "longitude": -117.8678338,
        "population": "334227",
        "rank": "57",
        "state": "California"
    },
    {
        "city": "St. Louis",
        "growth_from_2000_to_2013": "-8.2%",
        "latitude": 38.6270025,
        "longitude": -90.19940419999999,
        "population": "318416",
        "rank": "58",
        "state": "Missouri"
    },
    {
        "city": "Riverside",
        "growth_from_2000_to_2013": "22.5%",
        "latitude": 33.9533487,
        "longitude": -117.3961564,
        "population": "316619",
        "rank": "59",
        "state": "California"
    },
    {
        "city": "Corpus Christi",
        "growth_from_2000_to_2013": "14.1%",
        "latitude": 27.8005828,
        "longitude": -97.39638099999999,
        "population": "316381",
        "rank": "60",
        "state": "Texas"
    },
    {
        "city": "Lexington-Fayette",
        "growth_from_2000_to_2013": "18.0%",
        "latitude": 38.0405837,
        "longitude": -84.5037164,
        "population": "308428",
        "rank": "61",
        "state": "Kentucky"
    },
    {
        "city": "Pittsburgh",
        "growth_from_2000_to_2013": "-8.3%",
        "latitude": 40.44062479999999,
        "longitude": -79.9958864,
        "population": "305841",
        "rank": "62",
        "state": "Pennsylvania"
    },
    {
        "city": "Anchorage",
        "growth_from_2000_to_2013": "15.4%",
        "latitude": 61.2180556,
        "longitude": -149.9002778,
        "population": "300950",
        "rank": "63",
        "state": "Alaska"
    },
    {
        "city": "Stockton",
        "growth_from_2000_to_2013": "21.8%",
        "latitude": 37.9577016,
        "longitude": -121.2907796,
        "population": "298118",
        "rank": "64",
        "state": "California"
    },
    {
        "city": "Cincinnati",
        "growth_from_2000_to_2013": "-10.1%",
        "latitude": 39.1031182,
        "longitude": -84.5120196,
        "population": "297517",
        "rank": "65",
        "state": "Ohio"
    },
    {
        "city": "St. Paul",
        "growth_from_2000_to_2013": "2.8%",
        "latitude": 44.9537029,
        "longitude": -93.0899578,
        "population": "294873",
        "rank": "66",
        "state": "Minnesota"
    },
    {
        "city": "Toledo",
        "growth_from_2000_to_2013": "-10.0%",
        "latitude": 41.6639383,
        "longitude": -83.55521200000001,
        "population": "282313",
        "rank": "67",
        "state": "Ohio"
    },
    {
        "city": "Greensboro",
        "growth_from_2000_to_2013": "22.3%",
        "latitude": 36.0726354,
        "longitude": -79.7919754,
        "population": "279639",
        "rank": "68",
        "state": "North Carolina"
    },
    {
        "city": "Newark",
        "growth_from_2000_to_2013": "2.1%",
        "latitude": 40.735657,
        "longitude": -74.1723667,
        "population": "278427",
        "rank": "69",
        "state": "New Jersey"
    },
    {
        "city": "Plano",
        "growth_from_2000_to_2013": "22.4%",
        "latitude": 33.0198431,
        "longitude": -96.6988856,
        "population": "274409",
        "rank": "70",
        "state": "Texas"
    },
    {
        "city": "Henderson",
        "growth_from_2000_to_2013": "51.0%",
        "latitude": 36.0395247,
        "longitude": -114.9817213,
        "population": "270811",
        "rank": "71",
        "state": "Nevada"
    },
    {
        "city": "Lincoln",
        "growth_from_2000_to_2013": "18.0%",
        "latitude": 40.8257625,
        "longitude": -96.6851982,
        "population": "268738",
        "rank": "72",
        "state": "Nebraska"
    },
    {
        "city": "Buffalo",
        "growth_from_2000_to_2013": "-11.3%",
        "latitude": 42.88644679999999,
        "longitude": -78.8783689,
        "population": "258959",
        "rank": "73",
        "state": "New York"
    },
    {
        "city": "Jersey City",
        "growth_from_2000_to_2013": "7.2%",
        "latitude": 40.72815749999999,
        "longitude": -74.0776417,
        "population": "257342",
        "rank": "74",
        "state": "New Jersey"
    },
    {
        "city": "Chula Vista",
        "growth_from_2000_to_2013": "46.2%",
        "latitude": 32.6400541,
        "longitude": -117.0841955,
        "population": "256780",
        "rank": "75",
        "state": "California"
    },
    {
        "city": "Fort Wayne",
        "growth_from_2000_to_2013": "1.0%",
        "latitude": 41.079273,
        "longitude": -85.1393513,
        "population": "256496",
        "rank": "76",
        "state": "Indiana"
    },
    {
        "city": "Orlando",
        "growth_from_2000_to_2013": "31.2%",
        "latitude": 28.5383355,
        "longitude": -81.3792365,
        "population": "255483",
        "rank": "77",
        "state": "Florida"
    },
    {
        "city": "St. Petersburg",
        "growth_from_2000_to_2013": "0.3%",
        "latitude": 27.773056,
        "longitude": -82.64,
        "population": "249688",
        "rank": "78",
        "state": "Florida"
    },
    {
        "city": "Chandler",
        "growth_from_2000_to_2013": "38.7%",
        "latitude": 33.3061605,
        "longitude": -111.8412502,
        "population": "249146",
        "rank": "79",
        "state": "Arizona"
    },
    {
        "city": "Laredo",
        "growth_from_2000_to_2013": "38.2%",
        "latitude": 27.5305671,
        "longitude": -99.48032409999999,
        "population": "248142",
        "rank": "80",
        "state": "Texas"
    },
    {
        "city": "Norfolk",
        "growth_from_2000_to_2013": "5.0%",
        "latitude": 36.8507689,
        "longitude": -76.28587259999999,
        "population": "246139",
        "rank": "81",
        "state": "Virginia"
    },
    {
        "city": "Durham",
        "growth_from_2000_to_2013": "29.9%",
        "latitude": 35.9940329,
        "longitude": -78.898619,
        "population": "245475",
        "rank": "82",
        "state": "North Carolina"
    },
    {
        "city": "Madison",
        "growth_from_2000_to_2013": "15.8%",
        "latitude": 43.0730517,
        "longitude": -89.4012302,
        "population": "243344",
        "rank": "83",
        "state": "Wisconsin"
    },
    {
        "city": "Lubbock",
        "growth_from_2000_to_2013": "19.6%",
        "latitude": 33.5778631,
        "longitude": -101.8551665,
        "population": "239538",
        "rank": "84",
        "state": "Texas"
    },
    {
        "city": "Irvine",
        "growth_from_2000_to_2013": "61.3%",
        "latitude": 33.6839473,
        "longitude": -117.7946942,
        "population": "236716",
        "rank": "85",
        "state": "California"
    },
    {
        "city": "Winston-Salem",
        "growth_from_2000_to_2013": "16.9%",
        "latitude": 36.09985959999999,
        "longitude": -80.244216,
        "population": "236441",
        "rank": "86",
        "state": "North Carolina"
    },
    {
        "city": "Glendale",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 33.5386523,
        "longitude": -112.1859866,
        "population": "234632",
        "rank": "87",
        "state": "Arizona"
    },
    {
        "city": "Garland",
        "growth_from_2000_to_2013": "8.5%",
        "latitude": 32.912624,
        "longitude": -96.63888329999999,
        "population": "234566",
        "rank": "88",
        "state": "Texas"
    },
    {
        "city": "Hialeah",
        "growth_from_2000_to_2013": "3.2%",
        "latitude": 25.8575963,
        "longitude": -80.2781057,
        "population": "233394",
        "rank": "89",
        "state": "Florida"
    },
    {
        "city": "Reno",
        "growth_from_2000_to_2013": "26.8%",
        "latitude": 39.5296329,
        "longitude": -119.8138027,
        "population": "233294",
        "rank": "90",
        "state": "Nevada"
    },
    {
        "city": "Chesapeake",
        "growth_from_2000_to_2013": "15.1%",
        "latitude": 36.7682088,
        "longitude": -76.2874927,
        "population": "230571",
        "rank": "91",
        "state": "Virginia"
    },
    {
        "city": "Gilbert",
        "growth_from_2000_to_2013": "96.0%",
        "latitude": 33.3528264,
        "longitude": -111.789027,
        "population": "229972",
        "rank": "92",
        "state": "Arizona"
    },
    {
        "city": "Baton Rouge",
        "growth_from_2000_to_2013": "0.4%",
        "latitude": 30.4582829,
        "longitude": -91.1403196,
        "population": "229426",
        "rank": "93",
        "state": "Louisiana"
    },
    {
        "city": "Irving",
        "growth_from_2000_to_2013": "19.1%",
        "latitude": 32.8140177,
        "longitude": -96.9488945,
        "population": "228653",
        "rank": "94",
        "state": "Texas"
    },
    {
        "city": "Scottsdale",
        "growth_from_2000_to_2013": "11.0%",
        "latitude": 33.4941704,
        "longitude": -111.9260519,
        "population": "226918",
        "rank": "95",
        "state": "Arizona"
    },
    {
        "city": "North Las Vegas",
        "growth_from_2000_to_2013": "92.2%",
        "latitude": 36.1988592,
        "longitude": -115.1175013,
        "population": "226877",
        "rank": "96",
        "state": "Nevada"
    },
    {
        "city": "Fremont",
        "growth_from_2000_to_2013": "10.0%",
        "latitude": 37.5482697,
        "longitude": -121.9885719,
        "population": "224922",
        "rank": "97",
        "state": "California"
    },
    {
        "city": "Boise City",
        "growth_from_2000_to_2013": "9.5%",
        "latitude": 43.6187102,
        "longitude": -116.2146068,
        "population": "214237",
        "rank": "98",
        "state": "Idaho"
    },
    {
        "city": "Richmond",
        "growth_from_2000_to_2013": "8.2%",
        "latitude": 37.5407246,
        "longitude": -77.4360481,
        "population": "214114",
        "rank": "99",
        "state": "Virginia"
    },
    {
        "city": "San Bernardino",
        "growth_from_2000_to_2013": "13.0%",
        "latitude": 34.1083449,
        "longitude": -117.2897652,
        "population": "213708",
        "rank": "100",
        "state": "California"
    },
    {
        "city": "Birmingham",
        "growth_from_2000_to_2013": "-12.3%",
        "latitude": 33.5206608,
        "longitude": -86.80248999999999,
        "population": "212113",
        "rank": "101",
        "state": "Alabama"
    },
    {
        "city": "Spokane",
        "growth_from_2000_to_2013": "7.0%",
        "latitude": 47.6587802,
        "longitude": -117.4260466,
        "population": "210721",
        "rank": "102",
        "state": "Washington"
    },
    {
        "city": "Rochester",
        "growth_from_2000_to_2013": "-4.1%",
        "latitude": 43.16103,
        "longitude": -77.6109219,
        "population": "210358",
        "rank": "103",
        "state": "New York"
    },
    {
        "city": "Des Moines",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 41.6005448,
        "longitude": -93.6091064,
        "population": "207510",
        "rank": "104",
        "state": "Iowa"
    },
    {
        "city": "Modesto",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 37.63909719999999,
        "longitude": -120.9968782,
        "population": "204933",
        "rank": "105",
        "state": "California"
    },
    {
        "city": "Fayetteville",
        "growth_from_2000_to_2013": "2.4%",
        "latitude": 35.0526641,
        "longitude": -78.87835849999999,
        "population": "204408",
        "rank": "106",
        "state": "North Carolina"
    },
    {
        "city": "Tacoma",
        "growth_from_2000_to_2013": "4.9%",
        "latitude": 47.2528768,
        "longitude": -122.4442906,
        "population": "203446",
        "rank": "107",
        "state": "Washington"
    },
    {
        "city": "Oxnard",
        "growth_from_2000_to_2013": "18.2%",
        "latitude": 34.1975048,
        "longitude": -119.1770516,
        "population": "203007",
        "rank": "108",
        "state": "California"
    },
    {
        "city": "Fontana",
        "growth_from_2000_to_2013": "38.3%",
        "latitude": 34.0922335,
        "longitude": -117.435048,
        "population": "203003",
        "rank": "109",
        "state": "California"
    },
    {
        "city": "Columbus",
        "growth_from_2000_to_2013": "8.7%",
        "latitude": 32.4609764,
        "longitude": -84.9877094,
        "population": "202824",
        "rank": "110",
        "state": "Georgia"
    },
    {
        "city": "Montgomery",
        "growth_from_2000_to_2013": "-0.1%",
        "latitude": 32.3668052,
        "longitude": -86.2999689,
        "population": "201332",
        "rank": "111",
        "state": "Alabama"
    },
    {
        "city": "Moreno Valley",
        "growth_from_2000_to_2013": "40.4%",
        "latitude": 33.9424658,
        "longitude": -117.2296717,
        "population": "201175",
        "rank": "112",
        "state": "California"
    },
    {
        "city": "Shreveport",
        "growth_from_2000_to_2013": "-0.1%",
        "latitude": 32.5251516,
        "longitude": -93.7501789,
        "population": "200327",
        "rank": "113",
        "state": "Louisiana"
    },
    {
        "city": "Aurora",
        "growth_from_2000_to_2013": "38.4%",
        "latitude": 41.7605849,
        "longitude": -88.32007150000001,
        "population": "199963",
        "rank": "114",
        "state": "Illinois"
    },
    {
        "city": "Yonkers",
        "growth_from_2000_to_2013": "1.8%",
        "latitude": 40.9312099,
        "longitude": -73.89874689999999,
        "population": "199766",
        "rank": "115",
        "state": "New York"
    },
    {
        "city": "Akron",
        "growth_from_2000_to_2013": "-8.6%",
        "latitude": 41.0814447,
        "longitude": -81.51900529999999,
        "population": "198100",
        "rank": "116",
        "state": "Ohio"
    },
    {
        "city": "Huntington Beach",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 33.660297,
        "longitude": -117.9992265,
        "population": "197575",
        "rank": "117",
        "state": "California"
    },
    {
        "city": "Little Rock",
        "growth_from_2000_to_2013": "7.6%",
        "latitude": 34.7464809,
        "longitude": -92.28959479999999,
        "population": "197357",
        "rank": "118",
        "state": "Arkansas"
    },
    {
        "city": "Augusta-Richmond County",
        "growth_from_2000_to_2013": "1.1%",
        "latitude": 33.4734978,
        "longitude": -82.0105148,
        "population": "197350",
        "rank": "119",
        "state": "Georgia"
    },
    {
        "city": "Amarillo",
        "growth_from_2000_to_2013": "12.8%",
        "latitude": 35.2219971,
        "longitude": -101.8312969,
        "population": "196429",
        "rank": "120",
        "state": "Texas"
    },
    {
        "city": "Glendale",
        "growth_from_2000_to_2013": "0.3%",
        "latitude": 34.1425078,
        "longitude": -118.255075,
        "population": "196021",
        "rank": "121",
        "state": "California"
    },
    {
        "city": "Mobile",
        "growth_from_2000_to_2013": "-1.9%",
        "latitude": 30.6953657,
        "longitude": -88.0398912,
        "population": "194899",
        "rank": "122",
        "state": "Alabama"
    },
    {
        "city": "Grand Rapids",
        "growth_from_2000_to_2013": "-2.8%",
        "latitude": 42.9633599,
        "longitude": -85.6680863,
        "population": "192294",
        "rank": "123",
        "state": "Michigan"
    },
    {
        "city": "Salt Lake City",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 40.7607793,
        "longitude": -111.8910474,
        "population": "191180",
        "rank": "124",
        "state": "Utah"
    },
    {
        "city": "Tallahassee",
        "growth_from_2000_to_2013": "21.8%",
        "latitude": 30.4382559,
        "longitude": -84.28073289999999,
        "population": "186411",
        "rank": "125",
        "state": "Florida"
    },
    {
        "city": "Huntsville",
        "growth_from_2000_to_2013": "16.3%",
        "latitude": 34.7303688,
        "longitude": -86.5861037,
        "population": "186254",
        "rank": "126",
        "state": "Alabama"
    },
    {
        "city": "Grand Prairie",
        "growth_from_2000_to_2013": "43.1%",
        "latitude": 32.7459645,
        "longitude": -96.99778459999999,
        "population": "183372",
        "rank": "127",
        "state": "Texas"
    },
    {
        "city": "Knoxville",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 35.9606384,
        "longitude": -83.9207392,
        "population": "183270",
        "rank": "128",
        "state": "Tennessee"
    },
    {
        "city": "Worcester",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 42.2625932,
        "longitude": -71.8022934,
        "population": "182544",
        "rank": "129",
        "state": "Massachusetts"
    },
    {
        "city": "Newport News",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 37.0870821,
        "longitude": -76.4730122,
        "population": "182020",
        "rank": "130",
        "state": "Virginia"
    },
    {
        "city": "Brownsville",
        "growth_from_2000_to_2013": "26.8%",
        "latitude": 25.9017472,
        "longitude": -97.4974838,
        "population": "181860",
        "rank": "131",
        "state": "Texas"
    },
    {
        "city": "Overland Park",
        "growth_from_2000_to_2013": "19.4%",
        "latitude": 38.9822282,
        "longitude": -94.6707917,
        "population": "181260",
        "rank": "132",
        "state": "Kansas"
    },
    {
        "city": "Santa Clarita",
        "growth_from_2000_to_2013": "15.3%",
        "latitude": 34.3916641,
        "longitude": -118.542586,
        "population": "179590",
        "rank": "133",
        "state": "California"
    },
    {
        "city": "Providence",
        "growth_from_2000_to_2013": "2.3%",
        "latitude": 41.8239891,
        "longitude": -71.4128343,
        "population": "177994",
        "rank": "134",
        "state": "Rhode Island"
    },
    {
        "city": "Garden Grove",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 33.7739053,
        "longitude": -117.9414477,
        "population": "175140",
        "rank": "135",
        "state": "California"
    },
    {
        "city": "Chattanooga",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 35.0456297,
        "longitude": -85.3096801,
        "population": "173366",
        "rank": "136",
        "state": "Tennessee"
    },
    {
        "city": "Oceanside",
        "growth_from_2000_to_2013": "6.6%",
        "latitude": 33.1958696,
        "longitude": -117.3794834,
        "population": "172794",
        "rank": "137",
        "state": "California"
    },
    {
        "city": "Jackson",
        "growth_from_2000_to_2013": "-6.8%",
        "latitude": 32.2987573,
        "longitude": -90.1848103,
        "population": "172638",
        "rank": "138",
        "state": "Mississippi"
    },
    {
        "city": "Fort Lauderdale",
        "growth_from_2000_to_2013": "0.7%",
        "latitude": 26.1224386,
        "longitude": -80.13731740000001,
        "population": "172389",
        "rank": "139",
        "state": "Florida"
    },
    {
        "city": "Santa Rosa",
        "growth_from_2000_to_2013": "15.2%",
        "latitude": 38.440429,
        "longitude": -122.7140548,
        "population": "171990",
        "rank": "140",
        "state": "California"
    },
    {
        "city": "Rancho Cucamonga",
        "growth_from_2000_to_2013": "32.7%",
        "latitude": 34.10639889999999,
        "longitude": -117.5931084,
        "population": "171386",
        "rank": "141",
        "state": "California"
    },
    {
        "city": "Port St. Lucie",
        "growth_from_2000_to_2013": "91.7%",
        "latitude": 27.2730492,
        "longitude": -80.3582261,
        "population": "171016",
        "rank": "142",
        "state": "Florida"
    },
    {
        "city": "Tempe",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 33.4255104,
        "longitude": -111.9400054,
        "population": "168228",
        "rank": "143",
        "state": "Arizona"
    },
    {
        "city": "Ontario",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 34.0633443,
        "longitude": -117.6508876,
        "population": "167500",
        "rank": "144",
        "state": "California"
    },
    {
        "city": "Vancouver",
        "growth_from_2000_to_2013": "14.2%",
        "latitude": 45.6387281,
        "longitude": -122.6614861,
        "population": "167405",
        "rank": "145",
        "state": "Washington"
    },
    {
        "city": "Cape Coral",
        "growth_from_2000_to_2013": "60.4%",
        "latitude": 26.5628537,
        "longitude": -81.9495331,
        "population": "165831",
        "rank": "146",
        "state": "Florida"
    },
    {
        "city": "Sioux Falls",
        "growth_from_2000_to_2013": "31.1%",
        "latitude": 43.5445959,
        "longitude": -96.73110340000001,
        "population": "164676",
        "rank": "147",
        "state": "South Dakota"
    },
    {
        "city": "Springfield",
        "growth_from_2000_to_2013": "7.8%",
        "latitude": 37.2089572,
        "longitude": -93.29229889999999,
        "population": "164122",
        "rank": "148",
        "state": "Missouri"
    },
    {
        "city": "Peoria",
        "growth_from_2000_to_2013": "46.5%",
        "latitude": 33.5805955,
        "longitude": -112.2373779,
        "population": "162592",
        "rank": "149",
        "state": "Arizona"
    },
    {
        "city": "Pembroke Pines",
        "growth_from_2000_to_2013": "17.4%",
        "latitude": 26.007765,
        "longitude": -80.2962555,
        "population": "162329",
        "rank": "150",
        "state": "Florida"
    },
    {
        "city": "Elk Grove",
        "growth_from_2000_to_2013": "97.1%",
        "latitude": 38.4087993,
        "longitude": -121.3716178,
        "population": "161007",
        "rank": "151",
        "state": "California"
    },
    {
        "city": "Salem",
        "growth_from_2000_to_2013": "16.4%",
        "latitude": 44.9428975,
        "longitude": -123.0350963,
        "population": "160614",
        "rank": "152",
        "state": "Oregon"
    },
    {
        "city": "Lancaster",
        "growth_from_2000_to_2013": "33.8%",
        "latitude": 34.6867846,
        "longitude": -118.1541632,
        "population": "159523",
        "rank": "153",
        "state": "California"
    },
    {
        "city": "Corona",
        "growth_from_2000_to_2013": "23.6%",
        "latitude": 33.8752935,
        "longitude": -117.5664384,
        "population": "159503",
        "rank": "154",
        "state": "California"
    },
    {
        "city": "Eugene",
        "growth_from_2000_to_2013": "14.4%",
        "latitude": 44.0520691,
        "longitude": -123.0867536,
        "population": "159190",
        "rank": "155",
        "state": "Oregon"
    },
    {
        "city": "Palmdale",
        "growth_from_2000_to_2013": "33.7%",
        "latitude": 34.5794343,
        "longitude": -118.1164613,
        "population": "157161",
        "rank": "156",
        "state": "California"
    },
    {
        "city": "Salinas",
        "growth_from_2000_to_2013": "8.4%",
        "latitude": 36.6777372,
        "longitude": -121.6555013,
        "population": "155662",
        "rank": "157",
        "state": "California"
    },
    {
        "city": "Springfield",
        "growth_from_2000_to_2013": "1.1%",
        "latitude": 42.1014831,
        "longitude": -72.589811,
        "population": "153703",
        "rank": "158",
        "state": "Massachusetts"
    },
    {
        "city": "Pasadena",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 29.6910625,
        "longitude": -95.2091006,
        "population": "152735",
        "rank": "159",
        "state": "Texas"
    },
    {
        "city": "Fort Collins",
        "growth_from_2000_to_2013": "26.6%",
        "latitude": 40.5852602,
        "longitude": -105.084423,
        "population": "152061",
        "rank": "160",
        "state": "Colorado"
    },
    {
        "city": "Hayward",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 37.6688205,
        "longitude": -122.0807964,
        "population": "151574",
        "rank": "161",
        "state": "California"
    },
    {
        "city": "Pomona",
        "growth_from_2000_to_2013": "2.1%",
        "latitude": 34.055103,
        "longitude": -117.7499909,
        "population": "151348",
        "rank": "162",
        "state": "California"
    },
    {
        "city": "Cary",
        "growth_from_2000_to_2013": "55.1%",
        "latitude": 35.79154,
        "longitude": -78.7811169,
        "population": "151088",
        "rank": "163",
        "state": "North Carolina"
    },
    {
        "city": "Rockford",
        "growth_from_2000_to_2013": "-1.0%",
        "latitude": 42.2711311,
        "longitude": -89.0939952,
        "population": "150251",
        "rank": "164",
        "state": "Illinois"
    },
    {
        "city": "Alexandria",
        "growth_from_2000_to_2013": "15.0%",
        "latitude": 38.8048355,
        "longitude": -77.0469214,
        "population": "148892",
        "rank": "165",
        "state": "Virginia"
    },
    {
        "city": "Escondido",
        "growth_from_2000_to_2013": "10.7%",
        "latitude": 33.1192068,
        "longitude": -117.086421,
        "population": "148738",
        "rank": "166",
        "state": "California"
    },
    {
        "city": "McKinney",
        "growth_from_2000_to_2013": "165.3%",
        "latitude": 33.1972465,
        "longitude": -96.6397822,
        "population": "148559",
        "rank": "167",
        "state": "Texas"
    },
    {
        "city": "Kansas City",
        "growth_from_2000_to_2013": "1.1%",
        "latitude": 39.114053,
        "longitude": -94.6274636,
        "population": "148483",
        "rank": "168",
        "state": "Kansas"
    },
    {
        "city": "Joliet",
        "growth_from_2000_to_2013": "36.5%",
        "latitude": 41.525031,
        "longitude": -88.0817251,
        "population": "147806",
        "rank": "169",
        "state": "Illinois"
    },
    {
        "city": "Sunnyvale",
        "growth_from_2000_to_2013": "11.9%",
        "latitude": 37.36883,
        "longitude": -122.0363496,
        "population": "147559",
        "rank": "170",
        "state": "California"
    },
    {
        "city": "Torrance",
        "growth_from_2000_to_2013": "6.6%",
        "latitude": 33.8358492,
        "longitude": -118.3406288,
        "population": "147478",
        "rank": "171",
        "state": "California"
    },
    {
        "city": "Bridgeport",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 41.1865478,
        "longitude": -73.19517669999999,
        "population": "147216",
        "rank": "172",
        "state": "Connecticut"
    },
    {
        "city": "Lakewood",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 39.7047095,
        "longitude": -105.0813734,
        "population": "147214",
        "rank": "173",
        "state": "Colorado"
    },
    {
        "city": "Hollywood",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 26.0112014,
        "longitude": -80.1494901,
        "population": "146526",
        "rank": "174",
        "state": "Florida"
    },
    {
        "city": "Paterson",
        "growth_from_2000_to_2013": "-2.2%",
        "latitude": 40.9167654,
        "longitude": -74.17181099999999,
        "population": "145948",
        "rank": "175",
        "state": "New Jersey"
    },
    {
        "city": "Naperville",
        "growth_from_2000_to_2013": "12.0%",
        "latitude": 41.7508391,
        "longitude": -88.1535352,
        "population": "144864",
        "rank": "176",
        "state": "Illinois"
    },
    {
        "city": "Syracuse",
        "growth_from_2000_to_2013": "-0.9%",
        "latitude": 43.0481221,
        "longitude": -76.14742439999999,
        "population": "144669",
        "rank": "177",
        "state": "New York"
    },
    {
        "city": "Mesquite",
        "growth_from_2000_to_2013": "14.7%",
        "latitude": 32.76679550000001,
        "longitude": -96.5991593,
        "population": "143484",
        "rank": "178",
        "state": "Texas"
    },
    {
        "city": "Dayton",
        "growth_from_2000_to_2013": "-13.5%",
        "latitude": 39.7589478,
        "longitude": -84.1916069,
        "population": "143355",
        "rank": "179",
        "state": "Ohio"
    },
    {
        "city": "Savannah",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 32.0835407,
        "longitude": -81.09983419999999,
        "population": "142772",
        "rank": "180",
        "state": "Georgia"
    },
    {
        "city": "Clarksville",
        "growth_from_2000_to_2013": "36.9%",
        "latitude": 36.5297706,
        "longitude": -87.3594528,
        "population": "142357",
        "rank": "181",
        "state": "Tennessee"
    },
    {
        "city": "Orange",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 33.7877944,
        "longitude": -117.8531119,
        "population": "139969",
        "rank": "182",
        "state": "California"
    },
    {
        "city": "Pasadena",
        "growth_from_2000_to_2013": "3.8%",
        "latitude": 34.1477849,
        "longitude": -118.1445155,
        "population": "139731",
        "rank": "183",
        "state": "California"
    },
    {
        "city": "Fullerton",
        "growth_from_2000_to_2013": "9.8%",
        "latitude": 33.8703596,
        "longitude": -117.9242966,
        "population": "138981",
        "rank": "184",
        "state": "California"
    },
    {
        "city": "Killeen",
        "growth_from_2000_to_2013": "52.1%",
        "latitude": 31.1171194,
        "longitude": -97.72779589999999,
        "population": "137147",
        "rank": "185",
        "state": "Texas"
    },
    {
        "city": "Frisco",
        "growth_from_2000_to_2013": "287.7%",
        "latitude": 33.1506744,
        "longitude": -96.82361159999999,
        "population": "136791",
        "rank": "186",
        "state": "Texas"
    },
    {
        "city": "Hampton",
        "growth_from_2000_to_2013": "-6.6%",
        "latitude": 37.0298687,
        "longitude": -76.34522179999999,
        "population": "136699",
        "rank": "187",
        "state": "Virginia"
    },
    {
        "city": "McAllen",
        "growth_from_2000_to_2013": "27.6%",
        "latitude": 26.2034071,
        "longitude": -98.23001239999999,
        "population": "136639",
        "rank": "188",
        "state": "Texas"
    },
    {
        "city": "Warren",
        "growth_from_2000_to_2013": "-2.3%",
        "latitude": 42.5144566,
        "longitude": -83.01465259999999,
        "population": "134873",
        "rank": "189",
        "state": "Michigan"
    },
    {
        "city": "Bellevue",
        "growth_from_2000_to_2013": "19.1%",
        "latitude": 47.610377,
        "longitude": -122.2006786,
        "population": "133992",
        "rank": "190",
        "state": "Washington"
    },
    {
        "city": "West Valley City",
        "growth_from_2000_to_2013": "22.2%",
        "latitude": 40.6916132,
        "longitude": -112.0010501,
        "population": "133579",
        "rank": "191",
        "state": "Utah"
    },
    {
        "city": "Columbia",
        "growth_from_2000_to_2013": "11.7%",
        "latitude": 34.0007104,
        "longitude": -81.0348144,
        "population": "133358",
        "rank": "192",
        "state": "South Carolina"
    },
    {
        "city": "Olathe",
        "growth_from_2000_to_2013": "40.4%",
        "latitude": 38.8813958,
        "longitude": -94.81912849999999,
        "population": "131885",
        "rank": "193",
        "state": "Kansas"
    },
    {
        "city": "Sterling Heights",
        "growth_from_2000_to_2013": "5.2%",
        "latitude": 42.5803122,
        "longitude": -83.0302033,
        "population": "131224",
        "rank": "194",
        "state": "Michigan"
    },
    {
        "city": "New Haven",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 41.308274,
        "longitude": -72.9278835,
        "population": "130660",
        "rank": "195",
        "state": "Connecticut"
    },
    {
        "city": "Miramar",
        "growth_from_2000_to_2013": "74.7%",
        "latitude": 25.9860762,
        "longitude": -80.30356019999999,
        "population": "130288",
        "rank": "196",
        "state": "Florida"
    },
    {
        "city": "Waco",
        "growth_from_2000_to_2013": "12.5%",
        "latitude": 31.549333,
        "longitude": -97.1466695,
        "population": "129030",
        "rank": "197",
        "state": "Texas"
    },
    {
        "city": "Thousand Oaks",
        "growth_from_2000_to_2013": "9.5%",
        "latitude": 34.1705609,
        "longitude": -118.8375937,
        "population": "128731",
        "rank": "198",
        "state": "California"
    },
    {
        "city": "Cedar Rapids",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 41.9778795,
        "longitude": -91.6656232,
        "population": "128429",
        "rank": "199",
        "state": "Iowa"
    },
    {
        "city": "Charleston",
        "growth_from_2000_to_2013": "29.2%",
        "latitude": 32.7764749,
        "longitude": -79.93105120000001,
        "population": "127999",
        "rank": "200",
        "state": "South Carolina"
    },
    {
        "city": "Visalia",
        "growth_from_2000_to_2013": "33.6%",
        "latitude": 36.3302284,
        "longitude": -119.2920585,
        "population": "127763",
        "rank": "201",
        "state": "California"
    },
    {
        "city": "Topeka",
        "growth_from_2000_to_2013": "3.4%",
        "latitude": 39.0558235,
        "longitude": -95.68901849999999,
        "population": "127679",
        "rank": "202",
        "state": "Kansas"
    },
    {
        "city": "Elizabeth",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 40.6639916,
        "longitude": -74.2107006,
        "population": "127558",
        "rank": "203",
        "state": "New Jersey"
    },
    {
        "city": "Gainesville",
        "growth_from_2000_to_2013": "12.8%",
        "latitude": 29.6516344,
        "longitude": -82.32482619999999,
        "population": "127488",
        "rank": "204",
        "state": "Florida"
    },
    {
        "city": "Thornton",
        "growth_from_2000_to_2013": "52.9%",
        "latitude": 39.8680412,
        "longitude": -104.9719243,
        "population": "127359",
        "rank": "205",
        "state": "Colorado"
    },
    {
        "city": "Roseville",
        "growth_from_2000_to_2013": "56.2%",
        "latitude": 38.7521235,
        "longitude": -121.2880059,
        "population": "127035",
        "rank": "206",
        "state": "California"
    },
    {
        "city": "Carrollton",
        "growth_from_2000_to_2013": "14.9%",
        "latitude": 32.9756415,
        "longitude": -96.8899636,
        "population": "126700",
        "rank": "207",
        "state": "Texas"
    },
    {
        "city": "Coral Springs",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 26.271192,
        "longitude": -80.2706044,
        "population": "126604",
        "rank": "208",
        "state": "Florida"
    },
    {
        "city": "Stamford",
        "growth_from_2000_to_2013": "7.6%",
        "latitude": 41.0534302,
        "longitude": -73.5387341,
        "population": "126456",
        "rank": "209",
        "state": "Connecticut"
    },
    {
        "city": "Simi Valley",
        "growth_from_2000_to_2013": "12.6%",
        "latitude": 34.2694474,
        "longitude": -118.781482,
        "population": "126181",
        "rank": "210",
        "state": "California"
    },
    {
        "city": "Concord",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 37.9779776,
        "longitude": -122.0310733,
        "population": "125880",
        "rank": "211",
        "state": "California"
    },
    {
        "city": "Hartford",
        "growth_from_2000_to_2013": "0.6%",
        "latitude": 41.76371109999999,
        "longitude": -72.6850932,
        "population": "125017",
        "rank": "212",
        "state": "Connecticut"
    },
    {
        "city": "Kent",
        "growth_from_2000_to_2013": "54.3%",
        "latitude": 47.3809335,
        "longitude": -122.2348431,
        "population": "124435",
        "rank": "213",
        "state": "Washington"
    },
    {
        "city": "Lafayette",
        "growth_from_2000_to_2013": "11.0%",
        "latitude": 30.2240897,
        "longitude": -92.0198427,
        "population": "124276",
        "rank": "214",
        "state": "Louisiana"
    },
    {
        "city": "Midland",
        "growth_from_2000_to_2013": "30.4%",
        "latitude": 31.9973456,
        "longitude": -102.0779146,
        "population": "123933",
        "rank": "215",
        "state": "Texas"
    },
    {
        "city": "Surprise",
        "growth_from_2000_to_2013": "281.9%",
        "latitude": 33.6292337,
        "longitude": -112.3679279,
        "population": "123546",
        "rank": "216",
        "state": "Arizona"
    },
    {
        "city": "Denton",
        "growth_from_2000_to_2013": "47.1%",
        "latitude": 33.2148412,
        "longitude": -97.13306829999999,
        "population": "123099",
        "rank": "217",
        "state": "Texas"
    },
    {
        "city": "Victorville",
        "growth_from_2000_to_2013": "87.6%",
        "latitude": 34.5362184,
        "longitude": -117.2927641,
        "population": "121096",
        "rank": "218",
        "state": "California"
    },
    {
        "city": "Evansville",
        "growth_from_2000_to_2013": "-0.8%",
        "latitude": 37.9715592,
        "longitude": -87.5710898,
        "population": "120310",
        "rank": "219",
        "state": "Indiana"
    },
    {
        "city": "Santa Clara",
        "growth_from_2000_to_2013": "17.4%",
        "latitude": 37.3541079,
        "longitude": -121.9552356,
        "population": "120245",
        "rank": "220",
        "state": "California"
    },
    {
        "city": "Abilene",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 32.4487364,
        "longitude": -99.73314390000002,
        "population": "120099",
        "rank": "221",
        "state": "Texas"
    },
    {
        "city": "Athens-Clarke County",
        "growth_from_2000_to_2013": "19.0%",
        "latitude": 33.9519347,
        "longitude": -83.357567,
        "population": "119980",
        "rank": "222",
        "state": "Georgia"
    },
    {
        "city": "Vallejo",
        "growth_from_2000_to_2013": "1.2%",
        "latitude": 38.1040864,
        "longitude": -122.2566367,
        "population": "118837",
        "rank": "223",
        "state": "California"
    },
    {
        "city": "Allentown",
        "growth_from_2000_to_2013": "11.2%",
        "latitude": 40.6084305,
        "longitude": -75.4901833,
        "population": "118577",
        "rank": "224",
        "state": "Pennsylvania"
    },
    {
        "city": "Norman",
        "growth_from_2000_to_2013": "22.0%",
        "latitude": 35.2225668,
        "longitude": -97.4394777,
        "population": "118197",
        "rank": "225",
        "state": "Oklahoma"
    },
    {
        "city": "Beaumont",
        "growth_from_2000_to_2013": "3.7%",
        "latitude": 30.080174,
        "longitude": -94.1265562,
        "population": "117796",
        "rank": "226",
        "state": "Texas"
    },
    {
        "city": "Independence",
        "growth_from_2000_to_2013": "3.2%",
        "latitude": 39.0911161,
        "longitude": -94.41550679999999,
        "population": "117240",
        "rank": "227",
        "state": "Missouri"
    },
    {
        "city": "Murfreesboro",
        "growth_from_2000_to_2013": "65.1%",
        "latitude": 35.8456213,
        "longitude": -86.39027,
        "population": "117044",
        "rank": "228",
        "state": "Tennessee"
    },
    {
        "city": "Ann Arbor",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 42.2808256,
        "longitude": -83.7430378,
        "population": "117025",
        "rank": "229",
        "state": "Michigan"
    },
    {
        "city": "Springfield",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 39.78172130000001,
        "longitude": -89.6501481,
        "population": "117006",
        "rank": "230",
        "state": "Illinois"
    },
    {
        "city": "Berkeley",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 37.8715926,
        "longitude": -122.272747,
        "population": "116768",
        "rank": "231",
        "state": "California"
    },
    {
        "city": "Peoria",
        "growth_from_2000_to_2013": "3.0%",
        "latitude": 40.6936488,
        "longitude": -89.5889864,
        "population": "116513",
        "rank": "232",
        "state": "Illinois"
    },
    {
        "city": "Provo",
        "growth_from_2000_to_2013": "10.0%",
        "latitude": 40.2338438,
        "longitude": -111.6585337,
        "population": "116288",
        "rank": "233",
        "state": "Utah"
    },
    {
        "city": "El Monte",
        "growth_from_2000_to_2013": "-0.4%",
        "latitude": 34.0686206,
        "longitude": -118.0275667,
        "population": "115708",
        "rank": "234",
        "state": "California"
    },
    {
        "city": "Columbia",
        "growth_from_2000_to_2013": "34.0%",
        "latitude": 38.9517053,
        "longitude": -92.3340724,
        "population": "115276",
        "rank": "235",
        "state": "Missouri"
    },
    {
        "city": "Lansing",
        "growth_from_2000_to_2013": "-4.4%",
        "latitude": 42.732535,
        "longitude": -84.5555347,
        "population": "113972",
        "rank": "236",
        "state": "Michigan"
    },
    {
        "city": "Fargo",
        "growth_from_2000_to_2013": "24.9%",
        "latitude": 46.8771863,
        "longitude": -96.7898034,
        "population": "113658",
        "rank": "237",
        "state": "North Dakota"
    },
    {
        "city": "Downey",
        "growth_from_2000_to_2013": "5.3%",
        "latitude": 33.9401088,
        "longitude": -118.1331593,
        "population": "113242",
        "rank": "238",
        "state": "California"
    },
    {
        "city": "Costa Mesa",
        "growth_from_2000_to_2013": "2.4%",
        "latitude": 33.6411316,
        "longitude": -117.9186689,
        "population": "112174",
        "rank": "239",
        "state": "California"
    },
    {
        "city": "Wilmington",
        "growth_from_2000_to_2013": "24.8%",
        "latitude": 34.2257255,
        "longitude": -77.9447102,
        "population": "112067",
        "rank": "240",
        "state": "North Carolina"
    },
    {
        "city": "Arvada",
        "growth_from_2000_to_2013": "9.2%",
        "latitude": 39.8027644,
        "longitude": -105.0874842,
        "population": "111707",
        "rank": "241",
        "state": "Colorado"
    },
    {
        "city": "Inglewood",
        "growth_from_2000_to_2013": "-1.0%",
        "latitude": 33.9616801,
        "longitude": -118.3531311,
        "population": "111542",
        "rank": "242",
        "state": "California"
    },
    {
        "city": "Miami Gardens",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 25.9420377,
        "longitude": -80.2456045,
        "population": "111378",
        "rank": "243",
        "state": "Florida"
    },
    {
        "city": "Carlsbad",
        "growth_from_2000_to_2013": "39.7%",
        "latitude": 33.1580933,
        "longitude": -117.3505939,
        "population": "110972",
        "rank": "244",
        "state": "California"
    },
    {
        "city": "Westminster",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 39.8366528,
        "longitude": -105.0372046,
        "population": "110945",
        "rank": "245",
        "state": "Colorado"
    },
    {
        "city": "Rochester",
        "growth_from_2000_to_2013": "23.9%",
        "latitude": 44.0121221,
        "longitude": -92.4801989,
        "population": "110742",
        "rank": "246",
        "state": "Minnesota"
    },
    {
        "city": "Odessa",
        "growth_from_2000_to_2013": "22.3%",
        "latitude": 31.8456816,
        "longitude": -102.3676431,
        "population": "110720",
        "rank": "247",
        "state": "Texas"
    },
    {
        "city": "Manchester",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 42.9956397,
        "longitude": -71.4547891,
        "population": "110378",
        "rank": "248",
        "state": "New Hampshire"
    },
    {
        "city": "Elgin",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 42.0354084,
        "longitude": -88.2825668,
        "population": "110145",
        "rank": "249",
        "state": "Illinois"
    },
    {
        "city": "West Jordan",
        "growth_from_2000_to_2013": "38.4%",
        "latitude": 40.6096698,
        "longitude": -111.9391031,
        "population": "110077",
        "rank": "250",
        "state": "Utah"
    },
    {
        "city": "Round Rock",
        "growth_from_2000_to_2013": "81.0%",
        "latitude": 30.5082551,
        "longitude": -97.678896,
        "population": "109821",
        "rank": "251",
        "state": "Texas"
    },
    {
        "city": "Clearwater",
        "growth_from_2000_to_2013": "0.1%",
        "latitude": 27.9658533,
        "longitude": -82.8001026,
        "population": "109703",
        "rank": "252",
        "state": "Florida"
    },
    {
        "city": "Waterbury",
        "growth_from_2000_to_2013": "2.2%",
        "latitude": 41.5581525,
        "longitude": -73.0514965,
        "population": "109676",
        "rank": "253",
        "state": "Connecticut"
    },
    {
        "city": "Gresham",
        "growth_from_2000_to_2013": "20.7%",
        "latitude": 45.5001357,
        "longitude": -122.4302013,
        "population": "109397",
        "rank": "254",
        "state": "Oregon"
    },
    {
        "city": "Fairfield",
        "growth_from_2000_to_2013": "12.8%",
        "latitude": 38.24935809999999,
        "longitude": -122.0399663,
        "population": "109320",
        "rank": "255",
        "state": "California"
    },
    {
        "city": "Billings",
        "growth_from_2000_to_2013": "18.6%",
        "latitude": 45.7832856,
        "longitude": -108.5006904,
        "population": "109059",
        "rank": "256",
        "state": "Montana"
    },
    {
        "city": "Lowell",
        "growth_from_2000_to_2013": "3.4%",
        "latitude": 42.6334247,
        "longitude": -71.31617179999999,
        "population": "108861",
        "rank": "257",
        "state": "Massachusetts"
    },
    {
        "city": "San Buenaventura (Ventura)",
        "growth_from_2000_to_2013": "7.4%",
        "latitude": 34.274646,
        "longitude": -119.2290316,
        "population": "108817",
        "rank": "258",
        "state": "California"
    },
    {
        "city": "Pueblo",
        "growth_from_2000_to_2013": "5.9%",
        "latitude": 38.2544472,
        "longitude": -104.6091409,
        "population": "108249",
        "rank": "259",
        "state": "Colorado"
    },
    {
        "city": "High Point",
        "growth_from_2000_to_2013": "24.3%",
        "latitude": 35.9556923,
        "longitude": -80.0053176,
        "population": "107741",
        "rank": "260",
        "state": "North Carolina"
    },
    {
        "city": "West Covina",
        "growth_from_2000_to_2013": "2.3%",
        "latitude": 34.0686208,
        "longitude": -117.9389526,
        "population": "107740",
        "rank": "261",
        "state": "California"
    },
    {
        "city": "Richmond",
        "growth_from_2000_to_2013": "7.9%",
        "latitude": 37.9357576,
        "longitude": -122.3477486,
        "population": "107571",
        "rank": "262",
        "state": "California"
    },
    {
        "city": "Murrieta",
        "growth_from_2000_to_2013": "107.4%",
        "latitude": 33.5539143,
        "longitude": -117.2139232,
        "population": "107479",
        "rank": "263",
        "state": "California"
    },
    {
        "city": "Cambridge",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 42.3736158,
        "longitude": -71.10973349999999,
        "population": "107289",
        "rank": "264",
        "state": "Massachusetts"
    },
    {
        "city": "Antioch",
        "growth_from_2000_to_2013": "16.9%",
        "latitude": 38.0049214,
        "longitude": -121.805789,
        "population": "107100",
        "rank": "265",
        "state": "California"
    },
    {
        "city": "Temecula",
        "growth_from_2000_to_2013": "55.4%",
        "latitude": 33.4936391,
        "longitude": -117.1483648,
        "population": "106780",
        "rank": "266",
        "state": "California"
    },
    {
        "city": "Norwalk",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 33.9022367,
        "longitude": -118.081733,
        "population": "106589",
        "rank": "267",
        "state": "California"
    },
    {
        "city": "Centennial",
        "growth_from_2000_to_2013": "3.5%",
        "latitude": 39.5807452,
        "longitude": -104.8771726,
        "population": "106114",
        "rank": "268",
        "state": "Colorado"
    },
    {
        "city": "Everett",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 47.9789848,
        "longitude": -122.2020794,
        "population": "105370",
        "rank": "269",
        "state": "Washington"
    },
    {
        "city": "Palm Bay",
        "growth_from_2000_to_2013": "31.7%",
        "latitude": 28.0344621,
        "longitude": -80.5886646,
        "population": "104898",
        "rank": "270",
        "state": "Florida"
    },
    {
        "city": "Wichita Falls",
        "growth_from_2000_to_2013": "0.7%",
        "latitude": 33.9137085,
        "longitude": -98.4933873,
        "population": "104898",
        "rank": "271",
        "state": "Texas"
    },
    {
        "city": "Green Bay",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 44.51915899999999,
        "longitude": -88.019826,
        "population": "104779",
        "rank": "272",
        "state": "Wisconsin"
    },
    {
        "city": "Daly City",
        "growth_from_2000_to_2013": "1.0%",
        "latitude": 37.6879241,
        "longitude": -122.4702079,
        "population": "104739",
        "rank": "273",
        "state": "California"
    },
    {
        "city": "Burbank",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 34.1808392,
        "longitude": -118.3089661,
        "population": "104709",
        "rank": "274",
        "state": "California"
    },
    {
        "city": "Richardson",
        "growth_from_2000_to_2013": "13.2%",
        "latitude": 32.9483335,
        "longitude": -96.7298519,
        "population": "104475",
        "rank": "275",
        "state": "Texas"
    },
    {
        "city": "Pompano Beach",
        "growth_from_2000_to_2013": "4.0%",
        "latitude": 26.2378597,
        "longitude": -80.1247667,
        "population": "104410",
        "rank": "276",
        "state": "Florida"
    },
    {
        "city": "North Charleston",
        "growth_from_2000_to_2013": "27.4%",
        "latitude": 32.8546197,
        "longitude": -79.9748103,
        "population": "104054",
        "rank": "277",
        "state": "South Carolina"
    },
    {
        "city": "Broken Arrow",
        "growth_from_2000_to_2013": "28.2%",
        "latitude": 36.060949,
        "longitude": -95.7974526,
        "population": "103500",
        "rank": "278",
        "state": "Oklahoma"
    },
    {
        "city": "Boulder",
        "growth_from_2000_to_2013": "9.0%",
        "latitude": 40.0149856,
        "longitude": -105.2705456,
        "population": "103166",
        "rank": "279",
        "state": "Colorado"
    },
    {
        "city": "West Palm Beach",
        "growth_from_2000_to_2013": "23.5%",
        "latitude": 26.7153424,
        "longitude": -80.0533746,
        "population": "102436",
        "rank": "280",
        "state": "Florida"
    },
    {
        "city": "Santa Maria",
        "growth_from_2000_to_2013": "30.9%",
        "latitude": 34.9530337,
        "longitude": -120.4357191,
        "population": "102216",
        "rank": "281",
        "state": "California"
    },
    {
        "city": "El Cajon",
        "growth_from_2000_to_2013": "7.4%",
        "latitude": 32.7947731,
        "longitude": -116.9625269,
        "population": "102211",
        "rank": "282",
        "state": "California"
    },
    {
        "city": "Davenport",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 41.5236437,
        "longitude": -90.5776367,
        "population": "102157",
        "rank": "283",
        "state": "Iowa"
    },
    {
        "city": "Rialto",
        "growth_from_2000_to_2013": "9.8%",
        "latitude": 34.1064001,
        "longitude": -117.3703235,
        "population": "101910",
        "rank": "284",
        "state": "California"
    },
    {
        "city": "Las Cruces",
        "growth_from_2000_to_2013": "37.6%",
        "latitude": 32.3199396,
        "longitude": -106.7636538,
        "population": "101324",
        "rank": "285",
        "state": "New Mexico"
    },
    {
        "city": "San Mateo",
        "growth_from_2000_to_2013": "9.0%",
        "latitude": 37.5629917,
        "longitude": -122.3255254,
        "population": "101128",
        "rank": "286",
        "state": "California"
    },
    {
        "city": "Lewisville",
        "growth_from_2000_to_2013": "28.9%",
        "latitude": 33.046233,
        "longitude": -96.994174,
        "population": "101074",
        "rank": "287",
        "state": "Texas"
    },
    {
        "city": "South Bend",
        "growth_from_2000_to_2013": "-6.8%",
        "latitude": 41.6763545,
        "longitude": -86.25198979999999,
        "population": "100886",
        "rank": "288",
        "state": "Indiana"
    },
    {
        "city": "Lakeland",
        "growth_from_2000_to_2013": "18.3%",
        "latitude": 28.0394654,
        "longitude": -81.9498042,
        "population": "100710",
        "rank": "289",
        "state": "Florida"
    },
    {
        "city": "Erie",
        "growth_from_2000_to_2013": "-2.8%",
        "latitude": 42.12922409999999,
        "longitude": -80.085059,
        "population": "100671",
        "rank": "290",
        "state": "Pennsylvania"
    },
    {
        "city": "Tyler",
        "growth_from_2000_to_2013": "18.6%",
        "latitude": 32.3512601,
        "longitude": -95.30106239999999,
        "population": "100223",
        "rank": "291",
        "state": "Texas"
    },
    {
        "city": "Pearland",
        "growth_from_2000_to_2013": "117.2%",
        "latitude": 29.5635666,
        "longitude": -95.2860474,
        "population": "100065",
        "rank": "292",
        "state": "Texas"
    },
    {
        "city": "College Station",
        "growth_from_2000_to_2013": "45.2%",
        "latitude": 30.627977,
        "longitude": -96.3344068,
        "population": "100050",
        "rank": "293",
        "state": "Texas"
    },
    {
        "city": "Kenosha",
        "growth_from_2000_to_2013": "9.5%",
        "latitude": 42.5847425,
        "longitude": -87.82118539999999,
        "population": "99889",
        "rank": "294",
        "state": "Wisconsin"
    },
    {
        "city": "Sandy Springs",
        "growth_from_2000_to_2013": "17.4%",
        "latitude": 33.9304352,
        "longitude": -84.3733147,
        "population": "99770",
        "rank": "295",
        "state": "Georgia"
    },
    {
        "city": "Clovis",
        "growth_from_2000_to_2013": "42.6%",
        "latitude": 36.8252277,
        "longitude": -119.7029194,
        "population": "99769",
        "rank": "296",
        "state": "California"
    },
    {
        "city": "Flint",
        "growth_from_2000_to_2013": "-20.0%",
        "latitude": 43.0125274,
        "longitude": -83.6874562,
        "population": "99763",
        "rank": "297",
        "state": "Michigan"
    },
    {
        "city": "Roanoke",
        "growth_from_2000_to_2013": "3.8%",
        "latitude": 37.2709704,
        "longitude": -79.9414266,
        "population": "98465",
        "rank": "298",
        "state": "Virginia"
    },
    {
        "city": "Albany",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 42.6525793,
        "longitude": -73.7562317,
        "population": "98424",
        "rank": "299",
        "state": "New York"
    },
    {
        "city": "Jurupa Valley",
        "growth_from_2000_to_2013": "",
        "latitude": 33.9971974,
        "longitude": -117.4854802,
        "population": "98030",
        "rank": "300",
        "state": "California"
    },
    {
        "city": "Compton",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 33.8958492,
        "longitude": -118.2200712,
        "population": "97877",
        "rank": "301",
        "state": "California"
    },
    {
        "city": "San Angelo",
        "growth_from_2000_to_2013": "10.2%",
        "latitude": 31.4637723,
        "longitude": -100.4370375,
        "population": "97492",
        "rank": "302",
        "state": "Texas"
    },
    {
        "city": "Hillsboro",
        "growth_from_2000_to_2013": "36.4%",
        "latitude": 45.5228939,
        "longitude": -122.989827,
        "population": "97368",
        "rank": "303",
        "state": "Oregon"
    },
    {
        "city": "Lawton",
        "growth_from_2000_to_2013": "4.9%",
        "latitude": 34.6035669,
        "longitude": -98.39592909999999,
        "population": "97151",
        "rank": "304",
        "state": "Oklahoma"
    },
    {
        "city": "Renton",
        "growth_from_2000_to_2013": "88.4%",
        "latitude": 47.48287759999999,
        "longitude": -122.2170661,
        "population": "97003",
        "rank": "305",
        "state": "Washington"
    },
    {
        "city": "Vista",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 33.2000368,
        "longitude": -117.2425355,
        "population": "96929",
        "rank": "306",
        "state": "California"
    },
    {
        "city": "Davie",
        "growth_from_2000_to_2013": "17.7%",
        "latitude": 26.0764783,
        "longitude": -80.25211569999999,
        "population": "96830",
        "rank": "307",
        "state": "Florida"
    },
    {
        "city": "Greeley",
        "growth_from_2000_to_2013": "23.1%",
        "latitude": 40.4233142,
        "longitude": -104.7091322,
        "population": "96539",
        "rank": "308",
        "state": "Colorado"
    },
    {
        "city": "Mission Viejo",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 33.6000232,
        "longitude": -117.6719953,
        "population": "96346",
        "rank": "309",
        "state": "California"
    },
    {
        "city": "Portsmouth",
        "growth_from_2000_to_2013": "-4.2%",
        "latitude": 36.8354258,
        "longitude": -76.2982742,
        "population": "96205",
        "rank": "310",
        "state": "Virginia"
    },
    {
        "city": "Dearborn",
        "growth_from_2000_to_2013": "-2.0%",
        "latitude": 42.3222599,
        "longitude": -83.17631449999999,
        "population": "95884",
        "rank": "311",
        "state": "Michigan"
    },
    {
        "city": "South Gate",
        "growth_from_2000_to_2013": "-0.8%",
        "latitude": 33.954737,
        "longitude": -118.2120161,
        "population": "95677",
        "rank": "312",
        "state": "California"
    },
    {
        "city": "Tuscaloosa",
        "growth_from_2000_to_2013": "21.1%",
        "latitude": 33.2098407,
        "longitude": -87.56917349999999,
        "population": "95334",
        "rank": "313",
        "state": "Alabama"
    },
    {
        "city": "Livonia",
        "growth_from_2000_to_2013": "-5.4%",
        "latitude": 42.36837,
        "longitude": -83.35270969999999,
        "population": "95208",
        "rank": "314",
        "state": "Michigan"
    },
    {
        "city": "New Bedford",
        "growth_from_2000_to_2013": "1.2%",
        "latitude": 41.6362152,
        "longitude": -70.93420499999999,
        "population": "95078",
        "rank": "315",
        "state": "Massachusetts"
    },
    {
        "city": "Vacaville",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 38.3565773,
        "longitude": -121.9877444,
        "population": "94275",
        "rank": "316",
        "state": "California"
    },
    {
        "city": "Brockton",
        "growth_from_2000_to_2013": "-0.3%",
        "latitude": 42.0834335,
        "longitude": -71.0183787,
        "population": "94089",
        "rank": "317",
        "state": "Massachusetts"
    },
    {
        "city": "Roswell",
        "growth_from_2000_to_2013": "15.2%",
        "latitude": 34.0232431,
        "longitude": -84.3615555,
        "population": "94034",
        "rank": "318",
        "state": "Georgia"
    },
    {
        "city": "Beaverton",
        "growth_from_2000_to_2013": "17.0%",
        "latitude": 45.48706199999999,
        "longitude": -122.8037102,
        "population": "93542",
        "rank": "319",
        "state": "Oregon"
    },
    {
        "city": "Quincy",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 42.2528772,
        "longitude": -71.0022705,
        "population": "93494",
        "rank": "320",
        "state": "Massachusetts"
    },
    {
        "city": "Sparks",
        "growth_from_2000_to_2013": "39.4%",
        "latitude": 39.5349112,
        "longitude": -119.7526886,
        "population": "93282",
        "rank": "321",
        "state": "Nevada"
    },
    {
        "city": "Yakima",
        "growth_from_2000_to_2013": "11.7%",
        "latitude": 46.6020711,
        "longitude": -120.5058987,
        "population": "93257",
        "rank": "322",
        "state": "Washington"
    },
    {
        "city": "Lee''s Summit",
        "growth_from_2000_to_2013": "31.2%",
        "latitude": 38.9108408,
        "longitude": -94.3821724,
        "population": "93184",
        "rank": "323",
        "state": "Missouri"
    },
    {
        "city": "Federal Way",
        "growth_from_2000_to_2013": "8.8%",
        "latitude": 47.3223221,
        "longitude": -122.3126222,
        "population": "92734",
        "rank": "324",
        "state": "Washington"
    },
    {
        "city": "Carson",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 33.8316745,
        "longitude": -118.281693,
        "population": "92599",
        "rank": "325",
        "state": "California"
    },
    {
        "city": "Santa Monica",
        "growth_from_2000_to_2013": "9.6%",
        "latitude": 34.0194543,
        "longitude": -118.4911912,
        "population": "92472",
        "rank": "326",
        "state": "California"
    },
    {
        "city": "Hesperia",
        "growth_from_2000_to_2013": "46.1%",
        "latitude": 34.4263886,
        "longitude": -117.3008784,
        "population": "92147",
        "rank": "327",
        "state": "California"
    },
    {
        "city": "Allen",
        "growth_from_2000_to_2013": "104.0%",
        "latitude": 33.1031744,
        "longitude": -96.67055030000002,
        "population": "92020",
        "rank": "328",
        "state": "Texas"
    },
    {
        "city": "Rio Rancho",
        "growth_from_2000_to_2013": "74.4%",
        "latitude": 35.2327544,
        "longitude": -106.6630437,
        "population": "91956",
        "rank": "329",
        "state": "New Mexico"
    },
    {
        "city": "Yuma",
        "growth_from_2000_to_2013": "16.2%",
        "latitude": 32.6926512,
        "longitude": -114.6276916,
        "population": "91923",
        "rank": "330",
        "state": "Arizona"
    },
    {
        "city": "Westminster",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 33.7513419,
        "longitude": -117.9939921,
        "population": "91739",
        "rank": "331",
        "state": "California"
    },
    {
        "city": "Orem",
        "growth_from_2000_to_2013": "8.5%",
        "latitude": 40.2968979,
        "longitude": -111.6946475,
        "population": "91648",
        "rank": "332",
        "state": "Utah"
    },
    {
        "city": "Lynn",
        "growth_from_2000_to_2013": "2.6%",
        "latitude": 42.46676300000001,
        "longitude": -70.9494938,
        "population": "91589",
        "rank": "333",
        "state": "Massachusetts"
    },
    {
        "city": "Redding",
        "growth_from_2000_to_2013": "11.9%",
        "latitude": 40.5865396,
        "longitude": -122.3916754,
        "population": "91119",
        "rank": "334",
        "state": "California"
    },
    {
        "city": "Spokane Valley",
        "growth_from_2000_to_2013": "12.6%",
        "latitude": 47.6732281,
        "longitude": -117.2393748,
        "population": "91113",
        "rank": "335",
        "state": "Washington"
    },
    {
        "city": "Miami Beach",
        "growth_from_2000_to_2013": "3.3%",
        "latitude": 25.790654,
        "longitude": -80.1300455,
        "population": "91026",
        "rank": "336",
        "state": "Florida"
    },
    {
        "city": "League City",
        "growth_from_2000_to_2013": "98.3%",
        "latitude": 29.5074538,
        "longitude": -95.0949303,
        "population": "90983",
        "rank": "337",
        "state": "Texas"
    },
    {
        "city": "Lawrence",
        "growth_from_2000_to_2013": "12.7%",
        "latitude": 38.9716689,
        "longitude": -95.2352501,
        "population": "90811",
        "rank": "338",
        "state": "Kansas"
    },
    {
        "city": "Santa Barbara",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 34.4208305,
        "longitude": -119.6981901,
        "population": "90412",
        "rank": "339",
        "state": "California"
    },
    {
        "city": "Plantation",
        "growth_from_2000_to_2013": "8.6%",
        "latitude": 26.1275862,
        "longitude": -80.23310359999999,
        "population": "90268",
        "rank": "340",
        "state": "Florida"
    },
    {
        "city": "Sandy",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 40.5649781,
        "longitude": -111.8389726,
        "population": "90231",
        "rank": "341",
        "state": "Utah"
    },
    {
        "city": "Sunrise",
        "growth_from_2000_to_2013": "4.6%",
        "latitude": 26.1669711,
        "longitude": -80.25659499999999,
        "population": "90116",
        "rank": "342",
        "state": "Florida"
    },
    {
        "city": "Macon",
        "growth_from_2000_to_2013": "-7.3%",
        "latitude": 32.8406946,
        "longitude": -83.6324022,
        "population": "89981",
        "rank": "343",
        "state": "Georgia"
    },
    {
        "city": "Longmont",
        "growth_from_2000_to_2013": "24.4%",
        "latitude": 40.1672068,
        "longitude": -105.1019275,
        "population": "89919",
        "rank": "344",
        "state": "Colorado"
    },
    {
        "city": "Boca Raton",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 26.3683064,
        "longitude": -80.1289321,
        "population": "89407",
        "rank": "345",
        "state": "Florida"
    },
    {
        "city": "San Marcos",
        "growth_from_2000_to_2013": "60.0%",
        "latitude": 33.1433723,
        "longitude": -117.1661449,
        "population": "89387",
        "rank": "346",
        "state": "California"
    },
    {
        "city": "Greenville",
        "growth_from_2000_to_2013": "41.9%",
        "latitude": 35.612661,
        "longitude": -77.3663538,
        "population": "89130",
        "rank": "347",
        "state": "North Carolina"
    },
    {
        "city": "Waukegan",
        "growth_from_2000_to_2013": "0.5%",
        "latitude": 42.3636331,
        "longitude": -87.84479379999999,
        "population": "88826",
        "rank": "348",
        "state": "Illinois"
    },
    {
        "city": "Fall River",
        "growth_from_2000_to_2013": "-3.7%",
        "latitude": 41.7014912,
        "longitude": -71.1550451,
        "population": "88697",
        "rank": "349",
        "state": "Massachusetts"
    },
    {
        "city": "Chico",
        "growth_from_2000_to_2013": "14.2%",
        "latitude": 39.7284944,
        "longitude": -121.8374777,
        "population": "88077",
        "rank": "350",
        "state": "California"
    },
    {
        "city": "Newton",
        "growth_from_2000_to_2013": "4.9%",
        "latitude": 42.3370413,
        "longitude": -71.20922139999999,
        "population": "87971",
        "rank": "351",
        "state": "Massachusetts"
    },
    {
        "city": "San Leandro",
        "growth_from_2000_to_2013": "10.3%",
        "latitude": 37.7249296,
        "longitude": -122.1560768,
        "population": "87965",
        "rank": "352",
        "state": "California"
    },
    {
        "city": "Reading",
        "growth_from_2000_to_2013": "8.0%",
        "latitude": 40.3356483,
        "longitude": -75.9268747,
        "population": "87893",
        "rank": "353",
        "state": "Pennsylvania"
    },
    {
        "city": "Norwalk",
        "growth_from_2000_to_2013": "5.6%",
        "latitude": 41.11774399999999,
        "longitude": -73.4081575,
        "population": "87776",
        "rank": "354",
        "state": "Connecticut"
    },
    {
        "city": "Fort Smith",
        "growth_from_2000_to_2013": "8.6%",
        "latitude": 35.3859242,
        "longitude": -94.39854749999999,
        "population": "87650",
        "rank": "355",
        "state": "Arkansas"
    },
    {
        "city": "Newport Beach",
        "growth_from_2000_to_2013": "10.4%",
        "latitude": 33.6189101,
        "longitude": -117.9289469,
        "population": "87273",
        "rank": "356",
        "state": "California"
    },
    {
        "city": "Asheville",
        "growth_from_2000_to_2013": "19.6%",
        "latitude": 35.5950581,
        "longitude": -82.5514869,
        "population": "87236",
        "rank": "357",
        "state": "North Carolina"
    },
    {
        "city": "Nashua",
        "growth_from_2000_to_2013": "0.4%",
        "latitude": 42.7653662,
        "longitude": -71.46756599999999,
        "population": "87137",
        "rank": "358",
        "state": "New Hampshire"
    },
    {
        "city": "Edmond",
        "growth_from_2000_to_2013": "26.9%",
        "latitude": 35.6528323,
        "longitude": -97.47809540000002,
        "population": "87004",
        "rank": "359",
        "state": "Oklahoma"
    },
    {
        "city": "Whittier",
        "growth_from_2000_to_2013": "3.3%",
        "latitude": 33.9791793,
        "longitude": -118.032844,
        "population": "86635",
        "rank": "360",
        "state": "California"
    },
    {
        "city": "Nampa",
        "growth_from_2000_to_2013": "57.9%",
        "latitude": 43.5407172,
        "longitude": -116.5634624,
        "population": "86518",
        "rank": "361",
        "state": "Idaho"
    },
    {
        "city": "Bloomington",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 44.840798,
        "longitude": -93.2982799,
        "population": "86319",
        "rank": "362",
        "state": "Minnesota"
    },
    {
        "city": "Deltona",
        "growth_from_2000_to_2013": "23.1%",
        "latitude": 28.9005446,
        "longitude": -81.26367379999999,
        "population": "86290",
        "rank": "363",
        "state": "Florida"
    },
    {
        "city": "Hawthorne",
        "growth_from_2000_to_2013": "2.3%",
        "latitude": 33.9164032,
        "longitude": -118.3525748,
        "population": "86199",
        "rank": "364",
        "state": "California"
    },
    {
        "city": "Duluth",
        "growth_from_2000_to_2013": "-0.1%",
        "latitude": 46.78667189999999,
        "longitude": -92.1004852,
        "population": "86128",
        "rank": "365",
        "state": "Minnesota"
    },
    {
        "city": "Carmel",
        "growth_from_2000_to_2013": "60.4%",
        "latitude": 39.978371,
        "longitude": -86.1180435,
        "population": "85927",
        "rank": "366",
        "state": "Indiana"
    },
    {
        "city": "Suffolk",
        "growth_from_2000_to_2013": "33.5%",
        "latitude": 36.7282054,
        "longitude": -76.5835621,
        "population": "85728",
        "rank": "367",
        "state": "Virginia"
    },
    {
        "city": "Clifton",
        "growth_from_2000_to_2013": "7.9%",
        "latitude": 40.8584328,
        "longitude": -74.16375529999999,
        "population": "85390",
        "rank": "368",
        "state": "New Jersey"
    },
    {
        "city": "Citrus Heights",
        "growth_from_2000_to_2013": "-0.1%",
        "latitude": 38.7071247,
        "longitude": -121.2810611,
        "population": "85285",
        "rank": "369",
        "state": "California"
    },
    {
        "city": "Livermore",
        "growth_from_2000_to_2013": "15.1%",
        "latitude": 37.6818745,
        "longitude": -121.7680088,
        "population": "85156",
        "rank": "370",
        "state": "California"
    },
    {
        "city": "Tracy",
        "growth_from_2000_to_2013": "45.9%",
        "latitude": 37.7396513,
        "longitude": -121.4252227,
        "population": "84691",
        "rank": "371",
        "state": "California"
    },
    {
        "city": "Alhambra",
        "growth_from_2000_to_2013": "-0.7%",
        "latitude": 34.095287,
        "longitude": -118.1270146,
        "population": "84577",
        "rank": "372",
        "state": "California"
    },
    {
        "city": "Kirkland",
        "growth_from_2000_to_2013": "87.5%",
        "latitude": 47.6814875,
        "longitude": -122.2087353,
        "population": "84430",
        "rank": "373",
        "state": "Washington"
    },
    {
        "city": "Trenton",
        "growth_from_2000_to_2013": "-1.2%",
        "latitude": 40.2170534,
        "longitude": -74.7429384,
        "population": "84349",
        "rank": "374",
        "state": "New Jersey"
    },
    {
        "city": "Ogden",
        "growth_from_2000_to_2013": "8.6%",
        "latitude": 41.223,
        "longitude": -111.9738304,
        "population": "84249",
        "rank": "375",
        "state": "Utah"
    },
    {
        "city": "Hoover",
        "growth_from_2000_to_2013": "32.7%",
        "latitude": 33.4053867,
        "longitude": -86.8113781,
        "population": "84126",
        "rank": "376",
        "state": "Alabama"
    },
    {
        "city": "Cicero",
        "growth_from_2000_to_2013": "-1.6%",
        "latitude": 41.8455877,
        "longitude": -87.7539448,
        "population": "84103",
        "rank": "377",
        "state": "Illinois"
    },
    {
        "city": "Fishers",
        "growth_from_2000_to_2013": "114.8%",
        "latitude": 39.9567548,
        "longitude": -86.01335,
        "population": "83891",
        "rank": "378",
        "state": "Indiana"
    },
    {
        "city": "Sugar Land",
        "growth_from_2000_to_2013": "29.1%",
        "latitude": 29.6196787,
        "longitude": -95.6349463,
        "population": "83860",
        "rank": "379",
        "state": "Texas"
    },
    {
        "city": "Danbury",
        "growth_from_2000_to_2013": "11.4%",
        "latitude": 41.394817,
        "longitude": -73.4540111,
        "population": "83684",
        "rank": "380",
        "state": "Connecticut"
    },
    {
        "city": "Meridian",
        "growth_from_2000_to_2013": "127.6%",
        "latitude": 43.6121087,
        "longitude": -116.3915131,
        "population": "83596",
        "rank": "381",
        "state": "Idaho"
    },
    {
        "city": "Indio",
        "growth_from_2000_to_2013": "66.0%",
        "latitude": 33.7205771,
        "longitude": -116.2155619,
        "population": "83539",
        "rank": "382",
        "state": "California"
    },
    {
        "city": "Concord",
        "growth_from_2000_to_2013": "47.4%",
        "latitude": 35.4087517,
        "longitude": -80.579511,
        "population": "83506",
        "rank": "383",
        "state": "North Carolina"
    },
    {
        "city": "Menifee",
        "growth_from_2000_to_2013": "95.0%",
        "latitude": 33.6971468,
        "longitude": -117.185294,
        "population": "83447",
        "rank": "384",
        "state": "California"
    },
    {
        "city": "Champaign",
        "growth_from_2000_to_2013": "18.3%",
        "latitude": 40.1164204,
        "longitude": -88.2433829,
        "population": "83424",
        "rank": "385",
        "state": "Illinois"
    },
    {
        "city": "Buena Park",
        "growth_from_2000_to_2013": "6.1%",
        "latitude": 33.8675143,
        "longitude": -117.9981181,
        "population": "82882",
        "rank": "386",
        "state": "California"
    },
    {
        "city": "Troy",
        "growth_from_2000_to_2013": "2.2%",
        "latitude": 42.6064095,
        "longitude": -83.1497751,
        "population": "82821",
        "rank": "387",
        "state": "Michigan"
    },
    {
        "city": "O''Fallon",
        "growth_from_2000_to_2013": "62.6%",
        "latitude": 38.8106075,
        "longitude": -90.69984769999999,
        "population": "82809",
        "rank": "388",
        "state": "Missouri"
    },
    {
        "city": "Johns Creek",
        "growth_from_2000_to_2013": "36.5%",
        "latitude": 34.0289259,
        "longitude": -84.198579,
        "population": "82788",
        "rank": "389",
        "state": "Georgia"
    },
    {
        "city": "Bellingham",
        "growth_from_2000_to_2013": "21.8%",
        "latitude": 48.74908,
        "longitude": -122.4781473,
        "population": "82631",
        "rank": "390",
        "state": "Washington"
    },
    {
        "city": "Westland",
        "growth_from_2000_to_2013": "-4.7%",
        "latitude": 42.32420399999999,
        "longitude": -83.400211,
        "population": "82578",
        "rank": "391",
        "state": "Michigan"
    },
    {
        "city": "Bloomington",
        "growth_from_2000_to_2013": "16.1%",
        "latitude": 39.165325,
        "longitude": -86.52638569999999,
        "population": "82575",
        "rank": "392",
        "state": "Indiana"
    },
    {
        "city": "Sioux City",
        "growth_from_2000_to_2013": "-2.9%",
        "latitude": 42.4999942,
        "longitude": -96.40030689999999,
        "population": "82459",
        "rank": "393",
        "state": "Iowa"
    },
    {
        "city": "Warwick",
        "growth_from_2000_to_2013": "-4.6%",
        "latitude": 41.7001009,
        "longitude": -71.4161671,
        "population": "81971",
        "rank": "394",
        "state": "Rhode Island"
    },
    {
        "city": "Hemet",
        "growth_from_2000_to_2013": "37.6%",
        "latitude": 33.7475203,
        "longitude": -116.9719684,
        "population": "81750",
        "rank": "395",
        "state": "California"
    },
    {
        "city": "Longview",
        "growth_from_2000_to_2013": "11.6%",
        "latitude": 32.5007037,
        "longitude": -94.74048909999999,
        "population": "81443",
        "rank": "396",
        "state": "Texas"
    },
    {
        "city": "Farmington Hills",
        "growth_from_2000_to_2013": "-0.9%",
        "latitude": 42.4989936,
        "longitude": -83.3677168,
        "population": "81295",
        "rank": "397",
        "state": "Michigan"
    },
    {
        "city": "Bend",
        "growth_from_2000_to_2013": "54.3%",
        "latitude": 44.0581728,
        "longitude": -121.3153096,
        "population": "81236",
        "rank": "398",
        "state": "Oregon"
    },
    {
        "city": "Lakewood",
        "growth_from_2000_to_2013": "2.1%",
        "latitude": 33.8536269,
        "longitude": -118.1339563,
        "population": "81121",
        "rank": "399",
        "state": "California"
    },
    {
        "city": "Merced",
        "growth_from_2000_to_2013": "25.4%",
        "latitude": 37.3021632,
        "longitude": -120.4829677,
        "population": "81102",
        "rank": "400",
        "state": "California"
    },
    {
        "city": "Mission",
        "growth_from_2000_to_2013": "74.5%",
        "latitude": 26.2159066,
        "longitude": -98.32529319999999,
        "population": "81050",
        "rank": "401",
        "state": "Texas"
    },
    {
        "city": "Chino",
        "growth_from_2000_to_2013": "15.6%",
        "latitude": 34.0122346,
        "longitude": -117.688944,
        "population": "80988",
        "rank": "402",
        "state": "California"
    },
    {
        "city": "Redwood City",
        "growth_from_2000_to_2013": "7.1%",
        "latitude": 37.48521520000001,
        "longitude": -122.2363548,
        "population": "80872",
        "rank": "403",
        "state": "California"
    },
    {
        "city": "Edinburg",
        "growth_from_2000_to_2013": "65.1%",
        "latitude": 26.3017374,
        "longitude": -98.1633432,
        "population": "80836",
        "rank": "404",
        "state": "Texas"
    },
    {
        "city": "Cranston",
        "growth_from_2000_to_2013": "1.4%",
        "latitude": 41.7798226,
        "longitude": -71.4372796,
        "population": "80566",
        "rank": "405",
        "state": "Rhode Island"
    },
    {
        "city": "Parma",
        "growth_from_2000_to_2013": "-5.9%",
        "latitude": 41.4047742,
        "longitude": -81.7229086,
        "population": "80429",
        "rank": "406",
        "state": "Ohio"
    },
    {
        "city": "New Rochelle",
        "growth_from_2000_to_2013": "9.9%",
        "latitude": 40.9114882,
        "longitude": -73.7823549,
        "population": "79446",
        "rank": "407",
        "state": "New York"
    },
    {
        "city": "Lake Forest",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 33.6469661,
        "longitude": -117.689218,
        "population": "79312",
        "rank": "408",
        "state": "California"
    },
    {
        "city": "Napa",
        "growth_from_2000_to_2013": "8.4%",
        "latitude": 38.2975381,
        "longitude": -122.286865,
        "population": "79068",
        "rank": "409",
        "state": "California"
    },
    {
        "city": "Hammond",
        "growth_from_2000_to_2013": "-4.6%",
        "latitude": 41.5833688,
        "longitude": -87.5000412,
        "population": "78967",
        "rank": "410",
        "state": "Indiana"
    },
    {
        "city": "Fayetteville",
        "growth_from_2000_to_2013": "32.9%",
        "latitude": 36.0625795,
        "longitude": -94.1574263,
        "population": "78960",
        "rank": "411",
        "state": "Arkansas"
    },
    {
        "city": "Bloomington",
        "growth_from_2000_to_2013": "20.1%",
        "latitude": 40.4842027,
        "longitude": -88.99368729999999,
        "population": "78902",
        "rank": "412",
        "state": "Illinois"
    },
    {
        "city": "Avondale",
        "growth_from_2000_to_2013": "111.5%",
        "latitude": 33.4355977,
        "longitude": -112.3496021,
        "population": "78822",
        "rank": "413",
        "state": "Arizona"
    },
    {
        "city": "Somerville",
        "growth_from_2000_to_2013": "1.6%",
        "latitude": 42.3875968,
        "longitude": -71.0994968,
        "population": "78804",
        "rank": "414",
        "state": "Massachusetts"
    },
    {
        "city": "Palm Coast",
        "growth_from_2000_to_2013": "137.2%",
        "latitude": 29.5844524,
        "longitude": -81.20786989999999,
        "population": "78740",
        "rank": "415",
        "state": "Florida"
    },
    {
        "city": "Bryan",
        "growth_from_2000_to_2013": "19.3%",
        "latitude": 30.6743643,
        "longitude": -96.3699632,
        "population": "78709",
        "rank": "416",
        "state": "Texas"
    },
    {
        "city": "Gary",
        "growth_from_2000_to_2013": "-23.4%",
        "latitude": 41.5933696,
        "longitude": -87.3464271,
        "population": "78450",
        "rank": "417",
        "state": "Indiana"
    },
    {
        "city": "Largo",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 27.9094665,
        "longitude": -82.7873244,
        "population": "78409",
        "rank": "418",
        "state": "Florida"
    },
    {
        "city": "Brooklyn Park",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 45.0941315,
        "longitude": -93.3563405,
        "population": "78373",
        "rank": "419",
        "state": "Minnesota"
    },
    {
        "city": "Tustin",
        "growth_from_2000_to_2013": "15.6%",
        "latitude": 33.7458511,
        "longitude": -117.826166,
        "population": "78327",
        "rank": "420",
        "state": "California"
    },
    {
        "city": "Racine",
        "growth_from_2000_to_2013": "-4.4%",
        "latitude": 42.7261309,
        "longitude": -87.78285230000002,
        "population": "78199",
        "rank": "421",
        "state": "Wisconsin"
    },
    {
        "city": "Deerfield Beach",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 26.3184123,
        "longitude": -80.09976569999999,
        "population": "78041",
        "rank": "422",
        "state": "Florida"
    },
    {
        "city": "Lynchburg",
        "growth_from_2000_to_2013": "19.5%",
        "latitude": 37.4137536,
        "longitude": -79.14224639999999,
        "population": "78014",
        "rank": "423",
        "state": "Virginia"
    },
    {
        "city": "Mountain View",
        "growth_from_2000_to_2013": "10.1%",
        "latitude": 37.3860517,
        "longitude": -122.0838511,
        "population": "77846",
        "rank": "424",
        "state": "California"
    },
    {
        "city": "Medford",
        "growth_from_2000_to_2013": "17.1%",
        "latitude": 42.3265152,
        "longitude": -122.8755949,
        "population": "77677",
        "rank": "425",
        "state": "Oregon"
    },
    {
        "city": "Lawrence",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 42.7070354,
        "longitude": -71.1631137,
        "population": "77657",
        "rank": "426",
        "state": "Massachusetts"
    },
    {
        "city": "Bellflower",
        "growth_from_2000_to_2013": "6.3%",
        "latitude": 33.8816818,
        "longitude": -118.1170117,
        "population": "77593",
        "rank": "427",
        "state": "California"
    },
    {
        "city": "Melbourne",
        "growth_from_2000_to_2013": "5.9%",
        "latitude": 28.0836269,
        "longitude": -80.60810889999999,
        "population": "77508",
        "rank": "428",
        "state": "Florida"
    },
    {
        "city": "St. Joseph",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 39.7674578,
        "longitude": -94.84668099999999,
        "population": "77147",
        "rank": "429",
        "state": "Missouri"
    },
    {
        "city": "Camden",
        "growth_from_2000_to_2013": "-3.6%",
        "latitude": 39.9259463,
        "longitude": -75.1196199,
        "population": "76903",
        "rank": "430",
        "state": "New Jersey"
    },
    {
        "city": "St. George",
        "growth_from_2000_to_2013": "53.1%",
        "latitude": 37.0965278,
        "longitude": -113.5684164,
        "population": "76817",
        "rank": "431",
        "state": "Utah"
    },
    {
        "city": "Kennewick",
        "growth_from_2000_to_2013": "29.1%",
        "latitude": 46.2112458,
        "longitude": -119.1372338,
        "population": "76762",
        "rank": "432",
        "state": "Washington"
    },
    {
        "city": "Baldwin Park",
        "growth_from_2000_to_2013": "0.8%",
        "latitude": 34.0852868,
        "longitude": -117.9608978,
        "population": "76635",
        "rank": "433",
        "state": "California"
    },
    {
        "city": "Chino Hills",
        "growth_from_2000_to_2013": "13.6%",
        "latitude": 33.9898188,
        "longitude": -117.7325848,
        "population": "76572",
        "rank": "434",
        "state": "California"
    },
    {
        "city": "Alameda",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 37.7652065,
        "longitude": -122.2416355,
        "population": "76419",
        "rank": "435",
        "state": "California"
    },
    {
        "city": "Albany",
        "growth_from_2000_to_2013": "-0.6%",
        "latitude": 31.5785074,
        "longitude": -84.15574099999999,
        "population": "76185",
        "rank": "436",
        "state": "Georgia"
    },
    {
        "city": "Arlington Heights",
        "growth_from_2000_to_2013": "-0.6%",
        "latitude": 42.0883603,
        "longitude": -87.98062650000001,
        "population": "75994",
        "rank": "437",
        "state": "Illinois"
    },
    {
        "city": "Scranton",
        "growth_from_2000_to_2013": "0.0%",
        "latitude": 41.408969,
        "longitude": -75.66241219999999,
        "population": "75806",
        "rank": "438",
        "state": "Pennsylvania"
    },
    {
        "city": "Evanston",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 42.0450722,
        "longitude": -87.68769689999999,
        "population": "75570",
        "rank": "439",
        "state": "Illinois"
    },
    {
        "city": "Kalamazoo",
        "growth_from_2000_to_2013": "-1.9%",
        "latitude": 42.2917069,
        "longitude": -85.5872286,
        "population": "75548",
        "rank": "440",
        "state": "Michigan"
    },
    {
        "city": "Baytown",
        "growth_from_2000_to_2013": "13.1%",
        "latitude": 29.7355047,
        "longitude": -94.97742740000001,
        "population": "75418",
        "rank": "441",
        "state": "Texas"
    },
    {
        "city": "Upland",
        "growth_from_2000_to_2013": "9.5%",
        "latitude": 34.09751,
        "longitude": -117.6483876,
        "population": "75413",
        "rank": "442",
        "state": "California"
    },
    {
        "city": "Springdale",
        "growth_from_2000_to_2013": "57.1%",
        "latitude": 36.18674420000001,
        "longitude": -94.1288141,
        "population": "75229",
        "rank": "443",
        "state": "Arkansas"
    },
    {
        "city": "Bethlehem",
        "growth_from_2000_to_2013": "5.2%",
        "latitude": 40.6259316,
        "longitude": -75.37045789999999,
        "population": "75018",
        "rank": "444",
        "state": "Pennsylvania"
    },
    {
        "city": "Schaumburg",
        "growth_from_2000_to_2013": "-0.5%",
        "latitude": 42.0333607,
        "longitude": -88.0834059,
        "population": "74907",
        "rank": "445",
        "state": "Illinois"
    },
    {
        "city": "Mount Pleasant",
        "growth_from_2000_to_2013": "53.2%",
        "latitude": 32.8323225,
        "longitude": -79.82842579999999,
        "population": "74885",
        "rank": "446",
        "state": "South Carolina"
    },
    {
        "city": "Auburn",
        "growth_from_2000_to_2013": "34.9%",
        "latitude": 47.30732279999999,
        "longitude": -122.2284532,
        "population": "74860",
        "rank": "447",
        "state": "Washington"
    },
    {
        "city": "Decatur",
        "growth_from_2000_to_2013": "-8.7%",
        "latitude": 39.8403147,
        "longitude": -88.9548001,
        "population": "74710",
        "rank": "448",
        "state": "Illinois"
    },
    {
        "city": "San Ramon",
        "growth_from_2000_to_2013": "65.8%",
        "latitude": 37.7799273,
        "longitude": -121.9780153,
        "population": "74513",
        "rank": "449",
        "state": "California"
    },
    {
        "city": "Pleasanton",
        "growth_from_2000_to_2013": "15.2%",
        "latitude": 37.6624312,
        "longitude": -121.8746789,
        "population": "74110",
        "rank": "450",
        "state": "California"
    },
    {
        "city": "Wyoming",
        "growth_from_2000_to_2013": "6.5%",
        "latitude": 42.9133602,
        "longitude": -85.7053085,
        "population": "74100",
        "rank": "451",
        "state": "Michigan"
    },
    {
        "city": "Lake Charles",
        "growth_from_2000_to_2013": "3.0%",
        "latitude": 30.2265949,
        "longitude": -93.2173758,
        "population": "74024",
        "rank": "452",
        "state": "Louisiana"
    },
    {
        "city": "Plymouth",
        "growth_from_2000_to_2013": "12.0%",
        "latitude": 45.0105194,
        "longitude": -93.4555093,
        "population": "73987",
        "rank": "453",
        "state": "Minnesota"
    },
    {
        "city": "Bolingbrook",
        "growth_from_2000_to_2013": "29.7%",
        "latitude": 41.69864159999999,
        "longitude": -88.0683955,
        "population": "73936",
        "rank": "454",
        "state": "Illinois"
    },
    {
        "city": "Pharr",
        "growth_from_2000_to_2013": "55.7%",
        "latitude": 26.1947962,
        "longitude": -98.1836216,
        "population": "73790",
        "rank": "455",
        "state": "Texas"
    },
    {
        "city": "Appleton",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 44.2619309,
        "longitude": -88.41538469999999,
        "population": "73596",
        "rank": "456",
        "state": "Wisconsin"
    },
    {
        "city": "Gastonia",
        "growth_from_2000_to_2013": "8.2%",
        "latitude": 35.262082,
        "longitude": -81.18730049999999,
        "population": "73209",
        "rank": "457",
        "state": "North Carolina"
    },
    {
        "city": "Folsom",
        "growth_from_2000_to_2013": "38.6%",
        "latitude": 38.6779591,
        "longitude": -121.1760583,
        "population": "73098",
        "rank": "458",
        "state": "California"
    },
    {
        "city": "Southfield",
        "growth_from_2000_to_2013": "-6.7%",
        "latitude": 42.4733688,
        "longitude": -83.2218731,
        "population": "73006",
        "rank": "459",
        "state": "Michigan"
    },
    {
        "city": "Rochester Hills",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 42.65836609999999,
        "longitude": -83.1499322,
        "population": "72952",
        "rank": "460",
        "state": "Michigan"
    },
    {
        "city": "New Britain",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 41.6612104,
        "longitude": -72.7795419,
        "population": "72939",
        "rank": "461",
        "state": "Connecticut"
    },
    {
        "city": "Goodyear",
        "growth_from_2000_to_2013": "271.0%",
        "latitude": 33.4353394,
        "longitude": -112.3576567,
        "population": "72864",
        "rank": "462",
        "state": "Arizona"
    },
    {
        "city": "Canton",
        "growth_from_2000_to_2013": "-10.3%",
        "latitude": 40.79894729999999,
        "longitude": -81.378447,
        "population": "72535",
        "rank": "463",
        "state": "Ohio"
    },
    {
        "city": "Warner Robins",
        "growth_from_2000_to_2013": "45.7%",
        "latitude": 32.6130007,
        "longitude": -83.624201,
        "population": "72531",
        "rank": "464",
        "state": "Georgia"
    },
    {
        "city": "Union City",
        "growth_from_2000_to_2013": "7.4%",
        "latitude": 37.5933918,
        "longitude": -122.0438298,
        "population": "72528",
        "rank": "465",
        "state": "California"
    },
    {
        "city": "Perris",
        "growth_from_2000_to_2013": "98.7%",
        "latitude": 33.7825194,
        "longitude": -117.2286478,
        "population": "72326",
        "rank": "466",
        "state": "California"
    },
    {
        "city": "Manteca",
        "growth_from_2000_to_2013": "42.7%",
        "latitude": 37.7974273,
        "longitude": -121.2160526,
        "population": "71948",
        "rank": "467",
        "state": "California"
    },
    {
        "city": "Iowa City",
        "growth_from_2000_to_2013": "13.8%",
        "latitude": 41.6611277,
        "longitude": -91.5301683,
        "population": "71591",
        "rank": "468",
        "state": "Iowa"
    },
    {
        "city": "Jonesboro",
        "growth_from_2000_to_2013": "28.3%",
        "latitude": 35.84229670000001,
        "longitude": -90.704279,
        "population": "71551",
        "rank": "469",
        "state": "Arkansas"
    },
    {
        "city": "Wilmington",
        "growth_from_2000_to_2013": "-1.6%",
        "latitude": 39.7390721,
        "longitude": -75.5397878,
        "population": "71525",
        "rank": "470",
        "state": "Delaware"
    },
    {
        "city": "Lynwood",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 33.930293,
        "longitude": -118.2114603,
        "population": "71371",
        "rank": "471",
        "state": "California"
    },
    {
        "city": "Loveland",
        "growth_from_2000_to_2013": "37.4%",
        "latitude": 40.3977612,
        "longitude": -105.0749801,
        "population": "71334",
        "rank": "472",
        "state": "Colorado"
    },
    {
        "city": "Pawtucket",
        "growth_from_2000_to_2013": "-2.5%",
        "latitude": 41.878711,
        "longitude": -71.38255579999999,
        "population": "71172",
        "rank": "473",
        "state": "Rhode Island"
    },
    {
        "city": "Boynton Beach",
        "growth_from_2000_to_2013": "17.3%",
        "latitude": 26.5317866,
        "longitude": -80.0905465,
        "population": "71097",
        "rank": "474",
        "state": "Florida"
    },
    {
        "city": "Waukesha",
        "growth_from_2000_to_2013": "8.0%",
        "latitude": 43.0116784,
        "longitude": -88.2314813,
        "population": "71016",
        "rank": "475",
        "state": "Wisconsin"
    },
    {
        "city": "Gulfport",
        "growth_from_2000_to_2013": "-0.6%",
        "latitude": 30.3674198,
        "longitude": -89.0928155,
        "population": "71012",
        "rank": "476",
        "state": "Mississippi"
    },
    {
        "city": "Apple Valley",
        "growth_from_2000_to_2013": "29.9%",
        "latitude": 34.5008311,
        "longitude": -117.1858759,
        "population": "70924",
        "rank": "477",
        "state": "California"
    },
    {
        "city": "Passaic",
        "growth_from_2000_to_2013": "4.3%",
        "latitude": 40.8567662,
        "longitude": -74.1284764,
        "population": "70868",
        "rank": "478",
        "state": "New Jersey"
    },
    {
        "city": "Rapid City",
        "growth_from_2000_to_2013": "17.9%",
        "latitude": 44.0805434,
        "longitude": -103.2310149,
        "population": "70812",
        "rank": "479",
        "state": "South Dakota"
    },
    {
        "city": "Layton",
        "growth_from_2000_to_2013": "20.2%",
        "latitude": 41.0602216,
        "longitude": -111.9710529,
        "population": "70790",
        "rank": "480",
        "state": "Utah"
    },
    {
        "city": "Lafayette",
        "growth_from_2000_to_2013": "14.5%",
        "latitude": 40.4167022,
        "longitude": -86.87528689999999,
        "population": "70373",
        "rank": "481",
        "state": "Indiana"
    },
    {
        "city": "Turlock",
        "growth_from_2000_to_2013": "23.5%",
        "latitude": 37.4946568,
        "longitude": -120.8465941,
        "population": "70365",
        "rank": "482",
        "state": "California"
    },
    {
        "city": "Muncie",
        "growth_from_2000_to_2013": "-0.7%",
        "latitude": 40.1933767,
        "longitude": -85.3863599,
        "population": "70316",
        "rank": "483",
        "state": "Indiana"
    },
    {
        "city": "Temple",
        "growth_from_2000_to_2013": "27.1%",
        "latitude": 31.0982344,
        "longitude": -97.342782,
        "population": "70190",
        "rank": "484",
        "state": "Texas"
    },
    {
        "city": "Missouri City",
        "growth_from_2000_to_2013": "31.1%",
        "latitude": 29.6185669,
        "longitude": -95.5377215,
        "population": "70185",
        "rank": "485",
        "state": "Texas"
    },
    {
        "city": "Redlands",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 34.0555693,
        "longitude": -117.1825381,
        "population": "69999",
        "rank": "486",
        "state": "California"
    },
    {
        "city": "Santa Fe",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 35.6869752,
        "longitude": -105.937799,
        "population": "69976",
        "rank": "487",
        "state": "New Mexico"
    },
    {
        "city": "Lauderhill",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 26.1403635,
        "longitude": -80.2133808,
        "population": "69813",
        "rank": "488",
        "state": "Florida"
    },
    {
        "city": "Milpitas",
        "growth_from_2000_to_2013": "11.0%",
        "latitude": 37.4323341,
        "longitude": -121.8995741,
        "population": "69783",
        "rank": "489",
        "state": "California"
    },
    {
        "city": "Palatine",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 42.1103041,
        "longitude": -88.03424000000001,
        "population": "69350",
        "rank": "490",
        "state": "Illinois"
    },
    {
        "city": "Missoula",
        "growth_from_2000_to_2013": "19.7%",
        "latitude": 46.87871759999999,
        "longitude": -113.996586,
        "population": "69122",
        "rank": "491",
        "state": "Montana"
    },
    {
        "city": "Rock Hill",
        "growth_from_2000_to_2013": "36.0%",
        "latitude": 34.9248667,
        "longitude": -81.02507840000001,
        "population": "69103",
        "rank": "492",
        "state": "South Carolina"
    },
    {
        "city": "Jacksonville",
        "growth_from_2000_to_2013": "5.0%",
        "latitude": 34.7540524,
        "longitude": -77.4302414,
        "population": "69079",
        "rank": "493",
        "state": "North Carolina"
    },
    {
        "city": "Franklin",
        "growth_from_2000_to_2013": "48.5%",
        "latitude": 35.9250637,
        "longitude": -86.8688899,
        "population": "68886",
        "rank": "494",
        "state": "Tennessee"
    },
    {
        "city": "Flagstaff",
        "growth_from_2000_to_2013": "29.3%",
        "latitude": 35.1982836,
        "longitude": -111.651302,
        "population": "68667",
        "rank": "495",
        "state": "Arizona"
    },
    {
        "city": "Flower Mound",
        "growth_from_2000_to_2013": "32.5%",
        "latitude": 33.0145673,
        "longitude": -97.0969552,
        "population": "68609",
        "rank": "496",
        "state": "Texas"
    },
    {
        "city": "Weston",
        "growth_from_2000_to_2013": "34.5%",
        "latitude": 26.1003654,
        "longitude": -80.3997748,
        "population": "68388",
        "rank": "497",
        "state": "Florida"
    },
    {
        "city": "Waterloo",
        "growth_from_2000_to_2013": "-0.5%",
        "latitude": 42.492786,
        "longitude": -92.34257749999999,
        "population": "68366",
        "rank": "498",
        "state": "Iowa"
    },
    {
        "city": "Union City",
        "growth_from_2000_to_2013": "1.7%",
        "latitude": 40.6975898,
        "longitude": -74.26316349999999,
        "population": "68247",
        "rank": "499",
        "state": "New Jersey"
    },
    {
        "city": "Mount Vernon",
        "growth_from_2000_to_2013": "-0.2%",
        "latitude": 40.9125992,
        "longitude": -73.8370786,
        "population": "68224",
        "rank": "500",
        "state": "New York"
    },
    {
        "city": "Fort Myers",
        "growth_from_2000_to_2013": "31.2%",
        "latitude": 26.640628,
        "longitude": -81.8723084,
        "population": "68190",
        "rank": "501",
        "state": "Florida"
    },
    {
        "city": "Dothan",
        "growth_from_2000_to_2013": "16.6%",
        "latitude": 31.2232313,
        "longitude": -85.3904888,
        "population": "68001",
        "rank": "502",
        "state": "Alabama"
    },
    {
        "city": "Rancho Cordova",
        "growth_from_2000_to_2013": "26.4%",
        "latitude": 38.5890723,
        "longitude": -121.302728,
        "population": "67911",
        "rank": "503",
        "state": "California"
    },
    {
        "city": "Redondo Beach",
        "growth_from_2000_to_2013": "6.7%",
        "latitude": 33.8491816,
        "longitude": -118.3884078,
        "population": "67815",
        "rank": "504",
        "state": "California"
    },
    {
        "city": "Jackson",
        "growth_from_2000_to_2013": "12.9%",
        "latitude": 35.6145169,
        "longitude": -88.81394689999999,
        "population": "67685",
        "rank": "505",
        "state": "Tennessee"
    },
    {
        "city": "Pasco",
        "growth_from_2000_to_2013": "98.5%",
        "latitude": 46.2395793,
        "longitude": -119.1005657,
        "population": "67599",
        "rank": "506",
        "state": "Washington"
    },
    {
        "city": "St. Charles",
        "growth_from_2000_to_2013": "11.3%",
        "latitude": 38.7881062,
        "longitude": -90.4974359,
        "population": "67569",
        "rank": "507",
        "state": "Missouri"
    },
    {
        "city": "Eau Claire",
        "growth_from_2000_to_2013": "8.7%",
        "latitude": 44.811349,
        "longitude": -91.4984941,
        "population": "67545",
        "rank": "508",
        "state": "Wisconsin"
    },
    {
        "city": "North Richland Hills",
        "growth_from_2000_to_2013": "20.2%",
        "latitude": 32.8342952,
        "longitude": -97.2289029,
        "population": "67317",
        "rank": "509",
        "state": "Texas"
    },
    {
        "city": "Bismarck",
        "growth_from_2000_to_2013": "20.1%",
        "latitude": 46.8083268,
        "longitude": -100.7837392,
        "population": "67034",
        "rank": "510",
        "state": "North Dakota"
    },
    {
        "city": "Yorba Linda",
        "growth_from_2000_to_2013": "13.4%",
        "latitude": 33.8886259,
        "longitude": -117.8131125,
        "population": "67032",
        "rank": "511",
        "state": "California"
    },
    {
        "city": "Kenner",
        "growth_from_2000_to_2013": "-4.8%",
        "latitude": 29.9940924,
        "longitude": -90.2417434,
        "population": "66975",
        "rank": "512",
        "state": "Louisiana"
    },
    {
        "city": "Walnut Creek",
        "growth_from_2000_to_2013": "3.5%",
        "latitude": 37.9100783,
        "longitude": -122.0651819,
        "population": "66900",
        "rank": "513",
        "state": "California"
    },
    {
        "city": "Frederick",
        "growth_from_2000_to_2013": "25.9%",
        "latitude": 39.41426879999999,
        "longitude": -77.4105409,
        "population": "66893",
        "rank": "514",
        "state": "Maryland"
    },
    {
        "city": "Oshkosh",
        "growth_from_2000_to_2013": "5.3%",
        "latitude": 44.0247062,
        "longitude": -88.5426136,
        "population": "66778",
        "rank": "515",
        "state": "Wisconsin"
    },
    {
        "city": "Pittsburg",
        "growth_from_2000_to_2013": "16.6%",
        "latitude": 38.0279762,
        "longitude": -121.8846806,
        "population": "66695",
        "rank": "516",
        "state": "California"
    },
    {
        "city": "Palo Alto",
        "growth_from_2000_to_2013": "13.7%",
        "latitude": 37.4418834,
        "longitude": -122.1430195,
        "population": "66642",
        "rank": "517",
        "state": "California"
    },
    {
        "city": "Bossier City",
        "growth_from_2000_to_2013": "17.4%",
        "latitude": 32.5159852,
        "longitude": -93.7321228,
        "population": "66333",
        "rank": "518",
        "state": "Louisiana"
    },
    {
        "city": "Portland",
        "growth_from_2000_to_2013": "3.2%",
        "latitude": 43.66147100000001,
        "longitude": -70.2553259,
        "population": "66318",
        "rank": "519",
        "state": "Maine"
    },
    {
        "city": "St. Cloud",
        "growth_from_2000_to_2013": "10.9%",
        "latitude": 45.5579451,
        "longitude": -94.16324039999999,
        "population": "66297",
        "rank": "520",
        "state": "Minnesota"
    },
    {
        "city": "Davis",
        "growth_from_2000_to_2013": "11.9%",
        "latitude": 38.5449065,
        "longitude": -121.7405167,
        "population": "66205",
        "rank": "521",
        "state": "California"
    },
    {
        "city": "South San Francisco",
        "growth_from_2000_to_2013": "9.1%",
        "latitude": 37.654656,
        "longitude": -122.4077498,
        "population": "66174",
        "rank": "522",
        "state": "California"
    },
    {
        "city": "Camarillo",
        "growth_from_2000_to_2013": "14.9%",
        "latitude": 34.2163937,
        "longitude": -119.0376023,
        "population": "66086",
        "rank": "523",
        "state": "California"
    },
    {
        "city": "North Little Rock",
        "growth_from_2000_to_2013": "9.0%",
        "latitude": 34.769536,
        "longitude": -92.2670941,
        "population": "66075",
        "rank": "524",
        "state": "Arkansas"
    },
    {
        "city": "Schenectady",
        "growth_from_2000_to_2013": "6.7%",
        "latitude": 42.8142432,
        "longitude": -73.9395687,
        "population": "65902",
        "rank": "525",
        "state": "New York"
    },
    {
        "city": "Gaithersburg",
        "growth_from_2000_to_2013": "24.2%",
        "latitude": 39.1434406,
        "longitude": -77.2013705,
        "population": "65690",
        "rank": "526",
        "state": "Maryland"
    },
    {
        "city": "Harlingen",
        "growth_from_2000_to_2013": "11.6%",
        "latitude": 26.1906306,
        "longitude": -97.69610259999999,
        "population": "65665",
        "rank": "527",
        "state": "Texas"
    },
    {
        "city": "Woodbury",
        "growth_from_2000_to_2013": "39.8%",
        "latitude": 44.9238552,
        "longitude": -92.9593797,
        "population": "65656",
        "rank": "528",
        "state": "Minnesota"
    },
    {
        "city": "Eagan",
        "growth_from_2000_to_2013": "2.6%",
        "latitude": 44.8041322,
        "longitude": -93.1668858,
        "population": "65453",
        "rank": "529",
        "state": "Minnesota"
    },
    {
        "city": "Yuba City",
        "growth_from_2000_to_2013": "27.9%",
        "latitude": 39.1404477,
        "longitude": -121.6169108,
        "population": "65416",
        "rank": "530",
        "state": "California"
    },
    {
        "city": "Maple Grove",
        "growth_from_2000_to_2013": "27.3%",
        "latitude": 45.0724642,
        "longitude": -93.4557877,
        "population": "65415",
        "rank": "531",
        "state": "Minnesota"
    },
    {
        "city": "Youngstown",
        "growth_from_2000_to_2013": "-20.2%",
        "latitude": 41.0997803,
        "longitude": -80.6495194,
        "population": "65184",
        "rank": "532",
        "state": "Ohio"
    },
    {
        "city": "Skokie",
        "growth_from_2000_to_2013": "2.8%",
        "latitude": 42.0324025,
        "longitude": -87.7416246,
        "population": "65176",
        "rank": "533",
        "state": "Illinois"
    },
    {
        "city": "Kissimmee",
        "growth_from_2000_to_2013": "32.6%",
        "latitude": 28.2919557,
        "longitude": -81.40757099999999,
        "population": "65173",
        "rank": "534",
        "state": "Florida"
    },
    {
        "city": "Johnson City",
        "growth_from_2000_to_2013": "16.2%",
        "latitude": 36.3134397,
        "longitude": -82.3534727,
        "population": "65123",
        "rank": "535",
        "state": "Tennessee"
    },
    {
        "city": "Victoria",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 28.8052674,
        "longitude": -97.0035982,
        "population": "65098",
        "rank": "536",
        "state": "Texas"
    },
    {
        "city": "San Clemente",
        "growth_from_2000_to_2013": "28.6%",
        "latitude": 33.4269728,
        "longitude": -117.6119925,
        "population": "65040",
        "rank": "537",
        "state": "California"
    },
    {
        "city": "Bayonne",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 40.6687141,
        "longitude": -74.1143091,
        "population": "65028",
        "rank": "538",
        "state": "New Jersey"
    },
    {
        "city": "Laguna Niguel",
        "growth_from_2000_to_2013": "2.8%",
        "latitude": 33.5225261,
        "longitude": -117.7075526,
        "population": "64652",
        "rank": "539",
        "state": "California"
    },
    {
        "city": "East Orange",
        "growth_from_2000_to_2013": "-7.4%",
        "latitude": 40.767323,
        "longitude": -74.2048677,
        "population": "64544",
        "rank": "540",
        "state": "New Jersey"
    },
    {
        "city": "Shawnee",
        "growth_from_2000_to_2013": "32.2%",
        "latitude": 39.02284849999999,
        "longitude": -94.7151865,
        "population": "64323",
        "rank": "541",
        "state": "Kansas"
    },
    {
        "city": "Homestead",
        "growth_from_2000_to_2013": "100.7%",
        "latitude": 25.4687224,
        "longitude": -80.4775569,
        "population": "64079",
        "rank": "542",
        "state": "Florida"
    },
    {
        "city": "Rockville",
        "growth_from_2000_to_2013": "34.0%",
        "latitude": 39.0839973,
        "longitude": -77.1527578,
        "population": "64072",
        "rank": "544",
        "state": "Maryland"
    },
    {
        "city": "Delray Beach",
        "growth_from_2000_to_2013": "6.1%",
        "latitude": 26.4614625,
        "longitude": -80.0728201,
        "population": "64072",
        "rank": "543",
        "state": "Florida"
    },
    {
        "city": "Janesville",
        "growth_from_2000_to_2013": "5.6%",
        "latitude": 42.6827885,
        "longitude": -89.0187222,
        "population": "63820",
        "rank": "545",
        "state": "Wisconsin"
    },
    {
        "city": "Conway",
        "growth_from_2000_to_2013": "46.1%",
        "latitude": 35.0886963,
        "longitude": -92.4421011,
        "population": "63816",
        "rank": "546",
        "state": "Arkansas"
    },
    {
        "city": "Pico Rivera",
        "growth_from_2000_to_2013": "0.4%",
        "latitude": 33.9830688,
        "longitude": -118.096735,
        "population": "63771",
        "rank": "547",
        "state": "California"
    },
    {
        "city": "Lorain",
        "growth_from_2000_to_2013": "-7.2%",
        "latitude": 41.452819,
        "longitude": -82.1823746,
        "population": "63710",
        "rank": "548",
        "state": "Ohio"
    },
    {
        "city": "Montebello",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 34.0165053,
        "longitude": -118.1137535,
        "population": "63495",
        "rank": "549",
        "state": "California"
    },
    {
        "city": "Lodi",
        "growth_from_2000_to_2013": "10.1%",
        "latitude": 38.1341477,
        "longitude": -121.2722194,
        "population": "63338",
        "rank": "550",
        "state": "California"
    },
    {
        "city": "New Braunfels",
        "growth_from_2000_to_2013": "64.0%",
        "latitude": 29.7030024,
        "longitude": -98.1244531,
        "population": "63279",
        "rank": "551",
        "state": "Texas"
    },
    {
        "city": "Marysville",
        "growth_from_2000_to_2013": "115.7%",
        "latitude": 48.0517637,
        "longitude": -122.1770818,
        "population": "63269",
        "rank": "552",
        "state": "Washington"
    },
    {
        "city": "Tamarac",
        "growth_from_2000_to_2013": "12.9%",
        "latitude": 26.2128609,
        "longitude": -80.2497707,
        "population": "63155",
        "rank": "553",
        "state": "Florida"
    },
    {
        "city": "Madera",
        "growth_from_2000_to_2013": "44.4%",
        "latitude": 36.9613356,
        "longitude": -120.0607176,
        "population": "63105",
        "rank": "554",
        "state": "California"
    },
    {
        "city": "Conroe",
        "growth_from_2000_to_2013": "61.9%",
        "latitude": 30.3118769,
        "longitude": -95.45605119999999,
        "population": "63032",
        "rank": "555",
        "state": "Texas"
    },
    {
        "city": "Santa Cruz",
        "growth_from_2000_to_2013": "12.5%",
        "latitude": 36.9741171,
        "longitude": -122.0307963,
        "population": "62864",
        "rank": "556",
        "state": "California"
    },
    {
        "city": "Eden Prairie",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 44.8546856,
        "longitude": -93.47078599999999,
        "population": "62603",
        "rank": "557",
        "state": "Minnesota"
    },
    {
        "city": "Cheyenne",
        "growth_from_2000_to_2013": "16.9%",
        "latitude": 41.1399814,
        "longitude": -104.8202462,
        "population": "62448",
        "rank": "558",
        "state": "Wyoming"
    },
    {
        "city": "Daytona Beach",
        "growth_from_2000_to_2013": "-2.3%",
        "latitude": 29.2108147,
        "longitude": -81.0228331,
        "population": "62316",
        "rank": "559",
        "state": "Florida"
    },
    {
        "city": "Alpharetta",
        "growth_from_2000_to_2013": "33.6%",
        "latitude": 34.0753762,
        "longitude": -84.2940899,
        "population": "62298",
        "rank": "560",
        "state": "Georgia"
    },
    {
        "city": "Hamilton",
        "growth_from_2000_to_2013": "2.7%",
        "latitude": 39.3995008,
        "longitude": -84.5613355,
        "population": "62258",
        "rank": "561",
        "state": "Ohio"
    },
    {
        "city": "Waltham",
        "growth_from_2000_to_2013": "5.0%",
        "latitude": 42.3764852,
        "longitude": -71.2356113,
        "population": "62227",
        "rank": "562",
        "state": "Massachusetts"
    },
    {
        "city": "Coon Rapids",
        "growth_from_2000_to_2013": "0.6%",
        "latitude": 45.1732394,
        "longitude": -93.30300629999999,
        "population": "62103",
        "rank": "563",
        "state": "Minnesota"
    },
    {
        "city": "Haverhill",
        "growth_from_2000_to_2013": "5.0%",
        "latitude": 42.7762015,
        "longitude": -71.0772796,
        "population": "62088",
        "rank": "564",
        "state": "Massachusetts"
    },
    {
        "city": "Council Bluffs",
        "growth_from_2000_to_2013": "6.2%",
        "latitude": 41.2619444,
        "longitude": -95.8608333,
        "population": "61969",
        "rank": "565",
        "state": "Iowa"
    },
    {
        "city": "Taylor",
        "growth_from_2000_to_2013": "-6.3%",
        "latitude": 42.240872,
        "longitude": -83.2696509,
        "population": "61817",
        "rank": "566",
        "state": "Michigan"
    },
    {
        "city": "Utica",
        "growth_from_2000_to_2013": "2.2%",
        "latitude": 43.100903,
        "longitude": -75.232664,
        "population": "61808",
        "rank": "567",
        "state": "New York"
    },
    {
        "city": "Ames",
        "growth_from_2000_to_2013": "21.3%",
        "latitude": 42.034722,
        "longitude": -93.61999999999999,
        "population": "61792",
        "rank": "568",
        "state": "Iowa"
    },
    {
        "city": "La Habra",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 33.9319578,
        "longitude": -117.9461734,
        "population": "61653",
        "rank": "569",
        "state": "California"
    },
    {
        "city": "Encinitas",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 33.0369867,
        "longitude": -117.2919818,
        "population": "61588",
        "rank": "570",
        "state": "California"
    },
    {
        "city": "Bowling Green",
        "growth_from_2000_to_2013": "24.1%",
        "latitude": 36.9685219,
        "longitude": -86.4808043,
        "population": "61488",
        "rank": "571",
        "state": "Kentucky"
    },
    {
        "city": "Burnsville",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 44.7677424,
        "longitude": -93.27772259999999,
        "population": "61434",
        "rank": "572",
        "state": "Minnesota"
    },
    {
        "city": "Greenville",
        "growth_from_2000_to_2013": "8.2%",
        "latitude": 34.85261759999999,
        "longitude": -82.3940104,
        "population": "61397",
        "rank": "573",
        "state": "South Carolina"
    },
    {
        "city": "West Des Moines",
        "growth_from_2000_to_2013": "29.8%",
        "latitude": 41.5772115,
        "longitude": -93.711332,
        "population": "61255",
        "rank": "574",
        "state": "Iowa"
    },
    {
        "city": "Cedar Park",
        "growth_from_2000_to_2013": "134.3%",
        "latitude": 30.505198,
        "longitude": -97.8202888,
        "population": "61238",
        "rank": "575",
        "state": "Texas"
    },
    {
        "city": "Tulare",
        "growth_from_2000_to_2013": "33.3%",
        "latitude": 36.2077288,
        "longitude": -119.3473379,
        "population": "61170",
        "rank": "576",
        "state": "California"
    },
    {
        "city": "Monterey Park",
        "growth_from_2000_to_2013": "1.5%",
        "latitude": 34.0625106,
        "longitude": -118.1228476,
        "population": "61085",
        "rank": "577",
        "state": "California"
    },
    {
        "city": "Vineland",
        "growth_from_2000_to_2013": "9.3%",
        "latitude": 39.4863773,
        "longitude": -75.02596369999999,
        "population": "61050",
        "rank": "578",
        "state": "New Jersey"
    },
    {
        "city": "Terre Haute",
        "growth_from_2000_to_2013": "2.5%",
        "latitude": 39.4667034,
        "longitude": -87.41390919999999,
        "population": "61025",
        "rank": "579",
        "state": "Indiana"
    },
    {
        "city": "North Miami",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 25.8900949,
        "longitude": -80.1867138,
        "population": "61007",
        "rank": "580",
        "state": "Florida"
    },
    {
        "city": "Mansfield",
        "growth_from_2000_to_2013": "114.2%",
        "latitude": 32.5631924,
        "longitude": -97.1416768,
        "population": "60872",
        "rank": "581",
        "state": "Texas"
    },
    {
        "city": "West Allis",
        "growth_from_2000_to_2013": "-0.6%",
        "latitude": 43.0166806,
        "longitude": -88.0070315,
        "population": "60697",
        "rank": "582",
        "state": "Wisconsin"
    },
    {
        "city": "Bristol",
        "growth_from_2000_to_2013": "0.4%",
        "latitude": 41.67176480000001,
        "longitude": -72.9492703,
        "population": "60568",
        "rank": "583",
        "state": "Connecticut"
    },
    {
        "city": "Taylorsville",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 40.66772479999999,
        "longitude": -111.9388258,
        "population": "60519",
        "rank": "584",
        "state": "Utah"
    },
    {
        "city": "Malden",
        "growth_from_2000_to_2013": "7.4%",
        "latitude": 42.4250964,
        "longitude": -71.066163,
        "population": "60509",
        "rank": "585",
        "state": "Massachusetts"
    },
    {
        "city": "Meriden",
        "growth_from_2000_to_2013": "3.7%",
        "latitude": 41.5381535,
        "longitude": -72.80704349999999,
        "population": "60456",
        "rank": "586",
        "state": "Connecticut"
    },
    {
        "city": "Blaine",
        "growth_from_2000_to_2013": "32.8%",
        "latitude": 45.1607987,
        "longitude": -93.23494889999999,
        "population": "60407",
        "rank": "587",
        "state": "Minnesota"
    },
    {
        "city": "Wellington",
        "growth_from_2000_to_2013": "55.0%",
        "latitude": 26.6617635,
        "longitude": -80.2683571,
        "population": "60202",
        "rank": "588",
        "state": "Florida"
    },
    {
        "city": "Cupertino",
        "growth_from_2000_to_2013": "14.3%",
        "latitude": 37.3229978,
        "longitude": -122.0321823,
        "population": "60189",
        "rank": "589",
        "state": "California"
    },
    {
        "city": "Springfield",
        "growth_from_2000_to_2013": "12.4%",
        "latitude": 44.0462362,
        "longitude": -123.0220289,
        "population": "60177",
        "rank": "590",
        "state": "Oregon"
    },
    {
        "city": "Rogers",
        "growth_from_2000_to_2013": "50.6%",
        "latitude": 36.3320196,
        "longitude": -94.1185366,
        "population": "60112",
        "rank": "591",
        "state": "Arkansas"
    },
    {
        "city": "St. Clair Shores",
        "growth_from_2000_to_2013": "-4.6%",
        "latitude": 42.4974085,
        "longitude": -82.89636039999999,
        "population": "60070",
        "rank": "592",
        "state": "Michigan"
    },
    {
        "city": "Gardena",
        "growth_from_2000_to_2013": "3.4%",
        "latitude": 33.8883487,
        "longitude": -118.3089624,
        "population": "59957",
        "rank": "593",
        "state": "California"
    },
    {
        "city": "Pontiac",
        "growth_from_2000_to_2013": "-11.4%",
        "latitude": 42.6389216,
        "longitude": -83.29104679999999,
        "population": "59887",
        "rank": "594",
        "state": "Michigan"
    },
    {
        "city": "National City",
        "growth_from_2000_to_2013": "10.1%",
        "latitude": 32.6781085,
        "longitude": -117.0991967,
        "population": "59834",
        "rank": "595",
        "state": "California"
    },
    {
        "city": "Grand Junction",
        "growth_from_2000_to_2013": "30.9%",
        "latitude": 39.0638705,
        "longitude": -108.5506486,
        "population": "59778",
        "rank": "596",
        "state": "Colorado"
    },
    {
        "city": "Rocklin",
        "growth_from_2000_to_2013": "60.3%",
        "latitude": 38.7907339,
        "longitude": -121.2357828,
        "population": "59738",
        "rank": "597",
        "state": "California"
    },
    {
        "city": "Chapel Hill",
        "growth_from_2000_to_2013": "24.1%",
        "latitude": 35.9131996,
        "longitude": -79.0558445,
        "population": "59635",
        "rank": "598",
        "state": "North Carolina"
    },
    {
        "city": "Casper",
        "growth_from_2000_to_2013": "19.9%",
        "latitude": 42.866632,
        "longitude": -106.313081,
        "population": "59628",
        "rank": "599",
        "state": "Wyoming"
    },
    {
        "city": "Broomfield",
        "growth_from_2000_to_2013": "50.3%",
        "latitude": 39.9205411,
        "longitude": -105.0866504,
        "population": "59471",
        "rank": "600",
        "state": "Colorado"
    },
    {
        "city": "Petaluma",
        "growth_from_2000_to_2013": "8.4%",
        "latitude": 38.232417,
        "longitude": -122.6366524,
        "population": "59440",
        "rank": "601",
        "state": "California"
    },
    {
        "city": "South Jordan",
        "growth_from_2000_to_2013": "100.1%",
        "latitude": 40.5621704,
        "longitude": -111.929658,
        "population": "59366",
        "rank": "602",
        "state": "Utah"
    },
    {
        "city": "Springfield",
        "growth_from_2000_to_2013": "-9.8%",
        "latitude": 39.9242266,
        "longitude": -83.8088171,
        "population": "59357",
        "rank": "603",
        "state": "Ohio"
    },
    {
        "city": "Great Falls",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 47.4941836,
        "longitude": -111.2833449,
        "population": "59351",
        "rank": "604",
        "state": "Montana"
    },
    {
        "city": "Lancaster",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 40.0378755,
        "longitude": -76.3055144,
        "population": "59325",
        "rank": "605",
        "state": "Pennsylvania"
    },
    {
        "city": "North Port",
        "growth_from_2000_to_2013": "154.6%",
        "latitude": 27.044224,
        "longitude": -82.2359254,
        "population": "59212",
        "rank": "606",
        "state": "Florida"
    },
    {
        "city": "Lakewood",
        "growth_from_2000_to_2013": "1.1%",
        "latitude": 47.1717649,
        "longitude": -122.518458,
        "population": "59097",
        "rank": "607",
        "state": "Washington"
    },
    {
        "city": "Marietta",
        "growth_from_2000_to_2013": "-3.8%",
        "latitude": 33.95260200000001,
        "longitude": -84.5499327,
        "population": "59089",
        "rank": "608",
        "state": "Georgia"
    },
    {
        "city": "San Rafael",
        "growth_from_2000_to_2013": "5.0%",
        "latitude": 37.9735346,
        "longitude": -122.5310874,
        "population": "58994",
        "rank": "609",
        "state": "California"
    },
    {
        "city": "Royal Oak",
        "growth_from_2000_to_2013": "-1.7%",
        "latitude": 42.4894801,
        "longitude": -83.1446485,
        "population": "58946",
        "rank": "610",
        "state": "Michigan"
    },
    {
        "city": "Des Plaines",
        "growth_from_2000_to_2013": "3.2%",
        "latitude": 42.0333623,
        "longitude": -87.88339909999999,
        "population": "58918",
        "rank": "611",
        "state": "Illinois"
    },
    {
        "city": "Huntington Park",
        "growth_from_2000_to_2013": "-4.1%",
        "latitude": 33.9816812,
        "longitude": -118.2250725,
        "population": "58879",
        "rank": "612",
        "state": "California"
    },
    {
        "city": "La Mesa",
        "growth_from_2000_to_2013": "6.9%",
        "latitude": 32.7678287,
        "longitude": -117.0230839,
        "population": "58642",
        "rank": "613",
        "state": "California"
    },
    {
        "city": "Orland Park",
        "growth_from_2000_to_2013": "13.9%",
        "latitude": 41.6303103,
        "longitude": -87.85394250000002,
        "population": "58590",
        "rank": "614",
        "state": "Illinois"
    },
    {
        "city": "Auburn",
        "growth_from_2000_to_2013": "26.4%",
        "latitude": 32.6098566,
        "longitude": -85.48078249999999,
        "population": "58582",
        "rank": "615",
        "state": "Alabama"
    },
    {
        "city": "Lakeville",
        "growth_from_2000_to_2013": "34.3%",
        "latitude": 44.6496868,
        "longitude": -93.24271999999999,
        "population": "58562",
        "rank": "616",
        "state": "Minnesota"
    },
    {
        "city": "Owensboro",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 37.7719074,
        "longitude": -87.1111676,
        "population": "58416",
        "rank": "617",
        "state": "Kentucky"
    },
    {
        "city": "Moore",
        "growth_from_2000_to_2013": "41.5%",
        "latitude": 35.3395079,
        "longitude": -97.48670279999999,
        "population": "58414",
        "rank": "618",
        "state": "Oklahoma"
    },
    {
        "city": "Jupiter",
        "growth_from_2000_to_2013": "46.2%",
        "latitude": 26.9342246,
        "longitude": -80.0942087,
        "population": "58298",
        "rank": "619",
        "state": "Florida"
    },
    {
        "city": "Idaho Falls",
        "growth_from_2000_to_2013": "14.0%",
        "latitude": 43.49165139999999,
        "longitude": -112.0339645,
        "population": "58292",
        "rank": "620",
        "state": "Idaho"
    },
    {
        "city": "Dubuque",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 42.5005583,
        "longitude": -90.66457179999999,
        "population": "58253",
        "rank": "621",
        "state": "Iowa"
    },
    {
        "city": "Bartlett",
        "growth_from_2000_to_2013": "31.7%",
        "latitude": 35.2045328,
        "longitude": -89.8739753,
        "population": "58226",
        "rank": "622",
        "state": "Tennessee"
    },
    {
        "city": "Rowlett",
        "growth_from_2000_to_2013": "28.6%",
        "latitude": 32.9029017,
        "longitude": -96.56388,
        "population": "58043",
        "rank": "623",
        "state": "Texas"
    },
    {
        "city": "Novi",
        "growth_from_2000_to_2013": "22.0%",
        "latitude": 42.48059,
        "longitude": -83.4754913,
        "population": "57960",
        "rank": "624",
        "state": "Michigan"
    },
    {
        "city": "White Plains",
        "growth_from_2000_to_2013": "8.5%",
        "latitude": 41.03398620000001,
        "longitude": -73.7629097,
        "population": "57866",
        "rank": "625",
        "state": "New York"
    },
    {
        "city": "Arcadia",
        "growth_from_2000_to_2013": "8.3%",
        "latitude": 34.1397292,
        "longitude": -118.0353449,
        "population": "57639",
        "rank": "626",
        "state": "California"
    },
    {
        "city": "Redmond",
        "growth_from_2000_to_2013": "26.0%",
        "latitude": 47.6739881,
        "longitude": -122.121512,
        "population": "57530",
        "rank": "627",
        "state": "Washington"
    },
    {
        "city": "Lake Elsinore",
        "growth_from_2000_to_2013": "96.5%",
        "latitude": 33.6680772,
        "longitude": -117.3272615,
        "population": "57525",
        "rank": "628",
        "state": "California"
    },
    {
        "city": "Ocala",
        "growth_from_2000_to_2013": "20.8%",
        "latitude": 29.1871986,
        "longitude": -82.14009229999999,
        "population": "57468",
        "rank": "629",
        "state": "Florida"
    },
    {
        "city": "Tinley Park",
        "growth_from_2000_to_2013": "16.3%",
        "latitude": 41.5731442,
        "longitude": -87.7932939,
        "population": "57282",
        "rank": "630",
        "state": "Illinois"
    },
    {
        "city": "Port Orange",
        "growth_from_2000_to_2013": "22.8%",
        "latitude": 29.1383165,
        "longitude": -80.9956105,
        "population": "57203",
        "rank": "631",
        "state": "Florida"
    },
    {
        "city": "Medford",
        "growth_from_2000_to_2013": "2.7%",
        "latitude": 42.4184296,
        "longitude": -71.1061639,
        "population": "57170",
        "rank": "632",
        "state": "Massachusetts"
    },
    {
        "city": "Oak Lawn",
        "growth_from_2000_to_2013": "3.3%",
        "latitude": 41.719978,
        "longitude": -87.7479528,
        "population": "57073",
        "rank": "633",
        "state": "Illinois"
    },
    {
        "city": "Rocky Mount",
        "growth_from_2000_to_2013": "-3.1%",
        "latitude": 35.9382103,
        "longitude": -77.7905339,
        "population": "56954",
        "rank": "634",
        "state": "North Carolina"
    },
    {
        "city": "Kokomo",
        "growth_from_2000_to_2013": "21.3%",
        "latitude": 40.486427,
        "longitude": -86.13360329999999,
        "population": "56895",
        "rank": "635",
        "state": "Indiana"
    },
    {
        "city": "Coconut Creek",
        "growth_from_2000_to_2013": "28.4%",
        "latitude": 26.2517482,
        "longitude": -80.17893509999999,
        "population": "56792",
        "rank": "636",
        "state": "Florida"
    },
    {
        "city": "Bowie",
        "growth_from_2000_to_2013": "8.6%",
        "latitude": 39.0067768,
        "longitude": -76.77913649999999,
        "population": "56759",
        "rank": "637",
        "state": "Maryland"
    },
    {
        "city": "Berwyn",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 41.85058739999999,
        "longitude": -87.7936685,
        "population": "56758",
        "rank": "638",
        "state": "Illinois"
    },
    {
        "city": "Midwest City",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 35.4495065,
        "longitude": -97.3967019,
        "population": "56756",
        "rank": "639",
        "state": "Oklahoma"
    },
    {
        "city": "Fountain Valley",
        "growth_from_2000_to_2013": "3.0%",
        "latitude": 33.7091847,
        "longitude": -117.9536697,
        "population": "56707",
        "rank": "640",
        "state": "California"
    },
    {
        "city": "Buckeye",
        "growth_from_2000_to_2013": "480.9%",
        "latitude": 33.3703197,
        "longitude": -112.5837766,
        "population": "56683",
        "rank": "641",
        "state": "Arizona"
    },
    {
        "city": "Dearborn Heights",
        "growth_from_2000_to_2013": "-3.0%",
        "latitude": 42.3369816,
        "longitude": -83.27326269999999,
        "population": "56620",
        "rank": "642",
        "state": "Michigan"
    },
    {
        "city": "Woodland",
        "growth_from_2000_to_2013": "13.8%",
        "latitude": 38.67851570000001,
        "longitude": -121.7732971,
        "population": "56590",
        "rank": "643",
        "state": "California"
    },
    {
        "city": "Noblesville",
        "growth_from_2000_to_2013": "88.1%",
        "latitude": 40.0455917,
        "longitude": -86.0085955,
        "population": "56540",
        "rank": "644",
        "state": "Indiana"
    },
    {
        "city": "Valdosta",
        "growth_from_2000_to_2013": "22.3%",
        "latitude": 30.8327022,
        "longitude": -83.2784851,
        "population": "56481",
        "rank": "645",
        "state": "Georgia"
    },
    {
        "city": "Diamond Bar",
        "growth_from_2000_to_2013": "0.1%",
        "latitude": 34.0286226,
        "longitude": -117.8103367,
        "population": "56449",
        "rank": "646",
        "state": "California"
    },
    {
        "city": "Manhattan",
        "growth_from_2000_to_2013": "22.8%",
        "latitude": 39.18360819999999,
        "longitude": -96.57166939999999,
        "population": "56143",
        "rank": "647",
        "state": "Kansas"
    },
    {
        "city": "Santee",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 32.8383828,
        "longitude": -116.9739167,
        "population": "56105",
        "rank": "648",
        "state": "California"
    },
    {
        "city": "Taunton",
        "growth_from_2000_to_2013": "0.0%",
        "latitude": 41.900101,
        "longitude": -71.0897674,
        "population": "56069",
        "rank": "649",
        "state": "Massachusetts"
    },
    {
        "city": "Sanford",
        "growth_from_2000_to_2013": "42.8%",
        "latitude": 28.8028612,
        "longitude": -81.269453,
        "population": "56002",
        "rank": "650",
        "state": "Florida"
    },
    {
        "city": "Kettering",
        "growth_from_2000_to_2013": "-3.1%",
        "latitude": 39.68950359999999,
        "longitude": -84.1688274,
        "population": "55870",
        "rank": "651",
        "state": "Ohio"
    },
    {
        "city": "New Brunswick",
        "growth_from_2000_to_2013": "15.5%",
        "latitude": 40.4862157,
        "longitude": -74.4518188,
        "population": "55831",
        "rank": "652",
        "state": "New Jersey"
    },
    {
        "city": "Decatur",
        "growth_from_2000_to_2013": "3.1%",
        "latitude": 34.6059253,
        "longitude": -86.9833417,
        "population": "55816",
        "rank": "653",
        "state": "Alabama"
    },
    {
        "city": "Chicopee",
        "growth_from_2000_to_2013": "1.7%",
        "latitude": 42.1487043,
        "longitude": -72.6078672,
        "population": "55717",
        "rank": "654",
        "state": "Massachusetts"
    },
    {
        "city": "Anderson",
        "growth_from_2000_to_2013": "-6.6%",
        "latitude": 40.1053196,
        "longitude": -85.6802541,
        "population": "55670",
        "rank": "655",
        "state": "Indiana"
    },
    {
        "city": "Margate",
        "growth_from_2000_to_2013": "2.7%",
        "latitude": 26.2445263,
        "longitude": -80.206436,
        "population": "55456",
        "rank": "656",
        "state": "Florida"
    },
    {
        "city": "Weymouth Town",
        "growth_from_2000_to_2013": "",
        "latitude": 42.2180724,
        "longitude": -70.94103559999999,
        "population": "55419",
        "rank": "657",
        "state": "Massachusetts"
    },
    {
        "city": "Hempstead",
        "growth_from_2000_to_2013": "4.0%",
        "latitude": 40.7062128,
        "longitude": -73.6187397,
        "population": "55361",
        "rank": "658",
        "state": "New York"
    },
    {
        "city": "Corvallis",
        "growth_from_2000_to_2013": "11.8%",
        "latitude": 44.5645659,
        "longitude": -123.2620435,
        "population": "55298",
        "rank": "659",
        "state": "Oregon"
    },
    {
        "city": "Eastvale",
        "growth_from_2000_to_2013": "",
        "latitude": 33.952463,
        "longitude": -117.5848025,
        "population": "55191",
        "rank": "660",
        "state": "California"
    },
    {
        "city": "Porterville",
        "growth_from_2000_to_2013": "20.1%",
        "latitude": 36.06523,
        "longitude": -119.0167679,
        "population": "55174",
        "rank": "661",
        "state": "California"
    },
    {
        "city": "West Haven",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 41.2705484,
        "longitude": -72.9469711,
        "population": "55046",
        "rank": "662",
        "state": "Connecticut"
    },
    {
        "city": "Brentwood",
        "growth_from_2000_to_2013": "122.3%",
        "latitude": 37.931868,
        "longitude": -121.6957863,
        "population": "55000",
        "rank": "663",
        "state": "California"
    },
    {
        "city": "Paramount",
        "growth_from_2000_to_2013": "-0.7%",
        "latitude": 33.8894598,
        "longitude": -118.1597911,
        "population": "54980",
        "rank": "664",
        "state": "California"
    },
    {
        "city": "Grand Forks",
        "growth_from_2000_to_2013": "11.5%",
        "latitude": 47.9252568,
        "longitude": -97.0328547,
        "population": "54932",
        "rank": "665",
        "state": "North Dakota"
    },
    {
        "city": "Georgetown",
        "growth_from_2000_to_2013": "91.9%",
        "latitude": 30.6332618,
        "longitude": -97.6779842,
        "population": "54898",
        "rank": "666",
        "state": "Texas"
    },
    {
        "city": "St. Peters",
        "growth_from_2000_to_2013": "6.5%",
        "latitude": 38.7874699,
        "longitude": -90.6298922,
        "population": "54842",
        "rank": "667",
        "state": "Missouri"
    },
    {
        "city": "Shoreline",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 47.7556531,
        "longitude": -122.3415178,
        "population": "54790",
        "rank": "668",
        "state": "Washington"
    },
    {
        "city": "Mount Prospect",
        "growth_from_2000_to_2013": "-2.5%",
        "latitude": 42.0664167,
        "longitude": -87.9372908,
        "population": "54771",
        "rank": "669",
        "state": "Illinois"
    },
    {
        "city": "Hanford",
        "growth_from_2000_to_2013": "30.3%",
        "latitude": 36.3274502,
        "longitude": -119.6456844,
        "population": "54686",
        "rank": "670",
        "state": "California"
    },
    {
        "city": "Normal",
        "growth_from_2000_to_2013": "19.7%",
        "latitude": 40.5142026,
        "longitude": -88.9906312,
        "population": "54664",
        "rank": "671",
        "state": "Illinois"
    },
    {
        "city": "Rosemead",
        "growth_from_2000_to_2013": "1.7%",
        "latitude": 34.0805651,
        "longitude": -118.072846,
        "population": "54561",
        "rank": "672",
        "state": "California"
    },
    {
        "city": "Lehi",
        "growth_from_2000_to_2013": "176.3%",
        "latitude": 40.3916172,
        "longitude": -111.8507662,
        "population": "54382",
        "rank": "673",
        "state": "Utah"
    },
    {
        "city": "Pocatello",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 42.8713032,
        "longitude": -112.4455344,
        "population": "54350",
        "rank": "674",
        "state": "Idaho"
    },
    {
        "city": "Highland",
        "growth_from_2000_to_2013": "21.0%",
        "latitude": 34.1283442,
        "longitude": -117.2086513,
        "population": "54291",
        "rank": "675",
        "state": "California"
    },
    {
        "city": "Novato",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 38.1074198,
        "longitude": -122.5697032,
        "population": "54194",
        "rank": "676",
        "state": "California"
    },
    {
        "city": "Port Arthur",
        "growth_from_2000_to_2013": "-6.0%",
        "latitude": 29.8849504,
        "longitude": -93.93994699999999,
        "population": "54135",
        "rank": "677",
        "state": "Texas"
    },
    {
        "city": "Carson City",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 39.1637984,
        "longitude": -119.7674034,
        "population": "54080",
        "rank": "678",
        "state": "Nevada"
    },
    {
        "city": "San Marcos",
        "growth_from_2000_to_2013": "48.5%",
        "latitude": 29.8832749,
        "longitude": -97.9413941,
        "population": "54076",
        "rank": "679",
        "state": "Texas"
    },
    {
        "city": "Hendersonville",
        "growth_from_2000_to_2013": "31.7%",
        "latitude": 36.3047735,
        "longitude": -86.6199957,
        "population": "54068",
        "rank": "680",
        "state": "Tennessee"
    },
    {
        "city": "Elyria",
        "growth_from_2000_to_2013": "-3.7%",
        "latitude": 41.3683798,
        "longitude": -82.10764859999999,
        "population": "53956",
        "rank": "681",
        "state": "Ohio"
    },
    {
        "city": "Revere",
        "growth_from_2000_to_2013": "13.4%",
        "latitude": 42.4084302,
        "longitude": -71.0119948,
        "population": "53756",
        "rank": "682",
        "state": "Massachusetts"
    },
    {
        "city": "Pflugerville",
        "growth_from_2000_to_2013": "123.4%",
        "latitude": 30.4393696,
        "longitude": -97.62000429999999,
        "population": "53752",
        "rank": "683",
        "state": "Texas"
    },
    {
        "city": "Greenwood",
        "growth_from_2000_to_2013": "46.0%",
        "latitude": 39.6136578,
        "longitude": -86.10665259999999,
        "population": "53665",
        "rank": "684",
        "state": "Indiana"
    },
    {
        "city": "Bellevue",
        "growth_from_2000_to_2013": "20.5%",
        "latitude": 41.1543623,
        "longitude": -95.9145568,
        "population": "53663",
        "rank": "685",
        "state": "Nebraska"
    },
    {
        "city": "Wheaton",
        "growth_from_2000_to_2013": "-3.4%",
        "latitude": 41.8661403,
        "longitude": -88.1070127,
        "population": "53648",
        "rank": "686",
        "state": "Illinois"
    },
    {
        "city": "Smyrna",
        "growth_from_2000_to_2013": "20.0%",
        "latitude": 33.8839926,
        "longitude": -84.51437609999999,
        "population": "53438",
        "rank": "687",
        "state": "Georgia"
    },
    {
        "city": "Sarasota",
        "growth_from_2000_to_2013": "1.4%",
        "latitude": 27.3364347,
        "longitude": -82.53065269999999,
        "population": "53326",
        "rank": "688",
        "state": "Florida"
    },
    {
        "city": "Blue Springs",
        "growth_from_2000_to_2013": "9.9%",
        "latitude": 39.0169509,
        "longitude": -94.2816148,
        "population": "53294",
        "rank": "689",
        "state": "Missouri"
    },
    {
        "city": "Colton",
        "growth_from_2000_to_2013": "10.8%",
        "latitude": 34.0739016,
        "longitude": -117.3136547,
        "population": "53243",
        "rank": "690",
        "state": "California"
    },
    {
        "city": "Euless",
        "growth_from_2000_to_2013": "15.1%",
        "latitude": 32.8370727,
        "longitude": -97.08195409999999,
        "population": "53224",
        "rank": "691",
        "state": "Texas"
    },
    {
        "city": "Castle Rock",
        "growth_from_2000_to_2013": "153.5%",
        "latitude": 39.3722121,
        "longitude": -104.8560902,
        "population": "53063",
        "rank": "692",
        "state": "Colorado"
    },
    {
        "city": "Cathedral City",
        "growth_from_2000_to_2013": "23.2%",
        "latitude": 33.7805388,
        "longitude": -116.4668036,
        "population": "52977",
        "rank": "693",
        "state": "California"
    },
    {
        "city": "Kingsport",
        "growth_from_2000_to_2013": "16.7%",
        "latitude": 36.548434,
        "longitude": -82.5618186,
        "population": "52962",
        "rank": "694",
        "state": "Tennessee"
    },
    {
        "city": "Lake Havasu City",
        "growth_from_2000_to_2013": "24.6%",
        "latitude": 34.483901,
        "longitude": -114.3224548,
        "population": "52844",
        "rank": "695",
        "state": "Arizona"
    },
    {
        "city": "Pensacola",
        "growth_from_2000_to_2013": "-6.0%",
        "latitude": 30.42130899999999,
        "longitude": -87.2169149,
        "population": "52703",
        "rank": "696",
        "state": "Florida"
    },
    {
        "city": "Hoboken",
        "growth_from_2000_to_2013": "35.8%",
        "latitude": 40.7439905,
        "longitude": -74.0323626,
        "population": "52575",
        "rank": "697",
        "state": "New Jersey"
    },
    {
        "city": "Yucaipa",
        "growth_from_2000_to_2013": "26.8%",
        "latitude": 34.033625,
        "longitude": -117.0430865,
        "population": "52536",
        "rank": "698",
        "state": "California"
    },
    {
        "city": "Watsonville",
        "growth_from_2000_to_2013": "12.7%",
        "latitude": 36.910231,
        "longitude": -121.7568946,
        "population": "52477",
        "rank": "699",
        "state": "California"
    },
    {
        "city": "Richland",
        "growth_from_2000_to_2013": "34.6%",
        "latitude": 46.2856907,
        "longitude": -119.2844621,
        "population": "52413",
        "rank": "700",
        "state": "Washington"
    },
    {
        "city": "Delano",
        "growth_from_2000_to_2013": "31.8%",
        "latitude": 35.7688425,
        "longitude": -119.2470536,
        "population": "52403",
        "rank": "701",
        "state": "California"
    },
    {
        "city": "Hoffman Estates",
        "growth_from_2000_to_2013": "5.4%",
        "latitude": 42.0629915,
        "longitude": -88.12271989999999,
        "population": "52398",
        "rank": "702",
        "state": "Illinois"
    },
    {
        "city": "Florissant",
        "growth_from_2000_to_2013": "-2.8%",
        "latitude": 38.789217,
        "longitude": -90.322614,
        "population": "52363",
        "rank": "703",
        "state": "Missouri"
    },
    {
        "city": "Placentia",
        "growth_from_2000_to_2013": "11.8%",
        "latitude": 33.8722371,
        "longitude": -117.8703363,
        "population": "52206",
        "rank": "704",
        "state": "California"
    },
    {
        "city": "West New York",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 40.7878788,
        "longitude": -74.0143064,
        "population": "52122",
        "rank": "705",
        "state": "New Jersey"
    },
    {
        "city": "Dublin",
        "growth_from_2000_to_2013": "70.0%",
        "latitude": 37.7021521,
        "longitude": -121.9357918,
        "population": "52105",
        "rank": "706",
        "state": "California"
    },
    {
        "city": "Oak Park",
        "growth_from_2000_to_2013": "-0.8%",
        "latitude": 41.8850317,
        "longitude": -87.7845025,
        "population": "52066",
        "rank": "707",
        "state": "Illinois"
    },
    {
        "city": "Peabody",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 42.5278731,
        "longitude": -70.9286609,
        "population": "52044",
        "rank": "708",
        "state": "Massachusetts"
    },
    {
        "city": "Perth Amboy",
        "growth_from_2000_to_2013": "9.7%",
        "latitude": 40.5067723,
        "longitude": -74.2654234,
        "population": "51982",
        "rank": "709",
        "state": "New Jersey"
    },
    {
        "city": "Battle Creek",
        "growth_from_2000_to_2013": "-2.8%",
        "latitude": 42.3211522,
        "longitude": -85.17971419999999,
        "population": "51848",
        "rank": "710",
        "state": "Michigan"
    },
    {
        "city": "Bradenton",
        "growth_from_2000_to_2013": "3.4%",
        "latitude": 27.4989278,
        "longitude": -82.5748194,
        "population": "51763",
        "rank": "711",
        "state": "Florida"
    },
    {
        "city": "Gilroy",
        "growth_from_2000_to_2013": "23.9%",
        "latitude": 37.0057816,
        "longitude": -121.5682751,
        "population": "51701",
        "rank": "712",
        "state": "California"
    },
    {
        "city": "Milford",
        "growth_from_2000_to_2013": "1.8%",
        "latitude": 41.2306979,
        "longitude": -73.064036,
        "population": "51644",
        "rank": "713",
        "state": "Connecticut"
    },
    {
        "city": "Albany",
        "growth_from_2000_to_2013": "25.5%",
        "latitude": 44.6365107,
        "longitude": -123.1059282,
        "population": "51583",
        "rank": "714",
        "state": "Oregon"
    },
    {
        "city": "Ankeny",
        "growth_from_2000_to_2013": "86.9%",
        "latitude": 41.7317884,
        "longitude": -93.6001278,
        "population": "51567",
        "rank": "715",
        "state": "Iowa"
    },
    {
        "city": "La Crosse",
        "growth_from_2000_to_2013": "-0.8%",
        "latitude": 43.8013556,
        "longitude": -91.23958069999999,
        "population": "51522",
        "rank": "716",
        "state": "Wisconsin"
    },
    {
        "city": "Burlington",
        "growth_from_2000_to_2013": "12.1%",
        "latitude": 36.0956918,
        "longitude": -79.43779909999999,
        "population": "51510",
        "rank": "717",
        "state": "North Carolina"
    },
    {
        "city": "DeSoto",
        "growth_from_2000_to_2013": "36.0%",
        "latitude": 32.5896998,
        "longitude": -96.8570738,
        "population": "51483",
        "rank": "718",
        "state": "Texas"
    },
    {
        "city": "Harrisonburg",
        "growth_from_2000_to_2013": "27.1%",
        "latitude": 38.4495688,
        "longitude": -78.8689155,
        "population": "51395",
        "rank": "719",
        "state": "Virginia"
    },
    {
        "city": "Minnetonka",
        "growth_from_2000_to_2013": "0.4%",
        "latitude": 44.9211836,
        "longitude": -93.4687489,
        "population": "51368",
        "rank": "720",
        "state": "Minnesota"
    },
    {
        "city": "Elkhart",
        "growth_from_2000_to_2013": "-2.5%",
        "latitude": 41.6819935,
        "longitude": -85.9766671,
        "population": "51265",
        "rank": "721",
        "state": "Indiana"
    },
    {
        "city": "Lakewood",
        "growth_from_2000_to_2013": "-9.4%",
        "latitude": 41.4819932,
        "longitude": -81.7981908,
        "population": "51143",
        "rank": "722",
        "state": "Ohio"
    },
    {
        "city": "Glendora",
        "growth_from_2000_to_2013": "3.1%",
        "latitude": 34.1361187,
        "longitude": -117.865339,
        "population": "51074",
        "rank": "723",
        "state": "California"
    },
    {
        "city": "Southaven",
        "growth_from_2000_to_2013": "72.8%",
        "latitude": 34.9889818,
        "longitude": -90.0125913,
        "population": "50997",
        "rank": "724",
        "state": "Mississippi"
    },
    {
        "city": "Charleston",
        "growth_from_2000_to_2013": "-4.7%",
        "latitude": 38.3498195,
        "longitude": -81.6326234,
        "population": "50821",
        "rank": "725",
        "state": "West Virginia"
    },
    {
        "city": "Joplin",
        "growth_from_2000_to_2013": "11.2%",
        "latitude": 37.08422710000001,
        "longitude": -94.51328099999999,
        "population": "50789",
        "rank": "726",
        "state": "Missouri"
    },
    {
        "city": "Enid",
        "growth_from_2000_to_2013": "8.1%",
        "latitude": 36.3955891,
        "longitude": -97.8783911,
        "population": "50725",
        "rank": "727",
        "state": "Oklahoma"
    },
    {
        "city": "Palm Beach Gardens",
        "growth_from_2000_to_2013": "39.6%",
        "latitude": 26.8233946,
        "longitude": -80.13865469999999,
        "population": "50699",
        "rank": "728",
        "state": "Florida"
    },
    {
        "city": "Brookhaven",
        "growth_from_2000_to_2013": "",
        "latitude": 33.8651033,
        "longitude": -84.3365917,
        "population": "50603",
        "rank": "729",
        "state": "Georgia"
    },
    {
        "city": "Plainfield",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 40.6337136,
        "longitude": -74.4073736,
        "population": "50588",
        "rank": "730",
        "state": "New Jersey"
    },
    {
        "city": "Grand Island",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 40.9263957,
        "longitude": -98.3420118,
        "population": "50550",
        "rank": "731",
        "state": "Nebraska"
    },
    {
        "city": "Palm Desert",
        "growth_from_2000_to_2013": "13.2%",
        "latitude": 33.7222445,
        "longitude": -116.3744556,
        "population": "50508",
        "rank": "732",
        "state": "California"
    },
    {
        "city": "Huntersville",
        "growth_from_2000_to_2013": "92.9%",
        "latitude": 35.410694,
        "longitude": -80.84285040000002,
        "population": "50458",
        "rank": "733",
        "state": "North Carolina"
    },
    {
        "city": "Tigard",
        "growth_from_2000_to_2013": "17.8%",
        "latitude": 45.4312294,
        "longitude": -122.7714861,
        "population": "50444",
        "rank": "734",
        "state": "Oregon"
    },
    {
        "city": "Lenexa",
        "growth_from_2000_to_2013": "24.6%",
        "latitude": 38.9536174,
        "longitude": -94.73357089999999,
        "population": "50344",
        "rank": "735",
        "state": "Kansas"
    },
    {
        "city": "Saginaw",
        "growth_from_2000_to_2013": "-18.2%",
        "latitude": 43.4194699,
        "longitude": -83.9508068,
        "population": "50303",
        "rank": "736",
        "state": "Michigan"
    },
    {
        "city": "Kentwood",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 42.8694731,
        "longitude": -85.64474919999999,
        "population": "50233",
        "rank": "737",
        "state": "Michigan"
    },
    {
        "city": "Doral",
        "growth_from_2000_to_2013": "137.6%",
        "latitude": 25.8195424,
        "longitude": -80.3553302,
        "population": "50213",
        "rank": "738",
        "state": "Florida"
    },
    {
        "city": "Apple Valley",
        "growth_from_2000_to_2013": "9.2%",
        "latitude": 44.7319094,
        "longitude": -93.21772000000001,
        "population": "50201",
        "rank": "739",
        "state": "Minnesota"
    },
    {
        "city": "Grapevine",
        "growth_from_2000_to_2013": "17.6%",
        "latitude": 32.9342919,
        "longitude": -97.0780654,
        "population": "50195",
        "rank": "740",
        "state": "Texas"
    },
    {
        "city": "Aliso Viejo",
        "growth_from_2000_to_2013": "25.4%",
        "latitude": 33.5676842,
        "longitude": -117.7256083,
        "population": "50175",
        "rank": "741",
        "state": "California"
    },
    {
        "city": "Sammamish",
        "growth_from_2000_to_2013": "44.1%",
        "latitude": 47.61626829999999,
        "longitude": -122.0355736,
        "population": "50169",
        "rank": "742",
        "state": "Washington"
    },
    {
        "city": "Casa Grande",
        "growth_from_2000_to_2013": "86.0%",
        "latitude": 32.8795022,
        "longitude": -111.7573521,
        "population": "50111",
        "rank": "743",
        "state": "Arizona"
    },
    {
        "city": "Pinellas Park",
        "growth_from_2000_to_2013": "5.9%",
        "latitude": 27.8428025,
        "longitude": -82.6995443,
        "population": "49998",
        "rank": "744",
        "state": "Florida"
    },
    {
        "city": "Troy",
        "growth_from_2000_to_2013": "1.5%",
        "latitude": 42.7284117,
        "longitude": -73.69178509999999,
        "population": "49974",
        "rank": "745",
        "state": "New York"
    },
    {
        "city": "West Sacramento",
        "growth_from_2000_to_2013": "55.6%",
        "latitude": 38.5804609,
        "longitude": -121.530234,
        "population": "49891",
        "rank": "746",
        "state": "California"
    },
    {
        "city": "Burien",
        "growth_from_2000_to_2013": "56.7%",
        "latitude": 47.4703767,
        "longitude": -122.3467918,
        "population": "49858",
        "rank": "747",
        "state": "Washington"
    },
    {
        "city": "Commerce City",
        "growth_from_2000_to_2013": "135.4%",
        "latitude": 39.8083196,
        "longitude": -104.9338675,
        "population": "49799",
        "rank": "748",
        "state": "Colorado"
    },
    {
        "city": "Monroe",
        "growth_from_2000_to_2013": "-6.1%",
        "latitude": 32.5093109,
        "longitude": -92.1193012,
        "population": "49761",
        "rank": "749",
        "state": "Louisiana"
    },
    {
        "city": "Cerritos",
        "growth_from_2000_to_2013": "-3.6%",
        "latitude": 33.8583483,
        "longitude": -118.0647871,
        "population": "49707",
        "rank": "750",
        "state": "California"
    },
    {
        "city": "Downers Grove",
        "growth_from_2000_to_2013": "0.0%",
        "latitude": 41.8089191,
        "longitude": -88.01117459999999,
        "population": "49670",
        "rank": "751",
        "state": "Illinois"
    },
    {
        "city": "Coral Gables",
        "growth_from_2000_to_2013": "16.1%",
        "latitude": 25.72149,
        "longitude": -80.2683838,
        "population": "49631",
        "rank": "752",
        "state": "Florida"
    },
    {
        "city": "Wilson",
        "growth_from_2000_to_2013": "10.1%",
        "latitude": 35.7212689,
        "longitude": -77.9155395,
        "population": "49628",
        "rank": "753",
        "state": "North Carolina"
    },
    {
        "city": "Niagara Falls",
        "growth_from_2000_to_2013": "-10.8%",
        "latitude": 43.0962143,
        "longitude": -79.0377388,
        "population": "49468",
        "rank": "754",
        "state": "New York"
    },
    {
        "city": "Poway",
        "growth_from_2000_to_2013": "2.4%",
        "latitude": 32.9628232,
        "longitude": -117.0358646,
        "population": "49417",
        "rank": "755",
        "state": "California"
    },
    {
        "city": "Edina",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 44.8896866,
        "longitude": -93.3499489,
        "population": "49376",
        "rank": "756",
        "state": "Minnesota"
    },
    {
        "city": "Cuyahoga Falls",
        "growth_from_2000_to_2013": "-0.2%",
        "latitude": 41.1339449,
        "longitude": -81.48455849999999,
        "population": "49267",
        "rank": "757",
        "state": "Ohio"
    },
    {
        "city": "Rancho Santa Margarita",
        "growth_from_2000_to_2013": "4.6%",
        "latitude": 33.640855,
        "longitude": -117.603104,
        "population": "49228",
        "rank": "758",
        "state": "California"
    },
    {
        "city": "Harrisburg",
        "growth_from_2000_to_2013": "0.6%",
        "latitude": 40.2731911,
        "longitude": -76.8867008,
        "population": "49188",
        "rank": "759",
        "state": "Pennsylvania"
    },
    {
        "city": "Huntington",
        "growth_from_2000_to_2013": "-5.0%",
        "latitude": 38.4192496,
        "longitude": -82.44515400000002,
        "population": "49177",
        "rank": "760",
        "state": "West Virginia"
    },
    {
        "city": "La Mirada",
        "growth_from_2000_to_2013": "4.6%",
        "latitude": 33.9172357,
        "longitude": -118.0120086,
        "population": "49133",
        "rank": "761",
        "state": "California"
    },
    {
        "city": "Cypress",
        "growth_from_2000_to_2013": "5.3%",
        "latitude": 33.8169599,
        "longitude": -118.0372852,
        "population": "49087",
        "rank": "762",
        "state": "California"
    },
    {
        "city": "Caldwell",
        "growth_from_2000_to_2013": "77.1%",
        "latitude": 43.66293839999999,
        "longitude": -116.6873596,
        "population": "48957",
        "rank": "763",
        "state": "Idaho"
    },
    {
        "city": "Logan",
        "growth_from_2000_to_2013": "14.5%",
        "latitude": 41.7369803,
        "longitude": -111.8338359,
        "population": "48913",
        "rank": "764",
        "state": "Utah"
    },
    {
        "city": "Galveston",
        "growth_from_2000_to_2013": "-15.2%",
        "latitude": 29.3013479,
        "longitude": -94.7976958,
        "population": "48733",
        "rank": "765",
        "state": "Texas"
    },
    {
        "city": "Sheboygan",
        "growth_from_2000_to_2013": "-3.9%",
        "latitude": 43.7508284,
        "longitude": -87.71453,
        "population": "48725",
        "rank": "766",
        "state": "Wisconsin"
    },
    {
        "city": "Middletown",
        "growth_from_2000_to_2013": "-5.7%",
        "latitude": 39.5150576,
        "longitude": -84.39827629999999,
        "population": "48630",
        "rank": "767",
        "state": "Ohio"
    },
    {
        "city": "Murray",
        "growth_from_2000_to_2013": "6.6%",
        "latitude": 40.6668916,
        "longitude": -111.8879909,
        "population": "48612",
        "rank": "768",
        "state": "Utah"
    },
    {
        "city": "Roswell",
        "growth_from_2000_to_2013": "7.5%",
        "latitude": 33.3942655,
        "longitude": -104.5230242,
        "population": "48611",
        "rank": "769",
        "state": "New Mexico"
    },
    {
        "city": "Parker",
        "growth_from_2000_to_2013": "96.4%",
        "latitude": 39.5186002,
        "longitude": -104.7613633,
        "population": "48608",
        "rank": "770",
        "state": "Colorado"
    },
    {
        "city": "Bedford",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 32.844017,
        "longitude": -97.1430671,
        "population": "48592",
        "rank": "771",
        "state": "Texas"
    },
    {
        "city": "East Lansing",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 42.7369792,
        "longitude": -84.48386540000001,
        "population": "48554",
        "rank": "772",
        "state": "Michigan"
    },
    {
        "city": "Methuen",
        "growth_from_2000_to_2013": "10.3%",
        "latitude": 42.7262016,
        "longitude": -71.1908924,
        "population": "48514",
        "rank": "773",
        "state": "Massachusetts"
    },
    {
        "city": "Covina",
        "growth_from_2000_to_2013": "3.3%",
        "latitude": 34.0900091,
        "longitude": -117.8903397,
        "population": "48508",
        "rank": "774",
        "state": "California"
    },
    {
        "city": "Alexandria",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 31.3112936,
        "longitude": -92.4451371,
        "population": "48426",
        "rank": "775",
        "state": "Louisiana"
    },
    {
        "city": "Olympia",
        "growth_from_2000_to_2013": "12.1%",
        "latitude": 47.0378741,
        "longitude": -122.9006951,
        "population": "48338",
        "rank": "776",
        "state": "Washington"
    },
    {
        "city": "Euclid",
        "growth_from_2000_to_2013": "-8.4%",
        "latitude": 41.5931049,
        "longitude": -81.5267873,
        "population": "48139",
        "rank": "777",
        "state": "Ohio"
    },
    {
        "city": "Mishawaka",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 41.6619927,
        "longitude": -86.15861559999999,
        "population": "47989",
        "rank": "778",
        "state": "Indiana"
    },
    {
        "city": "Salina",
        "growth_from_2000_to_2013": "4.5%",
        "latitude": 38.8402805,
        "longitude": -97.61142369999999,
        "population": "47846",
        "rank": "779",
        "state": "Kansas"
    },
    {
        "city": "Azusa",
        "growth_from_2000_to_2013": "6.7%",
        "latitude": 34.1336186,
        "longitude": -117.9075627,
        "population": "47842",
        "rank": "780",
        "state": "California"
    },
    {
        "city": "Newark",
        "growth_from_2000_to_2013": "3.1%",
        "latitude": 40.0581205,
        "longitude": -82.4012642,
        "population": "47777",
        "rank": "781",
        "state": "Ohio"
    },
    {
        "city": "Chesterfield",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 38.6631083,
        "longitude": -90.5770675,
        "population": "47749",
        "rank": "782",
        "state": "Missouri"
    },
    {
        "city": "Leesburg",
        "growth_from_2000_to_2013": "66.0%",
        "latitude": 39.1156615,
        "longitude": -77.56360149999999,
        "population": "47673",
        "rank": "783",
        "state": "Virginia"
    },
    {
        "city": "Dunwoody",
        "growth_from_2000_to_2013": "",
        "latitude": 33.9462125,
        "longitude": -84.3346473,
        "population": "47591",
        "rank": "784",
        "state": "Georgia"
    },
    {
        "city": "Hattiesburg",
        "growth_from_2000_to_2013": "3.1%",
        "latitude": 31.3271189,
        "longitude": -89.29033919999999,
        "population": "47556",
        "rank": "785",
        "state": "Mississippi"
    },
    {
        "city": "Roseville",
        "growth_from_2000_to_2013": "-1.0%",
        "latitude": 42.4972583,
        "longitude": -82.9371409,
        "population": "47555",
        "rank": "786",
        "state": "Michigan"
    },
    {
        "city": "Bonita Springs",
        "growth_from_2000_to_2013": "43.8%",
        "latitude": 26.339806,
        "longitude": -81.7786972,
        "population": "47547",
        "rank": "787",
        "state": "Florida"
    },
    {
        "city": "Portage",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 42.2011538,
        "longitude": -85.5800022,
        "population": "47523",
        "rank": "788",
        "state": "Michigan"
    },
    {
        "city": "St. Louis Park",
        "growth_from_2000_to_2013": "7.3%",
        "latitude": 44.9597376,
        "longitude": -93.3702186,
        "population": "47411",
        "rank": "789",
        "state": "Minnesota"
    },
    {
        "city": "Collierville",
        "growth_from_2000_to_2013": "43.4%",
        "latitude": 35.042036,
        "longitude": -89.6645266,
        "population": "47333",
        "rank": "790",
        "state": "Tennessee"
    },
    {
        "city": "Middletown",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 41.5623209,
        "longitude": -72.6506488,
        "population": "47333",
        "rank": "791",
        "state": "Connecticut"
    },
    {
        "city": "Stillwater",
        "growth_from_2000_to_2013": "20.1%",
        "latitude": 36.1156071,
        "longitude": -97.0583681,
        "population": "47186",
        "rank": "792",
        "state": "Oklahoma"
    },
    {
        "city": "East Providence",
        "growth_from_2000_to_2013": "-3.3%",
        "latitude": 41.8137116,
        "longitude": -71.3700545,
        "population": "47149",
        "rank": "793",
        "state": "Rhode Island"
    },
    {
        "city": "Lawrence",
        "growth_from_2000_to_2013": "20.5%",
        "latitude": 39.8386516,
        "longitude": -86.0252612,
        "population": "47135",
        "rank": "794",
        "state": "Indiana"
    },
    {
        "city": "Wauwatosa",
        "growth_from_2000_to_2013": "0.0%",
        "latitude": 43.0494572,
        "longitude": -88.0075875,
        "population": "47134",
        "rank": "795",
        "state": "Wisconsin"
    },
    {
        "city": "Mentor",
        "growth_from_2000_to_2013": "-6.6%",
        "latitude": 41.6661573,
        "longitude": -81.339552,
        "population": "46979",
        "rank": "796",
        "state": "Ohio"
    },
    {
        "city": "Ceres",
        "growth_from_2000_to_2013": "34.0%",
        "latitude": 37.5949316,
        "longitude": -120.9577098,
        "population": "46714",
        "rank": "797",
        "state": "California"
    },
    {
        "city": "Cedar Hill",
        "growth_from_2000_to_2013": "42.4%",
        "latitude": 32.5884689,
        "longitude": -96.9561152,
        "population": "46663",
        "rank": "798",
        "state": "Texas"
    },
    {
        "city": "Mansfield",
        "growth_from_2000_to_2013": "-10.1%",
        "latitude": 40.75839,
        "longitude": -82.5154471,
        "population": "46454",
        "rank": "799",
        "state": "Ohio"
    },
    {
        "city": "Binghamton",
        "growth_from_2000_to_2013": "-1.7%",
        "latitude": 42.09868669999999,
        "longitude": -75.91797380000001,
        "population": "46444",
        "rank": "800",
        "state": "New York"
    },
    {
        "city": "Coeur d''Alene",
        "growth_from_2000_to_2013": "32.8%",
        "latitude": 47.6776832,
        "longitude": -116.7804664,
        "population": "46402",
        "rank": "801",
        "state": "Idaho"
    },
    {
        "city": "San Luis Obispo",
        "growth_from_2000_to_2013": "4.4%",
        "latitude": 35.2827524,
        "longitude": -120.6596156,
        "population": "46377",
        "rank": "802",
        "state": "California"
    },
    {
        "city": "Minot",
        "growth_from_2000_to_2013": "26.6%",
        "latitude": 48.2329668,
        "longitude": -101.2922906,
        "population": "46321",
        "rank": "803",
        "state": "North Dakota"
    },
    {
        "city": "Palm Springs",
        "growth_from_2000_to_2013": "7.7%",
        "latitude": 33.8302961,
        "longitude": -116.5452921,
        "population": "46281",
        "rank": "804",
        "state": "California"
    },
    {
        "city": "Pine Bluff",
        "growth_from_2000_to_2013": "-16.2%",
        "latitude": 34.2284312,
        "longitude": -92.00319549999999,
        "population": "46094",
        "rank": "805",
        "state": "Arkansas"
    },
    {
        "city": "Texas City",
        "growth_from_2000_to_2013": "10.3%",
        "latitude": 29.383845,
        "longitude": -94.9027002,
        "population": "46081",
        "rank": "806",
        "state": "Texas"
    },
    {
        "city": "Summerville",
        "growth_from_2000_to_2013": "62.9%",
        "latitude": 33.0185039,
        "longitude": -80.17564809999999,
        "population": "46074",
        "rank": "807",
        "state": "South Carolina"
    },
    {
        "city": "Twin Falls",
        "growth_from_2000_to_2013": "31.5%",
        "latitude": 42.5629668,
        "longitude": -114.4608711,
        "population": "45981",
        "rank": "808",
        "state": "Idaho"
    },
    {
        "city": "Jeffersonville",
        "growth_from_2000_to_2013": "53.3%",
        "latitude": 38.2775702,
        "longitude": -85.7371847,
        "population": "45929",
        "rank": "809",
        "state": "Indiana"
    },
    {
        "city": "San Jacinto",
        "growth_from_2000_to_2013": "91.8%",
        "latitude": 33.7839084,
        "longitude": -116.958635,
        "population": "45851",
        "rank": "810",
        "state": "California"
    },
    {
        "city": "Madison",
        "growth_from_2000_to_2013": "53.7%",
        "latitude": 34.6992579,
        "longitude": -86.74833180000002,
        "population": "45799",
        "rank": "811",
        "state": "Alabama"
    },
    {
        "city": "Altoona",
        "growth_from_2000_to_2013": "-7.3%",
        "latitude": 40.5186809,
        "longitude": -78.3947359,
        "population": "45796",
        "rank": "812",
        "state": "Pennsylvania"
    },
    {
        "city": "Columbus",
        "growth_from_2000_to_2013": "16.4%",
        "latitude": 39.2014404,
        "longitude": -85.9213796,
        "population": "45775",
        "rank": "813",
        "state": "Indiana"
    },
    {
        "city": "Beavercreek",
        "growth_from_2000_to_2013": "19.0%",
        "latitude": 39.7092262,
        "longitude": -84.06326849999999,
        "population": "45712",
        "rank": "814",
        "state": "Ohio"
    },
    {
        "city": "Apopka",
        "growth_from_2000_to_2013": "63.9%",
        "latitude": 28.6934076,
        "longitude": -81.5322149,
        "population": "45587",
        "rank": "815",
        "state": "Florida"
    },
    {
        "city": "Elmhurst",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 41.8994744,
        "longitude": -87.9403418,
        "population": "45556",
        "rank": "816",
        "state": "Illinois"
    },
    {
        "city": "Maricopa",
        "growth_from_2000_to_2013": "2503.4%",
        "latitude": 33.0581063,
        "longitude": -112.0476423,
        "population": "45508",
        "rank": "817",
        "state": "Arizona"
    },
    {
        "city": "Farmington",
        "growth_from_2000_to_2013": "18.1%",
        "latitude": 36.72805830000001,
        "longitude": -108.2186856,
        "population": "45426",
        "rank": "818",
        "state": "New Mexico"
    },
    {
        "city": "Glenview",
        "growth_from_2000_to_2013": "5.2%",
        "latitude": 42.0697509,
        "longitude": -87.7878408,
        "population": "45417",
        "rank": "819",
        "state": "Illinois"
    },
    {
        "city": "Cleveland Heights",
        "growth_from_2000_to_2013": "-10.3%",
        "latitude": 41.5200518,
        "longitude": -81.556235,
        "population": "45394",
        "rank": "820",
        "state": "Ohio"
    },
    {
        "city": "Draper",
        "growth_from_2000_to_2013": "77.4%",
        "latitude": 40.5246711,
        "longitude": -111.8638226,
        "population": "45285",
        "rank": "821",
        "state": "Utah"
    },
    {
        "city": "Lincoln",
        "growth_from_2000_to_2013": "285.2%",
        "latitude": 38.891565,
        "longitude": -121.2930079,
        "population": "45237",
        "rank": "822",
        "state": "California"
    },
    {
        "city": "Sierra Vista",
        "growth_from_2000_to_2013": "19.3%",
        "latitude": 31.5455001,
        "longitude": -110.2772856,
        "population": "45129",
        "rank": "823",
        "state": "Arizona"
    },
    {
        "city": "Lacey",
        "growth_from_2000_to_2013": "41.7%",
        "latitude": 47.03426289999999,
        "longitude": -122.8231915,
        "population": "44919",
        "rank": "824",
        "state": "Washington"
    },
    {
        "city": "Biloxi",
        "growth_from_2000_to_2013": "-11.5%",
        "latitude": 30.3960318,
        "longitude": -88.88530779999999,
        "population": "44820",
        "rank": "825",
        "state": "Mississippi"
    },
    {
        "city": "Strongsville",
        "growth_from_2000_to_2013": "1.9%",
        "latitude": 41.3144966,
        "longitude": -81.83569,
        "population": "44730",
        "rank": "826",
        "state": "Ohio"
    },
    {
        "city": "Barnstable Town",
        "growth_from_2000_to_2013": "-7.1%",
        "latitude": 41.7003208,
        "longitude": -70.3002024,
        "population": "44641",
        "rank": "827",
        "state": "Massachusetts"
    },
    {
        "city": "Wylie",
        "growth_from_2000_to_2013": "185.2%",
        "latitude": 33.0151201,
        "longitude": -96.5388789,
        "population": "44575",
        "rank": "828",
        "state": "Texas"
    },
    {
        "city": "Sayreville",
        "growth_from_2000_to_2013": "9.6%",
        "latitude": 40.45940210000001,
        "longitude": -74.360846,
        "population": "44412",
        "rank": "829",
        "state": "New Jersey"
    },
    {
        "city": "Kannapolis",
        "growth_from_2000_to_2013": "18.6%",
        "latitude": 35.4873613,
        "longitude": -80.6217341,
        "population": "44359",
        "rank": "830",
        "state": "North Carolina"
    },
    {
        "city": "Charlottesville",
        "growth_from_2000_to_2013": "10.5%",
        "latitude": 38.0293059,
        "longitude": -78.47667810000002,
        "population": "44349",
        "rank": "831",
        "state": "Virginia"
    },
    {
        "city": "Littleton",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 39.613321,
        "longitude": -105.0166498,
        "population": "44275",
        "rank": "832",
        "state": "Colorado"
    },
    {
        "city": "Titusville",
        "growth_from_2000_to_2013": "7.8%",
        "latitude": 28.6122187,
        "longitude": -80.8075537,
        "population": "44206",
        "rank": "833",
        "state": "Florida"
    },
    {
        "city": "Hackensack",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 40.8859325,
        "longitude": -74.0434736,
        "population": "44113",
        "rank": "834",
        "state": "New Jersey"
    },
    {
        "city": "Newark",
        "growth_from_2000_to_2013": "3.3%",
        "latitude": 37.5296593,
        "longitude": -122.0402399,
        "population": "44096",
        "rank": "835",
        "state": "California"
    },
    {
        "city": "Pittsfield",
        "growth_from_2000_to_2013": "-3.6%",
        "latitude": 42.4500845,
        "longitude": -73.2453824,
        "population": "44057",
        "rank": "836",
        "state": "Massachusetts"
    },
    {
        "city": "York",
        "growth_from_2000_to_2013": "6.4%",
        "latitude": 39.9625984,
        "longitude": -76.727745,
        "population": "43935",
        "rank": "837",
        "state": "Pennsylvania"
    },
    {
        "city": "Lombard",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 41.8800296,
        "longitude": -88.00784349999999,
        "population": "43907",
        "rank": "838",
        "state": "Illinois"
    },
    {
        "city": "Attleboro",
        "growth_from_2000_to_2013": "4.6%",
        "latitude": 41.94454409999999,
        "longitude": -71.2856082,
        "population": "43886",
        "rank": "839",
        "state": "Massachusetts"
    },
    {
        "city": "DeKalb",
        "growth_from_2000_to_2013": "11.8%",
        "latitude": 41.9294736,
        "longitude": -88.75036469999999,
        "population": "43849",
        "rank": "840",
        "state": "Illinois"
    },
    {
        "city": "Blacksburg",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 37.2295733,
        "longitude": -80.4139393,
        "population": "43609",
        "rank": "841",
        "state": "Virginia"
    },
    {
        "city": "Dublin",
        "growth_from_2000_to_2013": "37.6%",
        "latitude": 40.0992294,
        "longitude": -83.1140771,
        "population": "43607",
        "rank": "842",
        "state": "Ohio"
    },
    {
        "city": "Haltom City",
        "growth_from_2000_to_2013": "11.4%",
        "latitude": 32.7995738,
        "longitude": -97.26918169999999,
        "population": "43580",
        "rank": "843",
        "state": "Texas"
    },
    {
        "city": "Lompoc",
        "growth_from_2000_to_2013": "5.5%",
        "latitude": 34.6391501,
        "longitude": -120.4579409,
        "population": "43509",
        "rank": "844",
        "state": "California"
    },
    {
        "city": "El Centro",
        "growth_from_2000_to_2013": "13.7%",
        "latitude": 32.792,
        "longitude": -115.5630514,
        "population": "43363",
        "rank": "845",
        "state": "California"
    },
    {
        "city": "Danville",
        "growth_from_2000_to_2013": "3.7%",
        "latitude": 37.8215929,
        "longitude": -121.9999606,
        "population": "43341",
        "rank": "846",
        "state": "California"
    },
    {
        "city": "Jefferson City",
        "growth_from_2000_to_2013": "6.7%",
        "latitude": 38.57670170000001,
        "longitude": -92.1735164,
        "population": "43330",
        "rank": "847",
        "state": "Missouri"
    },
    {
        "city": "Cutler Bay",
        "growth_from_2000_to_2013": "42.9%",
        "latitude": 25.5808323,
        "longitude": -80.34685929999999,
        "population": "43328",
        "rank": "848",
        "state": "Florida"
    },
    {
        "city": "Oakland Park",
        "growth_from_2000_to_2013": "2.7%",
        "latitude": 26.1723065,
        "longitude": -80.1319893,
        "population": "43286",
        "rank": "849",
        "state": "Florida"
    },
    {
        "city": "North Miami Beach",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 25.9331488,
        "longitude": -80.1625463,
        "population": "43250",
        "rank": "850",
        "state": "Florida"
    },
    {
        "city": "Freeport",
        "growth_from_2000_to_2013": "-1.4%",
        "latitude": 40.6576022,
        "longitude": -73.58318349999999,
        "population": "43167",
        "rank": "851",
        "state": "New York"
    },
    {
        "city": "Moline",
        "growth_from_2000_to_2013": "-1.9%",
        "latitude": 41.5067003,
        "longitude": -90.51513419999999,
        "population": "43116",
        "rank": "852",
        "state": "Illinois"
    },
    {
        "city": "Coachella",
        "growth_from_2000_to_2013": "88.4%",
        "latitude": 33.6803003,
        "longitude": -116.173894,
        "population": "43092",
        "rank": "853",
        "state": "California"
    },
    {
        "city": "Fort Pierce",
        "growth_from_2000_to_2013": "6.9%",
        "latitude": 27.4467056,
        "longitude": -80.3256056,
        "population": "43074",
        "rank": "854",
        "state": "Florida"
    },
    {
        "city": "Smyrna",
        "growth_from_2000_to_2013": "54.9%",
        "latitude": 35.9828412,
        "longitude": -86.5186045,
        "population": "43060",
        "rank": "855",
        "state": "Tennessee"
    },
    {
        "city": "Bountiful",
        "growth_from_2000_to_2013": "3.9%",
        "latitude": 40.8893895,
        "longitude": -111.880771,
        "population": "43023",
        "rank": "856",
        "state": "Utah"
    },
    {
        "city": "Fond du Lac",
        "growth_from_2000_to_2013": "1.7%",
        "latitude": 43.7730448,
        "longitude": -88.4470508,
        "population": "42970",
        "rank": "857",
        "state": "Wisconsin"
    },
    {
        "city": "Everett",
        "growth_from_2000_to_2013": "12.1%",
        "latitude": 42.40843,
        "longitude": -71.0536625,
        "population": "42935",
        "rank": "858",
        "state": "Massachusetts"
    },
    {
        "city": "Danville",
        "growth_from_2000_to_2013": "-11.0%",
        "latitude": 36.5859718,
        "longitude": -79.39502279999999,
        "population": "42907",
        "rank": "859",
        "state": "Virginia"
    },
    {
        "city": "Keller",
        "growth_from_2000_to_2013": "53.3%",
        "latitude": 32.9341893,
        "longitude": -97.229298,
        "population": "42907",
        "rank": "860",
        "state": "Texas"
    },
    {
        "city": "Belleville",
        "growth_from_2000_to_2013": "1.2%",
        "latitude": 38.5200504,
        "longitude": -89.9839935,
        "population": "42895",
        "rank": "861",
        "state": "Illinois"
    },
    {
        "city": "Bell Gardens",
        "growth_from_2000_to_2013": "-2.7%",
        "latitude": 33.9652918,
        "longitude": -118.1514588,
        "population": "42889",
        "rank": "862",
        "state": "California"
    },
    {
        "city": "Cleveland",
        "growth_from_2000_to_2013": "14.1%",
        "latitude": 35.1595182,
        "longitude": -84.8766115,
        "population": "42774",
        "rank": "863",
        "state": "Tennessee"
    },
    {
        "city": "North Lauderdale",
        "growth_from_2000_to_2013": "10.8%",
        "latitude": 26.217305,
        "longitude": -80.2258811,
        "population": "42757",
        "rank": "864",
        "state": "Florida"
    },
    {
        "city": "Fairfield",
        "growth_from_2000_to_2013": "1.2%",
        "latitude": 39.3454673,
        "longitude": -84.5603187,
        "population": "42635",
        "rank": "865",
        "state": "Ohio"
    },
    {
        "city": "Salem",
        "growth_from_2000_to_2013": "5.1%",
        "latitude": 42.51954,
        "longitude": -70.8967155,
        "population": "42544",
        "rank": "866",
        "state": "Massachusetts"
    },
    {
        "city": "Rancho Palos Verdes",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 33.7444613,
        "longitude": -118.3870173,
        "population": "42448",
        "rank": "867",
        "state": "California"
    },
    {
        "city": "San Bruno",
        "growth_from_2000_to_2013": "5.6%",
        "latitude": 37.6304904,
        "longitude": -122.4110835,
        "population": "42443",
        "rank": "868",
        "state": "California"
    },
    {
        "city": "Concord",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 43.2081366,
        "longitude": -71.5375718,
        "population": "42419",
        "rank": "869",
        "state": "New Hampshire"
    },
    {
        "city": "Burlington",
        "growth_from_2000_to_2013": "6.1%",
        "latitude": 44.4758825,
        "longitude": -73.21207199999999,
        "population": "42284",
        "rank": "870",
        "state": "Vermont"
    },
    {
        "city": "Apex",
        "growth_from_2000_to_2013": "98.8%",
        "latitude": 35.732652,
        "longitude": -78.85028559999999,
        "population": "42214",
        "rank": "871",
        "state": "North Carolina"
    },
    {
        "city": "Midland",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 43.6155825,
        "longitude": -84.2472116,
        "population": "42181",
        "rank": "872",
        "state": "Michigan"
    },
    {
        "city": "Altamonte Springs",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 28.6611089,
        "longitude": -81.3656242,
        "population": "42150",
        "rank": "873",
        "state": "Florida"
    },
    {
        "city": "Hutchinson",
        "growth_from_2000_to_2013": "0.1%",
        "latitude": 38.0608445,
        "longitude": -97.92977429999999,
        "population": "41889",
        "rank": "874",
        "state": "Kansas"
    },
    {
        "city": "Buffalo Grove",
        "growth_from_2000_to_2013": "-3.4%",
        "latitude": 42.1662831,
        "longitude": -87.9631308,
        "population": "41778",
        "rank": "875",
        "state": "Illinois"
    },
    {
        "city": "Urbandale",
        "growth_from_2000_to_2013": "41.5%",
        "latitude": 41.6266555,
        "longitude": -93.71216559999999,
        "population": "41776",
        "rank": "876",
        "state": "Iowa"
    },
    {
        "city": "State College",
        "growth_from_2000_to_2013": "8.7%",
        "latitude": 40.7933949,
        "longitude": -77.8600012,
        "population": "41757",
        "rank": "877",
        "state": "Pennsylvania"
    },
    {
        "city": "Urbana",
        "growth_from_2000_to_2013": "10.3%",
        "latitude": 40.1105875,
        "longitude": -88.2072697,
        "population": "41752",
        "rank": "878",
        "state": "Illinois"
    },
    {
        "city": "Plainfield",
        "growth_from_2000_to_2013": "203.6%",
        "latitude": 41.632223,
        "longitude": -88.2120315,
        "population": "41734",
        "rank": "879",
        "state": "Illinois"
    },
    {
        "city": "Manassas",
        "growth_from_2000_to_2013": "19.5%",
        "latitude": 38.7509488,
        "longitude": -77.47526669999999,
        "population": "41705",
        "rank": "880",
        "state": "Virginia"
    },
    {
        "city": "Bartlett",
        "growth_from_2000_to_2013": "13.1%",
        "latitude": 41.9950276,
        "longitude": -88.1856301,
        "population": "41679",
        "rank": "881",
        "state": "Illinois"
    },
    {
        "city": "Kearny",
        "growth_from_2000_to_2013": "2.8%",
        "latitude": 40.7684342,
        "longitude": -74.1454214,
        "population": "41664",
        "rank": "882",
        "state": "New Jersey"
    },
    {
        "city": "Oro Valley",
        "growth_from_2000_to_2013": "27.0%",
        "latitude": 32.3909071,
        "longitude": -110.966488,
        "population": "41627",
        "rank": "883",
        "state": "Arizona"
    },
    {
        "city": "Findlay",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 41.04422,
        "longitude": -83.6499321,
        "population": "41512",
        "rank": "884",
        "state": "Ohio"
    },
    {
        "city": "Rohnert Park",
        "growth_from_2000_to_2013": "0.0%",
        "latitude": 38.3396367,
        "longitude": -122.7010984,
        "population": "41398",
        "rank": "885",
        "state": "California"
    },
    {
        "city": "Westfield",
        "growth_from_2000_to_2013": "3.0%",
        "latitude": 42.1250929,
        "longitude": -72.749538,
        "population": "41301",
        "rank": "887",
        "state": "Massachusetts"
    },
    {
        "city": "Linden",
        "growth_from_2000_to_2013": "4.7%",
        "latitude": 40.6220478,
        "longitude": -74.24459019999999,
        "population": "41301",
        "rank": "886",
        "state": "New Jersey"
    },
    {
        "city": "Sumter",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 33.9204354,
        "longitude": -80.3414693,
        "population": "41190",
        "rank": "888",
        "state": "South Carolina"
    },
    {
        "city": "Wilkes-Barre",
        "growth_from_2000_to_2013": "-4.3%",
        "latitude": 41.2459149,
        "longitude": -75.88130749999999,
        "population": "41108",
        "rank": "889",
        "state": "Pennsylvania"
    },
    {
        "city": "Woonsocket",
        "growth_from_2000_to_2013": "-5.2%",
        "latitude": 42.00287609999999,
        "longitude": -71.51478390000001,
        "population": "41026",
        "rank": "890",
        "state": "Rhode Island"
    },
    {
        "city": "Leominster",
        "growth_from_2000_to_2013": "-1.1%",
        "latitude": 42.5250906,
        "longitude": -71.759794,
        "population": "41002",
        "rank": "891",
        "state": "Massachusetts"
    },
    {
        "city": "Shelton",
        "growth_from_2000_to_2013": "7.3%",
        "latitude": 41.3164856,
        "longitude": -73.0931641,
        "population": "40999",
        "rank": "892",
        "state": "Connecticut"
    },
    {
        "city": "Brea",
        "growth_from_2000_to_2013": "15.2%",
        "latitude": 33.9166805,
        "longitude": -117.9000604,
        "population": "40963",
        "rank": "893",
        "state": "California"
    },
    {
        "city": "Covington",
        "growth_from_2000_to_2013": "-4.7%",
        "latitude": 39.0836712,
        "longitude": -84.5085536,
        "population": "40956",
        "rank": "894",
        "state": "Kentucky"
    },
    {
        "city": "Rockwall",
        "growth_from_2000_to_2013": "117.2%",
        "latitude": 32.93123360000001,
        "longitude": -96.4597089,
        "population": "40922",
        "rank": "895",
        "state": "Texas"
    },
    {
        "city": "Meridian",
        "growth_from_2000_to_2013": "-0.9%",
        "latitude": 32.3643098,
        "longitude": -88.703656,
        "population": "40921",
        "rank": "896",
        "state": "Mississippi"
    },
    {
        "city": "Riverton",
        "growth_from_2000_to_2013": "61.6%",
        "latitude": 40.521893,
        "longitude": -111.9391023,
        "population": "40921",
        "rank": "897",
        "state": "Utah"
    },
    {
        "city": "St. Cloud",
        "growth_from_2000_to_2013": "86.2%",
        "latitude": 28.2489016,
        "longitude": -81.2811801,
        "population": "40918",
        "rank": "898",
        "state": "Florida"
    },
    {
        "city": "Quincy",
        "growth_from_2000_to_2013": "0.5%",
        "latitude": 39.9356016,
        "longitude": -91.4098726,
        "population": "40915",
        "rank": "899",
        "state": "Illinois"
    },
    {
        "city": "Morgan Hill",
        "growth_from_2000_to_2013": "19.5%",
        "latitude": 37.1305012,
        "longitude": -121.6543901,
        "population": "40836",
        "rank": "900",
        "state": "California"
    },
    {
        "city": "Warren",
        "growth_from_2000_to_2013": "-15.2%",
        "latitude": 41.2375569,
        "longitude": -80.81841659999999,
        "population": "40768",
        "rank": "901",
        "state": "Ohio"
    },
    {
        "city": "Edmonds",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 47.8106521,
        "longitude": -122.3773552,
        "population": "40727",
        "rank": "902",
        "state": "Washington"
    },
    {
        "city": "Burleson",
        "growth_from_2000_to_2013": "85.3%",
        "latitude": 32.5420821,
        "longitude": -97.3208492,
        "population": "40714",
        "rank": "903",
        "state": "Texas"
    },
    {
        "city": "Beverly",
        "growth_from_2000_to_2013": "2.0%",
        "latitude": 42.5584283,
        "longitude": -70.880049,
        "population": "40664",
        "rank": "904",
        "state": "Massachusetts"
    },
    {
        "city": "Mankato",
        "growth_from_2000_to_2013": "24.7%",
        "latitude": 44.1635775,
        "longitude": -93.99939959999999,
        "population": "40641",
        "rank": "905",
        "state": "Minnesota"
    },
    {
        "city": "Hagerstown",
        "growth_from_2000_to_2013": "10.4%",
        "latitude": 39.6417629,
        "longitude": -77.71999319999999,
        "population": "40612",
        "rank": "906",
        "state": "Maryland"
    },
    {
        "city": "Prescott",
        "growth_from_2000_to_2013": "18.1%",
        "latitude": 34.5400242,
        "longitude": -112.4685025,
        "population": "40590",
        "rank": "907",
        "state": "Arizona"
    },
    {
        "city": "Campbell",
        "growth_from_2000_to_2013": "4.2%",
        "latitude": 37.2871651,
        "longitude": -121.9499568,
        "population": "40584",
        "rank": "908",
        "state": "California"
    },
    {
        "city": "Cedar Falls",
        "growth_from_2000_to_2013": "12.0%",
        "latitude": 42.5348993,
        "longitude": -92.4453161,
        "population": "40566",
        "rank": "909",
        "state": "Iowa"
    },
    {
        "city": "Beaumont",
        "growth_from_2000_to_2013": "254.5%",
        "latitude": 33.9294606,
        "longitude": -116.977248,
        "population": "40481",
        "rank": "910",
        "state": "California"
    },
    {
        "city": "La Puente",
        "growth_from_2000_to_2013": "-1.6%",
        "latitude": 34.0200114,
        "longitude": -117.9495083,
        "population": "40435",
        "rank": "911",
        "state": "California"
    },
    {
        "city": "Crystal Lake",
        "growth_from_2000_to_2013": "5.3%",
        "latitude": 42.2411344,
        "longitude": -88.31619649999999,
        "population": "40388",
        "rank": "912",
        "state": "Illinois"
    },
    {
        "city": "Fitchburg",
        "growth_from_2000_to_2013": "3.5%",
        "latitude": 42.5834228,
        "longitude": -71.8022955,
        "population": "40383",
        "rank": "913",
        "state": "Massachusetts"
    },
    {
        "city": "Carol Stream",
        "growth_from_2000_to_2013": "-0.2%",
        "latitude": 41.91252859999999,
        "longitude": -88.13479269999999,
        "population": "40379",
        "rank": "914",
        "state": "Illinois"
    },
    {
        "city": "Hickory",
        "growth_from_2000_to_2013": "7.0%",
        "latitude": 35.7344538,
        "longitude": -81.3444573,
        "population": "40361",
        "rank": "915",
        "state": "North Carolina"
    },
    {
        "city": "Streamwood",
        "growth_from_2000_to_2013": "10.1%",
        "latitude": 42.0255827,
        "longitude": -88.17840849999999,
        "population": "40351",
        "rank": "916",
        "state": "Illinois"
    },
    {
        "city": "Norwich",
        "growth_from_2000_to_2013": "11.6%",
        "latitude": 41.5242649,
        "longitude": -72.07591049999999,
        "population": "40347",
        "rank": "917",
        "state": "Connecticut"
    },
    {
        "city": "Coppell",
        "growth_from_2000_to_2013": "10.3%",
        "latitude": 32.9545687,
        "longitude": -97.01500779999999,
        "population": "40342",
        "rank": "918",
        "state": "Texas"
    },
    {
        "city": "San Gabriel",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 34.09611110000001,
        "longitude": -118.1058333,
        "population": "40275",
        "rank": "919",
        "state": "California"
    },
    {
        "city": "Holyoke",
        "growth_from_2000_to_2013": "0.9%",
        "latitude": 42.2042586,
        "longitude": -72.6162009,
        "population": "40249",
        "rank": "920",
        "state": "Massachusetts"
    },
    {
        "city": "Bentonville",
        "growth_from_2000_to_2013": "97.7%",
        "latitude": 36.3728538,
        "longitude": -94.2088172,
        "population": "40167",
        "rank": "921",
        "state": "Arkansas"
    },
    {
        "city": "Florence",
        "growth_from_2000_to_2013": "10.2%",
        "latitude": 34.79981,
        "longitude": -87.677251,
        "population": "40059",
        "rank": "922",
        "state": "Alabama"
    },
    {
        "city": "Peachtree Corners",
        "growth_from_2000_to_2013": "",
        "latitude": 33.9698929,
        "longitude": -84.2214551,
        "population": "40059",
        "rank": "923",
        "state": "Georgia"
    },
    {
        "city": "Brentwood",
        "growth_from_2000_to_2013": "51.9%",
        "latitude": 36.0331164,
        "longitude": -86.78277720000001,
        "population": "40021",
        "rank": "924",
        "state": "Tennessee"
    },
    {
        "city": "Bozeman",
        "growth_from_2000_to_2013": "41.9%",
        "latitude": 45.6769979,
        "longitude": -111.0429339,
        "population": "39860",
        "rank": "925",
        "state": "Montana"
    },
    {
        "city": "New Berlin",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 42.9764027,
        "longitude": -88.1084224,
        "population": "39834",
        "rank": "926",
        "state": "Wisconsin"
    },
    {
        "city": "Goose Creek",
        "growth_from_2000_to_2013": "26.1%",
        "latitude": 32.9810059,
        "longitude": -80.03258670000001,
        "population": "39823",
        "rank": "927",
        "state": "South Carolina"
    },
    {
        "city": "Huntsville",
        "growth_from_2000_to_2013": "13.2%",
        "latitude": 30.7235263,
        "longitude": -95.55077709999999,
        "population": "39795",
        "rank": "928",
        "state": "Texas"
    },
    {
        "city": "Prescott Valley",
        "growth_from_2000_to_2013": "62.9%",
        "latitude": 34.6100243,
        "longitude": -112.315721,
        "population": "39791",
        "rank": "929",
        "state": "Arizona"
    },
    {
        "city": "Maplewood",
        "growth_from_2000_to_2013": "12.3%",
        "latitude": 44.9530215,
        "longitude": -92.9952153,
        "population": "39765",
        "rank": "930",
        "state": "Minnesota"
    },
    {
        "city": "Romeoville",
        "growth_from_2000_to_2013": "79.5%",
        "latitude": 41.6475306,
        "longitude": -88.0895061,
        "population": "39650",
        "rank": "931",
        "state": "Illinois"
    },
    {
        "city": "Duncanville",
        "growth_from_2000_to_2013": "9.7%",
        "latitude": 32.6518004,
        "longitude": -96.9083366,
        "population": "39605",
        "rank": "932",
        "state": "Texas"
    },
    {
        "city": "Atlantic City",
        "growth_from_2000_to_2013": "-2.2%",
        "latitude": 39.3642834,
        "longitude": -74.4229266,
        "population": "39551",
        "rank": "933",
        "state": "New Jersey"
    },
    {
        "city": "Clovis",
        "growth_from_2000_to_2013": "21.3%",
        "latitude": 34.4047987,
        "longitude": -103.2052272,
        "population": "39508",
        "rank": "934",
        "state": "New Mexico"
    },
    {
        "city": "The Colony",
        "growth_from_2000_to_2013": "45.7%",
        "latitude": 33.0806083,
        "longitude": -96.89283089999999,
        "population": "39458",
        "rank": "935",
        "state": "Texas"
    },
    {
        "city": "Culver City",
        "growth_from_2000_to_2013": "1.3%",
        "latitude": 34.0211224,
        "longitude": -118.3964665,
        "population": "39428",
        "rank": "936",
        "state": "California"
    },
    {
        "city": "Marlborough",
        "growth_from_2000_to_2013": "7.6%",
        "latitude": 42.3459271,
        "longitude": -71.5522874,
        "population": "39414",
        "rank": "937",
        "state": "Massachusetts"
    },
    {
        "city": "Hilton Head Island",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 32.216316,
        "longitude": -80.752608,
        "population": "39412",
        "rank": "938",
        "state": "South Carolina"
    },
    {
        "city": "Moorhead",
        "growth_from_2000_to_2013": "21.3%",
        "latitude": 46.8737648,
        "longitude": -96.76780389999999,
        "population": "39398",
        "rank": "939",
        "state": "Minnesota"
    },
    {
        "city": "Calexico",
        "growth_from_2000_to_2013": "44.0%",
        "latitude": 32.6789476,
        "longitude": -115.4988834,
        "population": "39389",
        "rank": "940",
        "state": "California"
    },
    {
        "city": "Bullhead City",
        "growth_from_2000_to_2013": "15.9%",
        "latitude": 35.1359386,
        "longitude": -114.5285981,
        "population": "39383",
        "rank": "941",
        "state": "Arizona"
    },
    {
        "city": "Germantown",
        "growth_from_2000_to_2013": "4.1%",
        "latitude": 35.0867577,
        "longitude": -89.8100858,
        "population": "39375",
        "rank": "942",
        "state": "Tennessee"
    },
    {
        "city": "La Quinta",
        "growth_from_2000_to_2013": "59.9%",
        "latitude": 33.6633573,
        "longitude": -116.3100095,
        "population": "39331",
        "rank": "943",
        "state": "California"
    },
    {
        "city": "Lancaster",
        "growth_from_2000_to_2013": "10.7%",
        "latitude": 39.7136754,
        "longitude": -82.5993294,
        "population": "39325",
        "rank": "944",
        "state": "Ohio"
    },
    {
        "city": "Wausau",
        "growth_from_2000_to_2013": "1.7%",
        "latitude": 44.9591352,
        "longitude": -89.6301221,
        "population": "39309",
        "rank": "945",
        "state": "Wisconsin"
    },
    {
        "city": "Sherman",
        "growth_from_2000_to_2013": "11.6%",
        "latitude": 33.6356618,
        "longitude": -96.6088805,
        "population": "39296",
        "rank": "946",
        "state": "Texas"
    },
    {
        "city": "Ocoee",
        "growth_from_2000_to_2013": "57.9%",
        "latitude": 28.5691677,
        "longitude": -81.5439619,
        "population": "39172",
        "rank": "947",
        "state": "Florida"
    },
    {
        "city": "Shakopee",
        "growth_from_2000_to_2013": "85.7%",
        "latitude": 44.7973962,
        "longitude": -93.5272861,
        "population": "39167",
        "rank": "948",
        "state": "Minnesota"
    },
    {
        "city": "Woburn",
        "growth_from_2000_to_2013": "4.4%",
        "latitude": 42.4792618,
        "longitude": -71.1522765,
        "population": "39083",
        "rank": "949",
        "state": "Massachusetts"
    },
    {
        "city": "Bremerton",
        "growth_from_2000_to_2013": "4.9%",
        "latitude": 47.5673202,
        "longitude": -122.6329356,
        "population": "39056",
        "rank": "950",
        "state": "Washington"
    },
    {
        "city": "Rock Island",
        "growth_from_2000_to_2013": "-1.9%",
        "latitude": 41.5094771,
        "longitude": -90.5787476,
        "population": "38877",
        "rank": "951",
        "state": "Illinois"
    },
    {
        "city": "Muskogee",
        "growth_from_2000_to_2013": "-0.7%",
        "latitude": 35.7478769,
        "longitude": -95.3696909,
        "population": "38863",
        "rank": "952",
        "state": "Oklahoma"
    },
    {
        "city": "Cape Girardeau",
        "growth_from_2000_to_2013": "9.4%",
        "latitude": 37.3058839,
        "longitude": -89.51814759999999,
        "population": "38816",
        "rank": "953",
        "state": "Missouri"
    },
    {
        "city": "Annapolis",
        "growth_from_2000_to_2013": "7.6%",
        "latitude": 38.9784453,
        "longitude": -76.4921829,
        "population": "38722",
        "rank": "954",
        "state": "Maryland"
    },
    {
        "city": "Greenacres",
        "growth_from_2000_to_2013": "35.5%",
        "latitude": 26.6276276,
        "longitude": -80.1353896,
        "population": "38696",
        "rank": "955",
        "state": "Florida"
    },
    {
        "city": "Ormond Beach",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 29.2858129,
        "longitude": -81.0558894,
        "population": "38661",
        "rank": "956",
        "state": "Florida"
    },
    {
        "city": "Hallandale Beach",
        "growth_from_2000_to_2013": "12.4%",
        "latitude": 25.9812024,
        "longitude": -80.14837899999999,
        "population": "38632",
        "rank": "957",
        "state": "Florida"
    },
    {
        "city": "Stanton",
        "growth_from_2000_to_2013": "2.8%",
        "latitude": 33.8025155,
        "longitude": -117.9931165,
        "population": "38623",
        "rank": "958",
        "state": "California"
    },
    {
        "city": "Puyallup",
        "growth_from_2000_to_2013": "11.8%",
        "latitude": 47.1853785,
        "longitude": -122.2928974,
        "population": "38609",
        "rank": "959",
        "state": "Washington"
    },
    {
        "city": "Pacifica",
        "growth_from_2000_to_2013": "0.5%",
        "latitude": 37.6138253,
        "longitude": -122.4869194,
        "population": "38606",
        "rank": "960",
        "state": "California"
    },
    {
        "city": "Hanover Park",
        "growth_from_2000_to_2013": "0.6%",
        "latitude": 41.9994722,
        "longitude": -88.1450735,
        "population": "38510",
        "rank": "961",
        "state": "Illinois"
    },
    {
        "city": "Hurst",
        "growth_from_2000_to_2013": "5.8%",
        "latitude": 32.8234621,
        "longitude": -97.1705678,
        "population": "38448",
        "rank": "962",
        "state": "Texas"
    },
    {
        "city": "Lima",
        "growth_from_2000_to_2013": "-8.1%",
        "latitude": 40.742551,
        "longitude": -84.1052256,
        "population": "38355",
        "rank": "963",
        "state": "Ohio"
    },
    {
        "city": "Marana",
        "growth_from_2000_to_2013": "166.2%",
        "latitude": 32.436381,
        "longitude": -111.2224422,
        "population": "38290",
        "rank": "964",
        "state": "Arizona"
    },
    {
        "city": "Carpentersville",
        "growth_from_2000_to_2013": "22.8%",
        "latitude": 42.1211364,
        "longitude": -88.2578582,
        "population": "38241",
        "rank": "965",
        "state": "Illinois"
    },
    {
        "city": "Oakley",
        "growth_from_2000_to_2013": "47.7%",
        "latitude": 37.9974219,
        "longitude": -121.7124536,
        "population": "38194",
        "rank": "966",
        "state": "California"
    },
    {
        "city": "Huber Heights",
        "growth_from_2000_to_2013": "-0.2%",
        "latitude": 39.843947,
        "longitude": -84.12466080000002,
        "population": "38142",
        "rank": "967",
        "state": "Ohio"
    },
    {
        "city": "Lancaster",
        "growth_from_2000_to_2013": "46.4%",
        "latitude": 32.5920798,
        "longitude": -96.7561082,
        "population": "38071",
        "rank": "968",
        "state": "Texas"
    },
    {
        "city": "Montclair",
        "growth_from_2000_to_2013": "12.1%",
        "latitude": 34.0775104,
        "longitude": -117.6897776,
        "population": "38027",
        "rank": "969",
        "state": "California"
    },
    {
        "city": "Wheeling",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 42.1391927,
        "longitude": -87.9289591,
        "population": "38015",
        "rank": "970",
        "state": "Illinois"
    },
    {
        "city": "Brookfield",
        "growth_from_2000_to_2013": "-1.9%",
        "latitude": 43.0605671,
        "longitude": -88.1064787,
        "population": "37999",
        "rank": "971",
        "state": "Wisconsin"
    },
    {
        "city": "Park Ridge",
        "growth_from_2000_to_2013": "0.1%",
        "latitude": 42.0111412,
        "longitude": -87.84061919999999,
        "population": "37839",
        "rank": "972",
        "state": "Illinois"
    },
    {
        "city": "Florence",
        "growth_from_2000_to_2013": "19.8%",
        "latitude": 34.1954331,
        "longitude": -79.7625625,
        "population": "37792",
        "rank": "973",
        "state": "South Carolina"
    },
    {
        "city": "Roy",
        "growth_from_2000_to_2013": "13.3%",
        "latitude": 41.1616108,
        "longitude": -112.0263313,
        "population": "37733",
        "rank": "974",
        "state": "Utah"
    },
    {
        "city": "Winter Garden",
        "growth_from_2000_to_2013": "142.5%",
        "latitude": 28.5652787,
        "longitude": -81.58618469999999,
        "population": "37711",
        "rank": "975",
        "state": "Florida"
    },
    {
        "city": "Chelsea",
        "growth_from_2000_to_2013": "7.3%",
        "latitude": 42.3917638,
        "longitude": -71.0328284,
        "population": "37670",
        "rank": "976",
        "state": "Massachusetts"
    },
    {
        "city": "Valley Stream",
        "growth_from_2000_to_2013": "3.6%",
        "latitude": 40.6642699,
        "longitude": -73.70846449999999,
        "population": "37659",
        "rank": "977",
        "state": "New York"
    },
    {
        "city": "Spartanburg",
        "growth_from_2000_to_2013": "-6.2%",
        "latitude": 34.9495672,
        "longitude": -81.9320482,
        "population": "37647",
        "rank": "978",
        "state": "South Carolina"
    },
    {
        "city": "Lake Oswego",
        "growth_from_2000_to_2013": "5.3%",
        "latitude": 45.42067489999999,
        "longitude": -122.6706498,
        "population": "37610",
        "rank": "979",
        "state": "Oregon"
    },
    {
        "city": "Friendswood",
        "growth_from_2000_to_2013": "28.6%",
        "latitude": 29.5293998,
        "longitude": -95.2010447,
        "population": "37587",
        "rank": "980",
        "state": "Texas"
    },
    {
        "city": "Westerville",
        "growth_from_2000_to_2013": "5.7%",
        "latitude": 40.1261743,
        "longitude": -82.92906959999999,
        "population": "37530",
        "rank": "981",
        "state": "Ohio"
    },
    {
        "city": "Northglenn",
        "growth_from_2000_to_2013": "15.5%",
        "latitude": 39.8961821,
        "longitude": -104.9811468,
        "population": "37499",
        "rank": "982",
        "state": "Colorado"
    },
    {
        "city": "Phenix City",
        "growth_from_2000_to_2013": "31.9%",
        "latitude": 32.4709761,
        "longitude": -85.0007653,
        "population": "37498",
        "rank": "983",
        "state": "Alabama"
    },
    {
        "city": "Grove City",
        "growth_from_2000_to_2013": "35.6%",
        "latitude": 39.88145189999999,
        "longitude": -83.0929644,
        "population": "37490",
        "rank": "984",
        "state": "Ohio"
    },
    {
        "city": "Texarkana",
        "growth_from_2000_to_2013": "7.4%",
        "latitude": 33.425125,
        "longitude": -94.04768820000001,
        "population": "37442",
        "rank": "985",
        "state": "Texas"
    },
    {
        "city": "Addison",
        "growth_from_2000_to_2013": "2.6%",
        "latitude": 41.931696,
        "longitude": -87.9889556,
        "population": "37385",
        "rank": "986",
        "state": "Illinois"
    },
    {
        "city": "Dover",
        "growth_from_2000_to_2013": "16.0%",
        "latitude": 39.158168,
        "longitude": -75.5243682,
        "population": "37366",
        "rank": "987",
        "state": "Delaware"
    },
    {
        "city": "Lincoln Park",
        "growth_from_2000_to_2013": "-6.7%",
        "latitude": 42.2505943,
        "longitude": -83.1785361,
        "population": "37313",
        "rank": "988",
        "state": "Michigan"
    },
    {
        "city": "Calumet City",
        "growth_from_2000_to_2013": "-4.5%",
        "latitude": 41.6155909,
        "longitude": -87.5294871,
        "population": "37240",
        "rank": "989",
        "state": "Illinois"
    },
    {
        "city": "Muskegon",
        "growth_from_2000_to_2013": "-7.1%",
        "latitude": 43.2341813,
        "longitude": -86.24839209999999,
        "population": "37213",
        "rank": "990",
        "state": "Michigan"
    },
    {
        "city": "Aventura",
        "growth_from_2000_to_2013": "47.2%",
        "latitude": 25.9564812,
        "longitude": -80.1392121,
        "population": "37199",
        "rank": "991",
        "state": "Florida"
    },
    {
        "city": "Martinez",
        "growth_from_2000_to_2013": "3.4%",
        "latitude": 38.0193657,
        "longitude": -122.1341321,
        "population": "37165",
        "rank": "992",
        "state": "California"
    },
    {
        "city": "Greenfield",
        "growth_from_2000_to_2013": "4.8%",
        "latitude": 42.9614039,
        "longitude": -88.0125865,
        "population": "37159",
        "rank": "993",
        "state": "Wisconsin"
    },
    {
        "city": "Apache Junction",
        "growth_from_2000_to_2013": "15.7%",
        "latitude": 33.4150485,
        "longitude": -111.5495777,
        "population": "37130",
        "rank": "994",
        "state": "Arizona"
    },
    {
        "city": "Monrovia",
        "growth_from_2000_to_2013": "0.2%",
        "latitude": 34.1442616,
        "longitude": -118.0019482,
        "population": "37101",
        "rank": "995",
        "state": "California"
    },
    {
        "city": "Weslaco",
        "growth_from_2000_to_2013": "28.8%",
        "latitude": 26.1595194,
        "longitude": -97.9908366,
        "population": "37093",
        "rank": "996",
        "state": "Texas"
    },
    {
        "city": "Keizer",
        "growth_from_2000_to_2013": "14.4%",
        "latitude": 44.9901194,
        "longitude": -123.0262077,
        "population": "37064",
        "rank": "997",
        "state": "Oregon"
    },
    {
        "city": "Spanish Fork",
        "growth_from_2000_to_2013": "78.1%",
        "latitude": 40.114955,
        "longitude": -111.654923,
        "population": "36956",
        "rank": "998",
        "state": "Utah"
    },
    {
        "city": "Beloit",
        "growth_from_2000_to_2013": "2.9%",
        "latitude": 42.5083482,
        "longitude": -89.03177649999999,
        "population": "36888",
        "rank": "999",
        "state": "Wisconsin"
    },
    {
        "city": "Panama City",
        "growth_from_2000_to_2013": "0.1%",
        "latitude": 30.1588129,
        "longitude": -85.6602058,
        "population": "36877",
        "rank": "1000",
        "state": "Florida"
    }
]'! !

!USBorder methodsFor: 'json' stamp: 'IGJ 3/9/2024 13:37:48'!
asJsonArray
	^ Json new readFrom:  self asString readStream! !

!USBorder methodsFor: 'json' stamp: 'IGJ 3/9/2024 14:46:14'!
asString
	"
	From https://github.com/topojson/us-atlas

	Specifically 'nation-10m.json': https://github.com/topojson/us-atlas?tab=readme-ov-file#nation-10m.json

	Then loaded into https://mapshaper.org/ and modified to:
		+ select the contiguous US
		+ simplify to about 17%
		+ export as GeoJSON
	"
	^ '{"type":"FeatureCollection", "features": [{"type":"Feature","geometry":{"type":"MultiPolygon","coordinates":[[[[-81.81286549945499,24.56902930978309],[-81.68365091570915,24.558720593495927],[-81.2565249305493,24.66438493543935],[-81.44316821818218,24.813002261912615],[-81.74466891358914,24.660089636986363],[-81.81286549945499,24.56902930978309]]],[[[-89.25347194681946,47.87617777536774],[-89.12425736307362,47.828929492384916],[-88.66841702597026,48.01105014679146],[-88.5463810302103,48.17513054769547],[-89.17809677296772,47.93545289401893],[-89.25347194681946,47.87617777536774]]],[[[-92.01722832138321,29.591092261012605],[-91.81981715177152,29.474260143091428],[-91.76597774187742,29.574770126891266],[-92.01722832138321,29.591092261012605]]],[[[-123.20460382603825,48.59606979608795],[-123.15076441614416,48.51360006579065],[-122.87438877868777,48.418244440134394],[-122.741584900949,48.66221739226391],[-122.91746030660306,48.71376097369973],[-123.20460382603825,48.59606979608795]]],[[[-124.73005377303772,48.16997618955189],[-124.62596424724246,47.8882046110361],[-124.48957107551075,47.81690265671656],[-124.37112437374373,47.59956055499554],[-124.32087425784258,47.355587602866024],[-124.23473120201201,47.28686282761827],[-124.08757014830147,46.86764169860698],[-124.09474873628736,46.746514282232816],[-123.89374827268273,46.53690371772717],[-124.05885579635796,46.38656827187271],[-123.90810544865448,46.24568248261482],[-123.99424850448503,45.946729710287094],[-123.94040909459093,45.661521893008924],[-123.97630203452033,45.145227018960185],[-124.07680226632266,44.77153605355053],[-124.05885579635796,44.65899923408233],[-124.14858814618145,43.91075824357243],[-124.20242755607555,43.667644351133504],[-124.38189225572255,43.26989971438714],[-124.45726742957429,43.00015497153971],[-124.55417836738366,42.84036986908868],[-124.38907084370842,42.56632982778827],[-124.43573166561666,42.44004805327052],[-124.34241002180022,42.092987938269374],[-124.21319543805437,42.00622290951909],[-124.22037402604025,41.846437807068064],[-124.0624450903509,41.43924351372513],[-124.17730249812497,40.84391514814148],[-124.41060660766607,40.43843897417973],[-124.36394578575785,40.260613618226174],[-123.85067674476744,39.83194283261832],[-123.76812298292982,39.5596209106991],[-123.82555168681685,39.36117812217122],[-123.69274780907809,39.05707099169991],[-123.7394086309863,38.953983828828285],[-123.33022911579116,38.565688848678484],[-123.12922865218651,38.450574850138494],[-122.96771042250421,38.250413942229414],[-122.9389960705607,38.0322127808178],[-122.52981655536556,37.81916597754977],[-122.49033432144321,38.11210533204331],[-122.33240538575384,37.783944530235296],[-122.17088715607156,37.675703009220086],[-122.35394114971149,37.6155688308783],[-122.40778055960558,37.811434440334395],[-122.51545937939379,37.780508291472906],[-122.51545937939379,37.52107226491264],[-122.40060197161971,37.35956904308043],[-122.40419126561264,37.195488642176414],[-122.10627986419863,36.95581098849988],[-121.86220787267871,36.93175731716317],[-121.78683269882697,36.80375742326423],[-121.9411723405234,36.48075097959979],[-121.87656504865048,36.28918066859668],[-121.71863611296112,36.19554316232162],[-121.4637962394624,35.885422614016136],[-120.86079484864848,35.36053714306142],[-120.89668778857788,35.24800032359323],[-120.63466932709326,35.12343666845668],[-120.67056226702266,34.904376447354466],[-120.59877638716387,34.704215539445386],[-120.64543720907209,34.58137000369003],[-120.47315109741098,34.44821575164751],[-120.14293605006048,34.473128482674824],[-119.87373900059,34.40869900588005],[-119.55788112921128,34.41299430433304],[-119.27791619776197,34.26695415693156],[-119.216898199882,34.145826740557396],[-118.8041293906939,34.00150471253712],[-118.54211092920929,34.038444279232785],[-118.39136058150581,33.8408605503955],[-118.41289634546345,33.742068685976854],[-118.08985988609885,33.730041850308496],[-117.50480496524965,33.33401533294332],[-117.3289295595956,33.121827589365886],[-117.24996509175091,32.87441839847398],[-117.24637579775796,32.66910313242132],[-117.12433980199802,32.5342307609976],[-116.21265912779127,32.61068707346073],[-114.71951282672826,32.71892859447594],[-114.8128344705447,32.49385495553955],[-113.4919742811428,32.08923784126841],[-112.36493596735967,31.74131866657666],[-111.07637942389424,31.332406253852533],[-109.99959122601226,31.33326531354313],[-109.04842831788318,31.332406253852533],[-108.20853352353522,31.33326531354313],[-108.20853352353522,31.78341259141591],[-106.53233322883229,31.784271651106508],[-106.38158288112881,31.731869009980095],[-106.20570747547475,31.465560505895056],[-105.95445689596896,31.365050522095217],[-105.55604526275262,30.99050049699496],[-105.00688328183281,30.68639336652366],[-104.89920446204461,30.57042030829308],[-104.85972222812228,30.39001777326773],[-104.68743611646116,30.179548149071486],[-104.68025752847528,29.924407420964208],[-104.50797141681416,29.63919960368603],[-104.26389942529424,29.513776888858885],[-104.14545272352723,29.383199815888155],[-103.8367734401344,29.27839453363533],[-103.72550532635326,29.191629504885043],[-103.52450486274863,29.137508744377442],[-103.28043287122871,28.982018940379398],[-103.10096817158171,29.05761619315193],[-102.84253900409004,29.35828708486084],[-102.81023535815358,29.522367485764853],[-102.64512783447834,29.733696169651694],[-102.38669866698666,29.76719949758497],[-102.3005556111561,29.87801819767197],[-102.0493050316503,29.785239751087502],[-101.70832210232102,29.762904199131988],[-101.47501799277993,29.78094445263452],[-101.25248176521765,29.625454648636484],[-101.25607105921058,29.520649366383658],[-101.05865988959889,29.45879706866068],[-101.01199906769067,29.368595801148004],[-100.79664142811427,29.24660932508325],[-100.67460543235431,29.099710117991172],[-100.49873002670026,28.66158967578675],[-100.33721179701797,28.443388514375137],[-100.29414026910268,28.28446247161471],[-100.08237192351923,28.144435742047413],[-99.89213934189341,27.899603730227298],[-99.87778216592166,27.79909374642746],[-99.70549605426054,27.654771718407176],[-99.55474570655706,27.614395912949128],[-99.48295982669826,27.49069131750317],[-99.49731700267002,27.27163109640096],[-99.42553112281122,27.176275470744706],[-99.44706688676887,27.023362845818454],[-99.26760218712187,26.842960310793103],[-99.11326254542544,26.434047898068975],[-98.82611902599025,26.3704774809648],[-98.65383291432914,26.23560510954109],[-98.46360033270332,26.222719214182135],[-98.19799257722576,26.056061634206337],[-97.79958094400943,26.060356932659325],[-97.64883059630596,26.021699246582465],[-97.44424083870838,25.84988730846308],[-97.35091919489194,25.925484561235606],[-97.14632943729437,25.952974471334706],[-97.27195472704726,26.08612872337723],[-97.29707978499785,26.295739287882874],[-97.44424083870838,26.60929607495074],[-97.46577660266603,26.80945698285982],[-97.41193719277193,27.32145655845558],[-97.25400825708256,27.696865643246426],[-97.36886566485664,27.74153674715747],[-97.4550087206872,27.873831939509387],[-97.18581167121671,27.830878954979546],[-97.04941849948499,28.022449265982658],[-96.8879002698027,28.031039862888626],[-96.63306039630396,28.22261017389173],[-96.44282781467814,28.31796579954799],[-96.22029158711587,28.49235491673916],[-95.38398608676086,28.866045882148818],[-95.02505668746687,29.147817460664605],[-94.89225280972809,29.30846162280622],[-94.91019927969279,29.496595695046942],[-95.00711021750217,29.65895797656976],[-94.6948416401164,29.757749840988403],[-94.74150246202461,29.525803724527243],[-94.59434140831408,29.468246725257245],[-94.13491177721777,29.6469311409014],[-93.83700037580375,29.678716349453488],[-93.74367873198732,29.73627334872348],[-93.17657028110281,29.77063573634736],[-92.61664041820418,29.58593790286902],[-92.3223183107831,29.53181714236142],[-92.1069606712067,29.613427812968126],[-92.20028231502314,29.753454542535422],[-91.88801373763737,29.83592427283272],[-91.85571009170091,29.707924378933782],[-91.62240598215982,29.73541428903288],[-91.46088775247752,29.46996484463844],[-91.25629799487994,29.438179636086353],[-91.27783375883759,29.24746838477384],[-90.96197588745888,29.180461728907282],[-90.78968977579775,29.10744165520655],[-90.64611801608015,29.168434893238924],[-90.59945719417193,29.28870324992249],[-90.30513508675087,29.266367697966977],[-90.22258132491325,29.08510610325103],[-89.84211616166161,29.318770339093383],[-89.64111569805698,29.290421369303687],[-89.48318676236762,29.21482411653116],[-89.34320429664297,29.053320894698942],[-89.1493824210242,29.029267223362226],[-89.09195371713717,29.190770445194445],[-89.19963253692536,29.347978368573678],[-89.5083118203182,29.385776994959947],[-89.68418722597225,29.624595588945887],[-89.53343687826877,29.648649260282596],[-89.31448994469945,29.92354836127361],[-89.49395464434645,30.041239538885385],[-89.65906216802168,29.86255512324123],[-89.83852686766868,29.945883913229125],[-89.6159906401064,30.156353537425368],[-89.08477512915128,30.367682221312208],[-88.81198878568786,30.384863415124144],[-88.47100585635856,30.32043393832938],[-88.37409491854918,30.38572247481474],[-88.13720151501515,30.32043393832938],[-88.10489786907868,30.50083647335473],[-88.00798693126931,30.684675247142465],[-87.90030811148111,30.55066193540935],[-87.90748669946699,30.409776146151458],[-87.75673635176351,30.291225908849086],[-87.29371742667426,30.323870177091763],[-86.63328733197332,30.396031191101905],[-86.2994829906299,30.36338692285922],[-85.92260712137121,30.237964208032075],[-85.36267725847259,29.898635630246297],[-85.30524855458555,29.725105572745726],[-84.88171186341863,29.733696169651694],[-84.5371396400964,29.909803406224057],[-84.33254988249882,29.92354836127361],[-84.27153188461884,30.067870389293887],[-84.02387059910599,30.103091836608364],[-83.63622684786847,29.88574973488734],[-83.5393159100591,29.72338745336453],[-83.4136906203062,29.67012575254752],[-83.39933344433445,29.517213127621268],[-83.24140450864509,29.433025277942775],[-83.16961862878628,29.290421369303687],[-82.99733251712517,29.17788454983549],[-82.828635699457,29.15812617695176],[-82.68865323373234,28.905562627916275],[-82.67429605776057,28.441670394993942],[-82.79633205352053,28.18738872657726],[-82.85017146341463,27.86352322322223],[-82.71377829168291,27.69858376262762],[-82.58815300193001,27.816274940239396],[-82.68865323373234,28.027603624126236],[-82.41227759627596,27.901321849608493],[-82.4338133602336,27.76473135880358],[-82.70301040970409,27.497563795027943],[-82.25075936659367,26.76306775956759],[-82.13949125281252,26.637645044740445],[-82.10718760687607,26.483873360123596],[-81.97079443514434,26.476141822908225],[-81.87029420334203,26.379068077870777],[-81.80209761747618,26.087846842758424],[-81.69082950369503,25.852464487534874],[-81.62263291782918,25.89713559144591],[-81.3821502203022,25.776867234762342],[-81.28882857648576,25.687525026940264],[-81.12731034680347,25.38084071739717],[-81.17038187471874,25.221914674636743],[-81.08064952489525,25.11882751176511],[-80.81145247542476,25.18583416763167],[-80.46329095810958,25.209028779277787],[-80.35920143231432,25.15318989938899],[-80.29100484644846,25.31898841967419],[-80.33766566835668,25.46588762676626],[-80.24075473054731,25.72446459363593],[-80.11871873478735,25.841296711557113],[-80.11871873478735,25.986477799267988],[-80.03616497294972,26.594692060210598],[-80.03257567895679,26.796571087500872],[-80.09359367683676,27.01820848767487],[-80.25511190651906,27.37987261741617],[-80.3843264902649,27.739818627776273],[-80.56738048390484,28.09546933968339],[-80.60686271782717,28.289616829758295],[-80.52430895598955,28.459710648496483],[-80.94425635316352,29.110877893968933],[-81.16320328673287,29.555011754007538],[-81.26370351853518,29.814447780567804],[-81.39291810228102,30.303252744517437],[-81.46111468814688,30.769722156511563],[-81.44675751217513,30.956997169061687],[-81.26011422454225,31.404567267862674],[-81.17756046270462,31.51710408733087],[-81.1308996407964,31.72241935338353],[-80.84375612136121,32.023949304783045],[-80.84375612136121,32.10985527384273],[-80.4561123701237,32.32633831587315],[-80.47046954609546,32.49729119430194],[-80.33407637436375,32.478391881108806],[-79.88541462524626,32.68456620685206],[-79.84952168531684,32.75500910148101],[-79.57673534185342,32.906203607026065],[-79.1711451206512,33.20687449873498],[-79.1352521807218,33.40359916788167],[-78.93784101111011,33.63984058279582],[-78.71530478354784,33.80048474493744],[-78.38508973619736,33.90185378842788],[-77.94719586905869,33.91216250471504],[-77.82874916729168,34.16300793436934],[-77.55596282382824,34.41728960278602],[-77.20780130651306,34.60542367502674],[-77.03192590085901,34.661262554915545],[-76.67658579555795,34.69304776346763],[-76.55096050580505,34.6457994804848],[-76.23510263442634,34.92585293961939],[-76.48994250792508,35.01691326682266],[-76.56890697576975,35.096805818048175],[-76.46840674396744,35.26088621895218],[-76.48635321393213,35.37170491903918],[-76.1417809906099,35.32875193450934],[-75.89411970509705,35.57272488663886],[-75.77567300333003,35.57959736416363],[-75.72542288742888,35.82271125660256],[-75.8079766492665,35.959301747407466],[-75.97667346693467,35.897449449684494],[-76.06281652276523,35.99280507534075],[-76.36431721817218,35.94212055359553],[-76.4109780400804,36.07785198470984],[-76.21715616446164,36.09503317852178],[-75.91206617506175,36.21186529644296],[-75.85104817718177,36.41546244311443],[-75.72542288742888,36.00311379162791],[-75.65722630156301,36.02029498543985],[-75.79720876728767,36.290039728287276],[-75.99461993689937,36.9223076605666],[-76.31765639626396,37.014227047460466],[-76.34996004220042,37.17057591114911],[-76.26381698636986,37.48155551914518],[-76.36072792417924,37.61041447273472],[-76.23510263442634,37.88874981248812],[-76.51506756587565,38.026199362983625],[-76.52942474184742,38.134440883998835],[-76.38585298212982,38.21776967398673],[-76.41456733407334,38.41449434313343],[-76.5186568598686,38.539057998269975],[-76.5186568598686,38.86292350162501],[-76.3930315701157,39.011540828098276],[-76.44328168601686,39.19537960188601],[-76.10229875668756,39.435916315253145],[-76.27817416234163,39.14555413983139],[-76.16331675456755,38.99951399242992],[-76.36072792417924,38.939379814088134],[-76.27817416234163,38.60950089289892],[-76.33560286622865,38.49180971528715],[-76.13460240262403,38.23237368872688],[-75.95872699696997,38.13701806307063],[-75.89770899908999,37.97465578154781],[-75.68594065350653,37.88617263341633],[-75.9264233510335,37.60010575644756],[-76.01974499484994,37.31747511824118],[-75.95513770297703,37.11989138940389],[-75.83310170721707,37.17315309022089],[-75.65722630156301,37.45148842997429],[-75.56390465774658,37.73669624725247],[-75.35213631216313,37.87500485743857],[-75.17626090650906,38.13014558554585],[-75.0542249107491,38.41449434313343],[-75.08293926269262,38.77186317442174],[-75.19061808248082,38.80708462173621],[-75.40238642806428,39.066520648296475],[-75.40238642806428,39.2546547205372],[-75.28752902029021,39.28987616785167],[-74.88552809308094,39.158440035190345],[-74.97167114891148,38.94023887377873],[-74.79220644926448,38.99178245521455],[-74.63786680756807,39.22115139260392],[-74.33636611216112,39.431621016800165],[-74.09588341463414,39.76235899767997],[-73.98102600686006,40.279512931419305],[-73.99897247682476,40.41094906408063],[-74.2717588202882,40.48912349592495],[-74.08511553265532,40.56987510684106],[-73.55748931569316,40.58190194250942],[-73.20932779837798,40.63086834487344],[-72.39455806198062,40.86625070009699],[-72.10382524855248,40.99167341492414],[-72.4017366499665,41.09733775686756],[-72.58479064360644,40.99768683275832],[-72.77502322523225,40.96504256451564],[-73.14113121251212,40.96590162420623],[-73.64004307753078,40.8928815505055],[-73.64363237152371,41.00198213121131],[-73.38879249802498,41.0578210111001],[-73.00832733477334,41.20987457633576],[-72.75348746127462,41.26657251591515],[-72.38737947399474,41.26141815777157],[-71.94589631286313,41.337874470234695],[-71.85616396303963,41.30608926168261],[-71.48287738777388,41.37137779816798],[-71.40750221392214,41.654008436374355],[-71.19214457434575,41.45814282691826],[-70.95166187681876,41.514840766497656],[-70.91217964289643,41.61964604875048],[-70.64657188741887,41.67806210771107],[-70.49223224572246,41.55178033319333],[-69.92871308883089,41.691807062760624],[-69.93589167681677,41.8094982403724],[-70.29123178211782,41.73390098759987],[-70.54248236162361,41.815511658206574],[-70.55325024360243,41.929766597055966],[-70.76501858918589,42.24418244381443],[-71.01626916869168,42.32837029349293],[-70.77937576515765,42.693470661996614],[-70.8116794110941,42.90995370402703],[-70.57478600756008,43.22179237171371],[-70.41685707187072,43.36096004159041],[-70.38455342593426,43.49669147270472],[-70.16919578635786,43.675375888348874],[-69.83539144501445,43.720906051950514],[-69.70617686126862,43.82313415513154],[-69.4262119298193,43.91247636295362],[-69.22162217222171,43.91505354202541],[-69.04215747257473,44.006113869228685],[-69.09958617646177,44.10490573364733],[-68.94883582875829,44.355751163301626],[-68.52888843158432,44.221737851568506],[-68.31712008600086,44.225174090330896],[-68.04792303653036,44.33083843227431],[-67.82538680896809,44.48289199750997],[-67.65668999129991,44.53615369832698],[-67.50952893758938,44.49663695255952],[-67.40543941179412,44.68133478603785],[-67.19008177221772,44.645254279032784],[-66.9819027206272,44.811052799317984],[-67.11111730437304,45.1125827507175],[-67.3408321199212,45.125468646076456],[-67.48799317363174,45.2792403306933],[-67.41979658776587,45.377173135421344],[-67.4485109397094,45.603105834048336],[-67.80385104501045,45.67784402713026],[-67.77872598705987,46.004286709557086],[-67.7894938690387,47.06780260651606],[-68.23456632416324,47.354728543175426],[-68.57913854748547,47.28772188730886],[-68.90217500685007,47.178621306603056],[-69.0493360605606,47.25679573844738],[-69.08163970649706,47.424312378113775],[-69.22521146621466,47.459533825428245],[-69.99690967469675,46.694970700797],[-70.05792767257672,46.4166353610436],[-70.2086780202802,46.331588451674506],[-70.29123178211782,46.185548304273034],[-70.3163568400684,45.96305184440843],[-70.25892813618135,45.8908908303983],[-70.38455342593426,45.734541966709656],[-70.64298259342593,45.607401132501316],[-70.63221471144712,45.4166898811888],[-70.8116794110941,45.30243494233942],[-71.36443068600686,45.26635443533434],[-71.50082385773858,45.01379088629886],[-72.30841500615006,45.003482170011694],[-73.08729180261803,45.01550900568005],[-74.14613353053531,44.991455334343335],[-74.97167114891148,44.983723797127965],[-75.30906478424784,44.836824590035896],[-75.7649051213512,44.51553626575265],[-75.91206617506175,44.367777998969984],[-76.31406710227103,44.19940229961299],[-76.375085100151,44.03188565994659],[-76.13819169661696,43.93481191490914],[-76.22792404644046,43.80423484193841],[-76.20279898848989,43.574865904549036],[-76.41815662806628,43.52160420373203],[-76.6981215595156,43.34463790746907],[-76.95296143301432,43.270758774077734],[-77.39085530015299,43.27677219191191],[-77.5344270598706,43.23467826707267],[-77.7138917595176,43.32316141520415],[-78.10512480474804,43.37556405633055],[-78.48917926199262,43.374704996639956],[-79.05987700687007,43.251000401194005],[-79.01321618496185,42.985550956799564],[-78.85169795527955,42.78367192950929],[-79.04910912489125,42.689175363543626],[-79.14960935669356,42.55344393242932],[-79.3506098202982,42.489014455634546],[-79.71671780757808,42.284558249272486],[-80.3484335503355,42.030276580855805],[-81.00886364503644,41.854169344283434],[-81.44316821818218,41.672907749567486],[-81.73749032560325,41.488209916089154],[-82.01027666906668,41.51569982618825],[-82.48047418214182,41.38168651445514],[-82.83581428744287,41.587860840198395],[-82.93272522525226,41.51398170680706],[-83.42445850228502,41.74077346512465],[-83.44240497224972,41.8086391806818],[-83.13372568885688,42.087833580125796],[-83.06552910299102,42.31806157720577],[-82.89683228532284,42.385068233072325],[-82.87529652136521,42.523376843258426],[-82.58815300193001,42.550866753357525],[-82.52354571005709,42.607564692936926],[-82.42304547825478,43.00788650875508],[-82.52354571005709,43.225228610476094],[-82.53790288602886,43.43741635405353],[-82.64199241182412,43.85234218461184],[-82.73890334963349,43.989791735107346],[-82.91477875528754,44.070543346023456],[-83.26294027260272,43.973469600986],[-83.6469947298473,43.60407393402933],[-83.85158448744487,43.64530879917798],[-83.95567401324013,43.750973141121406],[-83.83004872348724,43.98893267541675],[-83.58238743797438,44.0567983909739],[-83.5393159100591,44.248368701977014],[-83.33113685846858,44.34028808887088],[-83.27370815458154,44.713979054280536],[-83.32036897648976,44.880636634256334],[-83.43881567825677,44.94077081259812],[-83.42086920829207,45.29040810667106],[-84.05617424504244,45.48970995488954],[-84.2141031807318,45.634891042600415],[-84.46176446624466,45.65207223641236],[-84.77403304363044,45.78952178690786],[-85.11860526695267,45.57475686425863],[-85.14373032490325,45.37030065789657],[-85.36985584645846,45.27064973378733],[-85.39498090440904,44.93132115600155],[-85.52778478214782,44.748341441904415],[-85.65341007190072,44.84885142570425],[-85.56726701607016,45.04385797546975],[-85.65699936589365,45.14608607865078],[-85.80774971359713,44.95022046919468],[-86.0733574690747,44.88493193270932],[-86.08771464504645,44.741468964379635],[-86.25641146271462,44.691643502325014],[-86.22051852278523,44.56707984718847],[-86.26717934469345,44.34544244701446],[-86.5148406302063,44.048207794067935],[-86.43587616236162,43.789630827198266],[-86.53996568815688,43.659053754227536],[-86.39639392843928,43.31628893767937],[-86.23128640476405,43.015618045970456],[-86.20616134681346,42.71924245271452],[-86.26000075670757,42.44348429203291],[-86.36409028250281,42.24332338412383],[-86.61893015600155,41.89368609005089],[-86.93478802738026,41.70984731626316],[-87.22193154681547,41.62394134720346],[-87.4229320104201,41.642840660396594],[-87.60957529805297,41.845578747377466],[-87.68136117791178,42.07580674445744],[-87.83570081960819,42.30173944308442],[-87.82493293762937,42.835215510945105],[-87.91107599345993,43.23553732676326],[-87.87877234752347,43.36955063849638],[-87.70648623586236,43.67967118680186],[-87.73520058780588,43.88069115440154],[-87.64546823798237,44.10490573364733],[-87.51984294822948,44.17964392672926],[-87.54496800618006,44.32138877567775],[-87.46959283232832,44.55161677275772],[-87.189627900879,44.96826072269722],[-87.04964543515435,45.08938813907138],[-87.23987801678017,45.1675625709157],[-87.4049855404554,44.90469030559305],[-87.60957529805297,44.838542709417084],[-87.81057576165762,44.636663682126816],[-87.98286187331873,44.71999247211471],[-87.7639149397494,44.96568354362543],[-87.63111106201062,44.97685131960319],[-87.61316459204592,45.12375052669526],[-87.32602107261073,45.42528047809478],[-87.1716814309143,45.661521893008924],[-86.8378770895709,45.722515131041305],[-86.77326979769798,45.810998279172786],[-86.32460804858049,45.90635390482904],[-86.19539346483465,45.96305184440843],[-85.66417795387953,45.96734714286142],[-85.51342760617605,46.09448797706976],[-85.01451574115741,46.011159187081866],[-84.83146174751747,45.87199151720517],[-84.65558634186341,46.05239405223052],[-84.3756214104141,45.93212569554695],[-84.11360294892948,45.97851491883918],[-83.56085167401673,45.91236732266322],[-83.58238743797438,46.08933361892618],[-83.9879776591766,46.03263567934679],[-84.1243708309083,46.180393946129456],[-84.14590659486595,46.4183534804248],[-84.22487106271062,46.53432653865538],[-84.50483599415993,46.438970912999125],[-85.02528362313623,46.48278295721956],[-85.02887291712916,46.69754787986879],[-85.25858773267733,46.75338675975759],[-85.4811239602396,46.68036668605685],[-86.13796476094761,46.67263514884148],[-86.49330486624866,46.52487688205881],[-86.92760943939439,46.46474270371703],[-86.97785955529555,46.52659500144001],[-87.25782448674487,46.48793731536315],[-87.39062836448365,46.52487688205881],[-87.59521812208122,46.78259478923788],[-87.8177543496435,46.89083631025309],[-88.44229150441504,46.9724469808598],[-88.05464775317753,47.298030603596025],[-87.81416505565055,47.38479563234632],[-87.7998078796788,47.4732787804778],[-88.18027304293042,47.45781570604705],[-88.38845209452094,47.38479563234632],[-88.57509538215382,47.24562796246962],[-89.4365259404594,46.83929272881728],[-89.79186604576046,46.81867529624296],[-90.02875944929448,46.674353268222674],[-90.43793896448965,46.56181644875448],[-90.75379683586836,46.64600429843298],[-90.88660071360714,46.75596393882938],[-90.75020754187541,46.88825913118131],[-90.97274376943768,46.94152083199831],[-91.51113786837868,46.75768205821058],[-91.94185314753148,46.68036668605685],[-92.06029984929849,46.81008469933698],[-91.47883422244222,47.12535960578605],[-91.12708341113411,47.39939964708646],[-90.73585036590366,47.624473286022855],[-90.38768884858848,47.74130540394403],[-89.97492003940039,47.83064761176611],[-89.87441980759807,47.98527835607355],[-90.13284897508974,48.1115601305913],[-90.76097542385423,48.098674235232345],[-90.88660071360714,48.245573442324414],[-91.24911940689407,48.084070220492194],[-91.43935198851987,48.048848773177724],[-91.71213833198331,48.11499636935368],[-91.71572762597626,48.19918421903218],[-92.00646043940439,48.26533181520814],[-92.05671055530554,48.35896932148321],[-92.30796113481135,48.31601633695336],[-92.50896159841598,48.44745246961469],[-92.98633769947699,48.62355970618705],[-93.34885639276392,48.62699594494944],[-93.463713800538,48.54624433403333],[-93.79392884788848,48.51617724486244],[-93.83341108181081,48.62527782556825],[-94.22464412704127,48.64933149690496],[-94.2641263609636,48.699156958959584],[-94.6410022302223,48.74125088379883],[-94.82405622386223,49.29448532454324],[-95.1542712712127,49.384686592055914],[-95.1542712712127,48.998968790977905],[-96.93097179771797,48.999827850668495],[-98.86919055390554,48.999827850668495],[-99.85983569595696,48.998968790977905],[-101.45707152281523,48.998968790977905],[-103.37375451504515,48.998968790977905],[-105.05713339773398,48.998968790977905],[-106.11238583165832,48.998968790977905],[-107.44042460904609,48.998968790977905],[-108.99458890798907,48.998968790977905],[-110.17187733767337,48.998968790977905],[-111.76193457654576,48.99725067159671],[-113.69297474474745,48.99725067159671],[-115.20765680976808,48.998968790977905],[-117.03101815818158,48.998968790977905],[-118.19753870588704,49.00068691035909],[-119.42866654546545,48.999827850668495],[-120.71722308893088,48.999827850668495],[-121.75093975889757,48.99725067159671],[-122.75953137091369,49.00240502974029],[-122.79183501685016,48.89330444903448],[-122.49033432144321,48.75070054039539],[-122.46879855748557,48.472365200641995],[-122.37188761967619,48.287667367163664],[-122.36470903169031,48.12358696625965],[-122.23190515395153,48.02994945998459],[-122.39342338363383,47.80745300011999],[-122.42931632356323,47.65883567364673],[-122.32522679776797,47.34871512534124],[-122.57288808328082,47.32723863307632],[-122.49392361543615,47.51021834717346],[-122.47597714547145,47.74560070239701],[-122.63749537515375,47.86586905908058],[-122.69851337303372,48.10296953368533],[-123.14358582815828,48.156231234502336],[-123.24767535395353,48.11585542904428],[-123.97989132851328,48.164821831408304],[-124.65467859918598,48.390754530035295],[-124.73005377303772,48.16997618955189]]],[[[-70.83321517505175,41.35333754466544],[-70.45275001180012,41.34818318652186],[-70.6035003595036,41.48219649825498],[-70.83321517505175,41.35333754466544]]]]},"properties":{"name":"United States"},"id":"US"}]}'! !

!USBorder methodsFor: 'drawing' stamp: 'IGJ 3/9/2024 14:35:56'!
drawOn: aCanvas
	aCanvas strokeWidth: 0.05 color: Color black do: [
		aCanvas moveTo: edges first.
		edges do: [ :each |
			aCanvas lineTo: each
		]
	].! !

!USBorder methodsFor: 'initialization' stamp: 'IGJ 3/9/2024 14:49:56'!
initialize
	| coordinates mainlandBorder |
	super initialize.
	coordinates := self asJsonArray at: 'features' :: first :: at: 'geometry' :: at: 'coordinates'.
	"Ignore other edge sequences for small islands.
	Note that each edge sequence has a wrapper JSON array, thus the `first`s here:"
	mainlandBorder := (coordinates detectMax: [:each | each first size ]) first.
	edges := OrderedCollection new.
	mainlandBorder do: [ :each |
		edges add: each first @ each second
	]
! !
