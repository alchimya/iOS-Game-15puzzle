# iOS-Game-15puzzle
A simple SpriteKit implementation of the famous "Fifteen Puzzle" game
<br/>
<br/>
![ScreenShot](https://raw.github.com/alchimya/iOS-Game-15puzzle/master/screenshots/iOS-Game-15puzzle.gif)
<br/>
To solve te implementation of this game we have to focus mainly on these issues:
<br/>

1) <b>Generate a random series (NSArray) of 16 numbers from 0 to 15, where 0 is the empty tile.</b>
<br/>
You can find this implementation in the TileSeries class (an NSArray subclass) where in the init method,
will be added a 16 random numbers into an array.

2) <b>Retrieve the “train” of tiles when the user is swiping his finger towards the empty tile.</b>
<br/>
To solve this issue (see getTrainTilesFromNode into the GameScene class), starting from the touched tile, you have
to look toward in the swipe direction if thre is the empty tile.
<br/>
All the tiles before the empty tile are the "train of tiles".

3) <b>Move the train of tiles from the first tile to the empty tile when the user swipe his finger.</b>
<br/>
I have solved this issue by moving the empty tile (last tile into the train of tiles) 
from its position to the position of the first tile of the train tiles collection.
<br>
I used a moveTo SKAction to have a pleasant swiping effect with also a sound effect.
<br>
<br>
Enjoy!
;-)
