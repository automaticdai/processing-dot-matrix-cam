import processing.video.*;

DotMatrix matrix;
Capture cam;

int[][] dot_data;
int dot_size = 16;
int columns = 32;
int rows = 16;


void setup() {
  matrix = new DotMatrix(rows, columns);
  matrix.setDotSize(dot_size, 2);
  matrix.setBgColor(color(200, 200, 200, 100));
  matrix.setDotColor(color(250, 1, 1));

  dot_data = new int[rows][columns];

  size(100, 100);
  surface.setResizable(true);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No cameras found.");
    exit();
    return;
  }
  cam = new Capture(this, cameras[0]);
  cam.start();
}

void draw() {
  background(200);
  surface.setSize(matrix.getMatrixWidth(), matrix.getMatrixHeight());

  if (cam.available()) {
    cam.read();
    cam.loadPixels();

    int cropW, cropH;
    if ((float)cam.width / cam.height > (float)columns / rows) {
      cropH = cam.height;
      cropW = int(cam.height * (float)columns / rows);
    } else {
      cropW = cam.width;
      cropH = int(cam.width * (float)rows / columns);
    }
    int offsetX = (cam.width - cropW) / 2;
    int offsetY = (cam.height - cropH) / 2;

    PImage frame = cam.get(offsetX, offsetY, cropW, cropH);
    frame.resize(columns, rows);
    frame.loadPixels();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        color c = frame.pixels[i * columns + j];
        float luma = 0.299 * red(c) + 0.587 * green(c) + 0.114 * blue(c);
        dot_data[i][j] = int(luma);
      }
    }
  }

  matrix.loadData(dot_data);
  matrix.draw();
}
