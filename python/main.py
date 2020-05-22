import cv2
import numpy as np

from os import listdir
from os.path import isfile, join

screens_path = "/Users/andrewfinke/Library/Application Support/loggercli/screens/"
paths = [join(screens_path, f) for f in listdir(screens_path) if isfile(join(screens_path, f)) and ".png" in f]

combined_image = None
for index, path in enumerate(paths):
    image = cv2.imread(path)
    if combined_image is None:
        combined_image = np.zeros(image.shape)
    combined_image += image
    print("{} / {}".format(index + 1, len(paths)))

result = combined_image / len(paths)
cv2.imwrite("result.png", result)
