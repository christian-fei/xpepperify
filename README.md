#xpepperify

[xpepperify](http://xpeppers.com) your avatar!

![watermarked profile picture](trollface.png)

# Run

- `docker build . -t xpepperify:latest`
- `docker run -p "8080:8080" -v "`pwd`:/xpeppers"`

# Usage

You can use three overlays:

1. http://server:port/url-of-the-image
2. http://server:port/red/url-of-the-image
3. http://server:port/white-on-red/url-of-the-image

# Example

*1. The red overlay 

- `wget "http://localhost:8080/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg"`

*2. The white overlay 

- `wget "http://localhost:8080/white/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg"`

*3. The white on red overlay  

- `wget "http://localhost:8080/white-on-red/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg"`

# Dependencies

- docker
- job @ xpeppers