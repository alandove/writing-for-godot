VAR score = 0

/* ---------------------------------

In general, I'm designing the system to let the Ink file look somewhat like a theatrical script or screenplay.

The parser on the Godot side expects each tag to be a space-delimited string that can contain a single function name and a set of arguments for that function, so for example "# show sophia enter left" will call the function called "show" and send it the other two tags ("enter" and "left") as arguments. 

A tag whose first word doesn't match a function, but which is a single string long, will be taken as a character name and displayed in the name box above the textbox. The convention I'm adopting currently is to capitalize character names in the Ink file when used for this purpose. That helps distinguish character names in the script from tag groups intended to be processed as functions.

 ----------------------------------*/


# background community_garden
# show sophia happy enter left

# Sophia
This is some text that should appear in the text box initially, just to make sure it's working.
Now it is two lines long.

# show dani surprised enter right

# Dani
Now the text is three lines long, and I've finally fixed the system so it will feed one line at a time.

* [Start]
-> intro

=== intro ===
# background industrial_building
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

    -> END
