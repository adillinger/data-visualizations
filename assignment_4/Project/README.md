# Max Chehab Assignment 4 Writeup

There is a lot going on here, I'll try my best to explain everything.

## Explanation of which visual decisions you made

* Three different, fixed, sizes based on magnitude of quake (I'll explain later why they are fixed sizes).
* Three different colors relative to magnitude of quake
* Color blind friendly:
  * included a black and white texture that is toggleable for less contrast
  * Magnitude scale is color blind friendly
  * Used the android app 'Color Blind' to visualization.

## Description of any mastery that you have attempted

The obvious mastery is the 3D visualization of the earth.

To preface, I only used documentation and the occasional StackOverflow comment to produce these results. I tried my best to implement everything on my own and test my knowledge. Also, if you prefer to read this readme file on github the link is provided below, unless, of course, you prefer this shebatical of number symbols and asterixs. To each his own.
https://github.com/maxchehab/data-visualizations/tree/master/assignment_4/Project

To be fair, Processing does a lot of hand holding when it comes to 3D graphics. The only things that weren't straightforward was calculating the 3d coordinates for latitude and longitude and occulsion.

My method for converting latitude and longitude to 3d points goes as follows. I had to swap the z and y axis due Processing's 3d space and subtract longitude by 180 degrees.
Most importantly, latitude and longitude **must be converted to radians** (learned this the hard way).
I referenced this StackOverflow comment https://stackoverflow.com/a/10475267/9302674

```java
    float lat = radians(-latitude);
    float lon = radians(-longitude - 180);
    float x = radius * cos(lat) * cos(lon);
    float y = radius * cos(lat) * sin(lon);
    float z = radius * sin(lat);
    return new Vector3(x, z ,y);
```

Before implementing occulsion, framerate was really, really bad. I also created occulsion in a really hacky method. In this model the camera's position is constant. There is also a rotating sphere in the center of the model (0, 0, 0). To check if an object is visible, one simply had to check if its absolute z-axis was greater than zero. Because of this, the model now runs at a steady 60fps on my moderate spec'd laptop.

I also noticed that creating a different sphere for each individual data point was a resource hog. I optimized this by having three fixed sizes, rendering each of these spheres in memory, and referencing them when posistioning them. Instead of calculating 13,000 spheres I only calculate three (technicaly four if you include the globe).
