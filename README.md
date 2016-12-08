#Photos 

##Limitations and possible improvements.

There is a lot of room for improvement. This is what comes to mind (incomplete list):

- Remove Main.storyboard: Usually I do not use IB and if I do (due to time constraints) I try to get rid of it rather sooner than later. When working in a team I found IB to be more of a burden than helpful.
- Annotate everything (lightweight generics, nullable, ...) - useful for a later transition to Swift - if so planned.
- Make NSURLSession+FlickrClient better: Usually I have different environments (integration, preproduction, production) and I find it useful to have an environment without any timeouts so that I can debug HTTP-related things if desired. Usually when creating an NSURLSession(Configuration) I use NSProcessInfo to figure out which environment I am running on and then I make minor adjustments to the configuration.
- FlickrClient uses a lot of hard coded stuff - usually I try to make the most important things configurable. 
- Add loading indicators where it makes sense.
- Add an empty state to my view controllers.
- Display errors when they do occur. I have left this out because in my own Apps and in the REWE app we implemented those three things (loading, empty state, error state) for our view controllers once and then reused it. So usually you get this more or less for free.
- Remove -reloadData where it is not needed
- Proper type checking in +newFromJSONDictionary: (just like I showed did it in +[FlickrResponse newFromJSONDictionary:].
- Tests with stubbing
- Recent Searches should use a plist/database instead of NSUserDefaults.  
