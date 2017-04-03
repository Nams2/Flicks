# Flicks

Flicks is an iOS application for checking out the latest playing movies and top rated movies.

Submitted by: Namrata Mehta

Time spent: 15 hours spent in total

## User Stories

The following **required** functionality is complete:

* [+] User can view a list of movies currently playing in theaters from The Movie Database. Poster images must be loaded asynchronously.
The Movie Database API
Ensure you can hit the "Now Playing" endpoint in a browser. This shows the data we will be using from The Movies Database.
Note: It's helpful to install the JSONView Chrome Extension to view the returned JSON more easily.
Sample Request: https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed
* [+] User can view movie details by tapping on a cell.
Hint: You'll need to set the content size of the UIScrollView to get it to scroll properly.
Hint: Calling the sizeToFit method on the UILabel will help figure out how much space the overview label needs to fit all the text.
* [+] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries listed on CocoaControls.
* [+] User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error. See this screenshot for what the error message should look like.
Hint: Using the hidden property of a view can be helpful to toggle the network error view's visibility.
Hint: You can simulate a network error, by turning off the wifi on your computer before running the simulator. You will also want to Reset Content and Settings in your simulator (Found under the Simulator drop down menu) before you run the app, otherwise the images will be fetched from the cache instead of the network. The setImageWithURL method stores images in cache automatically behind the scenes.
* [+] User can pull to refresh the movie list.

The following advanced user stories are optional: 
(high, med, and low refer to the effort to implement the feature, with high being the most work and low being the least)

* [+] Add a tab bar for Now Playing or Top Rated movies. (high)
Hint: If you are using a storyboard for your app, there isn't a good way to use the same UIViewController for each tab of your UITabBarController. Instead, you might want to use a xib approach for each UIViewController and set up your tab bar programmatically.
* [+] Implement a UISegmentedControl to switch between a list view and a grid view. (high)
Hint: The segmented control should hide/show a UITableView and a UICollectionView
* [+] Add a search bar. (med)
Hint: Consider using a UISearchBar for this feature. Don't use the UISearchDisplayController.
* [ ] All images fade in as they are loading. (low)
Hint: The image should only fade in if it's coming from network, not cache.
* [ ] For the large poster, load the low-res image first and switch to high-res when complete. (low)
* [ ] Customize the highlight and selection effect of the cell. (low)
* [ ] Customize the navigation bar. (low)

Additional Requirements
* [+] Must use Cocoapods.
* [+] Asynchronous image downloading must be implemented using the UIImageView category in the AFNetworking library.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/Nams2/Flicks/blob/master/flickGIF.gif' title='Flicks Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).


## License

    Copyright [2017] [Namrata Mehta]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.







