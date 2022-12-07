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
# Sophia
You chose "Like," didn't you?

# Dani
I didn't choose anything. Someone else did.

# Sophia
Right, the player. That's who's controlling this experience.

* [This]
# Dani
Someone just clicked "This," but it wasn't me.

# Sophia
It wasn't me either. I think it was the player, the person controlling this experience.

* [Or something else]
# Sophia
Hmm, what does "Something else" entail?

# Dani
More importantly, who chose it?

# Sophia
Oh that? That was the player, the person controlling this experience.

// Gather the weave.

- # Dani surprised
You mean we're just puppets with no free will?

# Sophia angry
No, silly, we're characters in a game. We have our own thoughts and internal lives, but they're being, how shall I put this?

# Sophia happy
Guided. Consider it the divine hand of fate.

# Dani neutral
Hmm. I'll have to think about that.
-> topics

=== topics ===
# Sophia neutral
Okay, what part of our system should we explore next?

* [The infrastructure]
-> infrastructure

* [The story]
-> story

* [The graphics and audio]
-> resources

* -> all_done

=== infrastructure ===
# Sophia neutral
Good choice, infrastructure is always important. The system runs in the Open Source game engine Godot.

# Dani happy
Excellent. I love Open Source!

# Sophia neutral
Glad you approve. Anyway, in addition to the textbox node, there are several others. You can look at the code to see them all.

# Dani neutral
So the code for this demo is free to browse? Oh, yeah, I see it's under the MIT license, so people can even copy it and reuse it. Nice.
Is the whole system just in Godot?

# Sophia
No, there's also a middleware layer that uses Ink, the narrative scripting language.
Ink provides a simple but powerful way to write anything from a simple dialogue script to a complex branching narrative.

# Dani
Okay, so then the Godot system parses the story coming in from the Ink file, and uses it to run the game itself?

# Sophia
Exactly.

# Dani
Very cool. Let's learn more about the rest of the system.
-> topics

=== story ===
placeholder text.
-> topics

=== resources ===
placeholder text.
-> topics

=== all_done ===
# Sophia neutral
Oh, it looks like that's all there is to explore for now.

# Dani neutral
Oh, well. Is there more documentation somewhere for folks who want to use this system?

# Sophia
Not much. At this point the best thing to do would be to fork the repository, download the code, and start reading the scripts.

# Dani 
Good to know. In that case, I guess this is goodbye. 

# Sophia
Indeed it is. Goodbye.

# fade_out

    -> END
