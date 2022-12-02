VAR score = 0
VAR characters = "Sophia, Dani"
VAR music_volume = -0.0
VAR fx_volume = -3.0

/* ---------------------------------

In general, I'm designing the system to let the Ink file look somewhat like a theatrical script or screenplay.

The parser on the Godot side expects each tag to be a space-delimited string that can contain a single function name and a set of arguments for that function, so for example "# show sophia enter left" will call the function called "show" and send it the other three tags ("sophia," "enter," and "left") as arguments.

A tag whose first word doesn't match a function, but does match a string in the `characters` variable defined in the Ink, will be taken as a character name, and displayed in the name box above the textbox. The convention I'm adopting currently is to capitalize character names in the Ink file when used for this purpose. That helps distinguish character names in the script from tag groups intended to be processed as functions. I might also use that as a way to identify dialogue lines for export to a voice acting script.

 ----------------------------------*/

# background community_garden
# fade_in
# show sophia happy enter right
# audio music mountain_trials

# Sophia
Okay, I just entered the scene. Wasn't that smooth?
I think it was, and this second line displays nicely too.

# show dani surprised enter left
~ music_volume = -24.0
# audio music cephalopod

# Dani
Hey, Sophia, I'm surprised to see how smoothly you entered. Was my animation that good?

# Sophia
Sorry, gotta go.

# audio fx fireball

# show sophia neutral leave right

# Dani
Well, that was abrupt.

# show dani neutral leave left

# show sophia angry enter left

# Sophia
Wait, where did he go? I just needed to get over here.

# show dani surprised enter right

# Dani
Oh, there you are! 

# show sophia neutral none left

# Sophia
Here's my neutral expression, hopefully with no animation shenanigans.

* [Start]
# fade_out
-> intro

=== intro ===
# background industrial_building
# fade_in
# show sophia neutral enter left

# Sophia
Well, this looks like the right place. Now I just need to find a terminal.

# show dani neutral enter right
# Dani
Hey, Sophia! What are you doing down here?

# Sophia 
Oh, hi Dani. I'm trying to figure out how our system works.

# Dani 
Our system?

# Sophia 
Yeah, the system that displays us on the screen, draws our backgrounds, and generally turns our world into a playable game.
Like the way each sentence I say comes out as a separate line in that text box at the bottom. Or the way we get choices.

* [Like] 
* [This] 

- The choice has been made! 

# Dani 
But no matter which choice you made, you got the same next line. So our choices don't matter?

# Sophia 
Sure they do! Some of them, at least. That one didn't, but others will, so choose wisely, okay?

# Dani 
Um, okay. By the way, what's that number up there for?
~score = score + 10

# Sophia 
Oh, that? That's the score. It's just an arbitrary value that's there to test out tracking a variable. 

And just for asking about it, you earned us some points. See? Our score is now {score}. Good job!

# Dani 
Wow, that was easy. 
# fade_out

    -> END
