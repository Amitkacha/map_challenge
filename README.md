# map_challenge

flutter version must be sdk: ^3.24.0 - ^3.24.3

Git clone :

1. master branch
2. git clone https://github.com/Amitkacha/map_challenge.git
3. cd map_challenge
4. flutter pub get
5. flutter run

Drive link include code, android APK, video of functionality
https://drive.google.com/drive/folders/1X5G6nASN2pcV0YLi2wLOmxOWnYvKP0Py?usp=sharing

-------------------------------------------------------
## **UI parts explore map screen:**

=> screen animation as per category change from FAB
=> provide animate Floating buttons
=> from object of "Brightness brightness" use theme effect for dark and light mode,
   as per device's dark/light mode map will update on spot via mapStyle.
=> On-tap of marker, bottom sheet displaying with marker details (title, description, image).
=> User can enable current location and permission handling process, 
   from top tight corner icon (SvgIcons.liveLocationIcon)

## **logical parts contains in cubit:**

function : generateNearbyLocations ,
=> It's generate random 7 latLng nearest to provided reference LatLng (from AppConstant.defaultLatLng)
=> If user enable current location 7 latLng will be user's nearest location

function : addMarkerForListing
=> custom marker with blinking and onTap functionality

-------------------------------------------------------
