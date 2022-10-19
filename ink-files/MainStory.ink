VAR score = 0

# background community_garden
# tagtest second tag group
This is some text that should appear in the text box initially, just to make sure it's working.
Now it is two lines long.
Now it is three lines long, but only the last line will print. Why?

* [Start]
-> intro

=== intro ===
# show sophia left
Well, this looks like the right place. Now I just need to find a terminal.

# show dani flip right
Hey, Sophia! What are you doing down here?

# sophia 
Oh, hi Dani. I'm trying to figure out how our system works.

# dani 
Our system?

# sophia 
Yeah, the system that displays us on the screen, draws our backgrounds, and generally turns our world into a playable game.

Like the way each sentence I say comes out as a separate line in that text box at the bottom. Or the way we get choices.

* [Like] 
* [This] 

- The choice has been made! 

# dani 
But no matter which choice you made, you got the same next line. So our choices don't matter?

# sophia 
Sure they do! Some of them, at least. That one didn't, but others will, so choose wisely, okay?

# dani 
Um, okay. By the way, what's that number up there for?
~score = score + 10

# sophia 
Oh, that? That's the score. It's just an arbitrary value that's there to test out tracking a variable. 

And just for asking about it, you earned us ten points. See? Our score is now {score}. Good job!

# dani 
Wow, that was easy. 

    -> END
