#!/usr/bin/env python3
"""
Regenerate the blurred wallpaper that the theme cross-fades to.

Usage
    python3 make_blur.py [source] [destination] [radius]

Defaults
    source       assets/background.jpg        (next to this script)
    destination  assets/background_blur.jpg
    radius       48                           (higher = blurrier)

Requires Pillow:  pip install pillow
"""
import os
import sys

try:
    from PIL import Image, ImageFilter
except ImportError:
    sys.exit("Pillow is required:  pip install pillow")

here = os.path.dirname(os.path.abspath(__file__))
src = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "assets", "background.jpg")
dst = sys.argv[2] if len(sys.argv) > 2 else os.path.join(here, "assets", "background_blur.jpg")
radius = int(sys.argv[3]) if len(sys.argv) > 3 else 48

image = Image.open(src).convert("RGB")
image.filter(ImageFilter.GaussianBlur(radius)).save(dst, quality=88)
print("wrote %s from %s (radius %d)" % (dst, src, radius))
