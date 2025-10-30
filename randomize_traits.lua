-- Randomize Traits Script for Aseprite
-- This script automatically detects visible top-level group layers for traits.
-- Each group should contain image layers representing the trait options.
-- The script creates a copy of the sprite, randomizes one visible trait per group,
-- flattens the image, resizes based on the upscale percentage, and saves to the specified file.
-- Supports generating multiple images with filenames like 1.png, 2.png, etc. in the selected directory.

if not app.isUIAvailable then
  return
end

local sprite = app.activeSprite
if not sprite then
  app.alert("No active sprite found.")
  return
end

-- Automatically detect visible top-level group names (case-insensitive)
local group_names = {}
local found_groups = {}
for _, layer in ipairs(sprite.layers) do
  if layer.isGroup and layer.isVisible then
    table.insert(group_names, layer.name:lower())
    table.insert(found_groups, layer.name)
  end
end

if #group_names == 0 then
  app.alert("No visible top-level group layers found.")
  return
end

-- Show dialog for number of images, upscale percentage, and save file
local dlg = Dialog{ title = "Randomize and Export" }
dlg:number{ id = "num_images", label = "Number of Images:", text = "1", decimals = 0 }
dlg:number{ id = "upscale", label = "Upscale %:", text = "100", decimals = 0 }
dlg:file{ id = "output", label = "Save as:", save = true, filename = app.fs.joinPath(app.fs.userConfigPath, "1.png"), filetypes = {"png"} }
dlg:button{ id = "ok", text = "OK" }
dlg:button{ id = "cancel", text = "Cancel" }
dlg:show()

if not dlg.data.ok then
  return
end

local num_images = tonumber(dlg.data.num_images) or 1
if num_images < 1 then
  num_images = 1
end

local upscale_pct = tonumber(dlg.data.upscale) or 100
if upscale_pct < 100 then
  app.alert("Upscale % should be at least 100. Setting to 100%.")
  upscale_pct = 100
end

local output_file = dlg.data.output
if output_file == "" then
  return
end

-- Find the group layers (we already have them, but verify)
local groups = {}
for _, name in ipairs(group_names) do
  local found = false
  for _, layer in ipairs(sprite.layers) do
    if layer.name:lower() == name and layer.isGroup and layer.isVisible then
      groups[name] = layer
      found = true
      break
    end
  end
  if not found then
    app.alert("Missing or non-group layer: " .. name .. ". Check your top-level layers.\nFound visible top-level groups: " .. table.concat(found_groups, ", "))
    return
  end
end

-- Seed random number generator once
math.randomseed(os.time())

-- Get the directory and extension from output_file
local dir = app.fs.filePath(output_file)
local extension = app.fs.fileExtension(output_file)
if extension == "" then
  extension = "png"
end

-- Generate multiple images
local generated_files = {}
for i = 1, num_images do
  -- Create a duplicate sprite to work on
  local temp_sprite = Sprite(sprite)

  -- Randomize visibility in each group
  for _, name in ipairs(group_names) do
    local group = nil
    for _, layer in ipairs(temp_sprite.layers) do
      if layer.name:lower() == name and layer.isGroup then
        group = layer
        break
      end
    end
    if group then
      local traits = {}
      for _, sub_layer in ipairs(group.layers) do
        if sub_layer.isImage then
          sub_layer.isVisible = false
          table.insert(traits, sub_layer)
        end
      end
      if #traits > 0 then
        local random_index = math.random(1, #traits)
        traits[random_index].isVisible = true
      else
        app.alert("No image layers found in group: " .. name)
      end
    end
  end

  -- Flatten the sprite to combine layers
  temp_sprite:flatten()

  -- Calculate scale factor and resize (uses nearest-neighbor by default for pixel art)
  local scale_factor = upscale_pct / 100
  temp_sprite:resize(math.floor(temp_sprite.width * scale_factor), math.floor(temp_sprite.height * scale_factor))

  -- Save the result with filename like 1.png, 2.png, etc.
  local file_i = app.fs.joinPath(dir, i .. "." .. extension)
  temp_sprite:saveAs(file_i)
  table.insert(generated_files, file_i)

  -- Close the temporary sprite without saving changes
  temp_sprite:close()
end

-- Shortened alert message
if num_images == 1 then
  app.alert("Randomized art exported to: " .. generated_files[1])
else
  app.alert("Generated " .. num_images .. " randomized arts exported to: " .. dir .. " (files 1." .. extension .. " to " .. num_images .. "." .. extension .. ")")
end