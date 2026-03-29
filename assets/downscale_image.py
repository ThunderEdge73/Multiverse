from PIL import Image
import os
from tkinter import Tk
from tkinter.filedialog import askopenfilename

if __name__ == "__main__":
    try:
        window = Tk()
        window.withdraw()
        big = askopenfilename(filetypes=[("Image files", ".png")],title="Select an image to downscale",initialdir="assets/2x/")
        if not os.path.isfile(big):
            raise FileNotFoundError()
        small = "assets/1x/" + os.path.basename(big)
        if os.path.isfile(small):
            os.remove(small)
        big_image = Image.open(big)
        new_dims = (int(big_image.width / 2), int(big_image.height / 2))
        small_image = big_image.resize(new_dims, Image.NEAREST)
        small_image.save(small)
        print("Success!")
    except FileNotFoundError:
        print("Something went wrong when getting the original image.")
