# Nyan-Tunes

<img src="http://thepsguy.github.io/images/NyanTunes1.0.3.gif" alt="Demo GIF" width="288px"/>

Jailbroken? Get it on [Cydia](http://cydia.saurik.com/package/net.thepsguy.nyantunes/)
##Building
> Swift 3, XCode 8.0+

> Clone, `cd Nyan-Tunes` , `pod install`

> Build & Run.


##Using
`The app needs a vk.com account to log in. You can get one for free at` http://vk.com/join 


The app also provides and option to continue offline, in which case only the downloaded tracks are accessible.

### The 'Profile' tab
`Lists tracks saved to the user's vk.com profile.`

##### Tapping a cell
>Streams the track if not already downloaded, else plays from local storage.

##### Tapping the download icon
>Starts downloading the audio track to local storage and enables the download progress indicators.
    Also replaces itself with the 'Cancel' button to cancel an in-progress download.

##### Swiping left on a Cell
>Shows the 'Remove' action button, tapping which removes the song from the user's
  vk profile, and refreshes the table.
  

### The 'My Music' tab
`Lists the downloaded tracks.`

##### Tapping a cell
>Plays the track from local storage.

##### Swiping left on a Cell
>Shows the 'Delete' action button, tapping which removes the song from the device, and
  refreshed the table.


### The 'Search' tab
`Allows searching for and adding tracks to the user's profile.`

##### Swiping left on a Cell
>Shows the 'Add to profile' action button, tapping which adds the song to the user's
  vk profile.
  
  
### The 'Mini Player' view
`Located at the bottom throughout, it allows playback control, and shows the currently playing track.`

##### Tapping the Play/Pause button
>Toggles the audio playback.


### The 'Control Center / Lockscreen' integration
`Current track info`
>The currently playing item is shown on the iOS Lockscreen and in the Control Center.
>Playback control works from the lockscreen and the Control Center.
>The current progress and total duration of the song is also shown.

##The code
>The code uses vk's open source iOS SDK, available at https://github.com/VKCOM/vk-ios-sdk

> The `MiniPlayerView`, `Download Manager`, `Audio Manager` ,`VKClient`, and `AudioTableViewCell` are all
  classes written either from scratch, or by extending other native classes to provide shared instances,
  custom properties, and custom functions, that make things more centralized and easier to handle.
