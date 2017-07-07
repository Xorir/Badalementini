# Badalementini


On initial screen, users can sign up or sign in by using their email addresses, or can easily use Facebook to create an account for themselves easily

The app has 3 main sections; 

1)Stray animals: 
  - MapView zooms to users location 
  - Shows stray animal posts by pinning on map created by user the himself or other users. And only shows stray animals of user's current city(I may change it to state)
  - pin is tappable, which takes user to detail page of the stray animal post
  - In detail page, there will be info about the stray animal, address(which is reverse geocoded from the user's location who creates the post) and the is a navigate to the address button which gets user's location and target coordinates and shows in apple maps
  - Users can create a new stray animal here and the map will be updated with the new posts as soon as the user create the post.
2) Missing pet:
  - this section is a tableView, and shows missing pets in the users current city. 
  - Users can create missing pet posts
  - tapping on the missing pet cells will take users to detail viewController
3) Pet Adoption: 
  - This section is also a tableView, users can create and view other users posts
4) User Profile: 
  - for now, users own posts can be viewed and deleted from this part.
  - And Sign Out
  
  There is one important thing to mention is that the app depends on images, and each main sections has imageViews. To filter the images that users take and upload, I implemented a little piece of artificial intelligence.
 As soon as a user picks a photo from album or takes a photo,artificial intilligence will analyze the image and will only let users to create a post if there is an animal in the image.
 
  
  
