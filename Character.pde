final class Character {
  int x;
  int y;
  PImage image;
  int stepSize;
  boolean isHero;
  
  public Character(int x, int y, PImage image, int stepSize, boolean isHero) {
    this.x = x;
    this.y = y;
    this.image = image;
    this.stepSize = stepSize;
    this.isHero = isHero;
  }
  
  public void paint() {
    image(image, x, y);
  }
  
}