VAR score = 0
VAR characters = "Sophia, Dani"
VAR music_volume = -6.0
VAR fx_volume = -3.0

/* ---------------------------------

In general, I'm designing the system to let the Ink file look somewhat like a theatrical script or screenplay.

The parser on the Godot side expects each tag to be a space-delimited string that can contain a single function name and a set of arguments for that function, so for example "# show sophia enter left" will call the function called "show" and send it the other three tags ("sophia," "enter," and "left") as arguments.

A tag whose first word doesn't match a function, but does match a string in the `characters` variable defined in the Ink, will be taken as a character name, and displayed in the name box above the textbox. The convention I'm adopting currently is to capitalize character names in the Ink file when used for this purpose. That helps distinguish character names in the script from tag groups intended to be processed as functions. I might also use that as a way to identify dialogue lines for export to a voice acting script.

 ----------------------------------*/

# background industrial_building
# fade_in
# show sophia happy enter right
# audio music cephalopod

# Sophia
This looks like the right place. 

# show dani surprised enter left
# Dani
Hey, Sophia, what're you doing down here?

# Sophia neutral
Oh hi, Dani. I'm trying to figure out how our system works.

# Dani neutral
Our system?

# audio fx fireball
# Sophia
Yeah, the system that displays us on the screen, draws our backgrounds, and generally turns our world into a playable game.
Like the way each sentence I say comes out as a separate line in that text box at the bottom. Or the way we get choices.

* [Like]
-> like

* [This]
-> this

* [Or something else]
-> something_else

=== like ===
# Sophia
You chose "Like," didn't you?

# Dani
I didn't choose anything. Someone else did.

# Sophia
Right, the player. That's who's controlling this experience.
-> resume_path

=== this ===
# Dani
Someone just clicked "This," but it wasn't me.

# Sophia
It wasn't me either. I think it was the player, the person controlling this experience.
-> resume_path

=== something_else ===
# Sophia
Hmm, what does "Something else" entail?

# Dani
More importantly, who chose it?

# Sophia
Oh that? That was the player, the person controlling this experience.
-> resume_path

=== resume_path ===
# Dani surprised
You mean we're just puppets with no free will?

# Sophia angry
No, silly, we're characters in a game. We have our own thoughts and internal lives, but they're being, how shall I put this?

# Sophia happy
Guided. Consider it the divine hand of fate.

# Dani neutral
Hmm. I'll have to think about that.

# Dani 
By the way, what's that number up there for?
~score = score + 10

# Sophia 
Oh, that? That's the score. It's just an arbitrary value that's there to test out tracking a variable. 

And just for asking about it, you earned us some points. See? Our score is now {score}. Good job!

# Dani 
Wow, that was easy. 
# fade_out

    -> END
