# aseprite-randomize-traits-script
This Lua script for Aseprite automates the randomization of pixel art traits organized in group layers. It duplicates your sprite, randomly selects one visible sub-layer (trait) from each visible top-level group, flattens the image, applies an optional upscale, and exports the result as PNG(s). Ideal for generating variations of characters or assets quickly.

Features
- Automatic Group Detection: Detects all visible top-level group layers (e.g., "Base", "Body", "Face", "Eyes") without manual input.
- Randomization: Picks one random sub-layer per group to make visible, hides the rest.
- Multiple Exports: Generate 1 or more randomized images in one run, named sequentially (e.g., 1.png, 2.png).
- Upscaling: Resize the output with a percentage (minimum 100% for pixel art preservation using nearest-neighbor).
- User Dialog: Simple UI for setting number of images, upscale %, and save location.
- Error Handling: Alerts for missing groups or empty groups.

Requirements
- Aseprite v1.2.40 or later (tested on Windows; should work on macOS/Linux).
- Your sprite must have top-level group layers (folders) containing image sub-layers for traits.
- All relevant groups should be visible in the Layers panel.

Installation
1. Download the randomize_traits.lua file from this repository.
2. Open Aseprite.
3. Go to File > Scripts > Open Scripts Folder to access the scripts directory (e.g., %APPDATA%\Aseprite\scripts on Windows).
4. Copy the .lua file into this folder.
5. In Aseprite, go to File > Scripts > Rescan Scripts Folder (or restart Aseprite).
6. The script will appear in File > Scripts menu as "Randomize Traits Script" (or run it directly via File > Scripts > Run Script...).

Usage
1. Open your Aseprite file with the layered traits.
2. Ensure only the groups you want to randomize are visible (hide any others).
3. Run the script from File > Scripts.
4. In the dialog:
- Set "Number of Images" (default: 1).
- Set "Upscale %" (default: 100; higher values enlarge with nearest-neighbor for crisp pixels).
- Choose "Save as" (select a folder and filename like "output/1.png"; it will auto-number multiples).
5. Click OK. The script will export the randomized image(s) and show a confirmation alert.

Example Layer Setup
- Top-level groups: "Base", "Body", "Face", "Eyes".
- Inside each: Multiple image layers (e.g., different clothing in "Body").
- The script randomizes one per group.
If no visible groups are found or a group has no sub-layers, it will alert you.

Limitations
- Works only on the active sprite.
- Assumes sub-layers are images; ignores nested groups or other types.
- Randomization is with replacement (possible duplicates in multiples).
- No advanced resizing filters; uses Aseprite's default (nearest-neighbor).

Contributing
Feel free to fork this repo, make improvements, and submit a pull request! Suggestions for features like custom randomization rules or GIF export welcome.

License
MIT License - Free to use, modify, and distribute. See LICENSE for details.

