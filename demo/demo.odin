package demo

import "core:fmt"

import ft "../"
import rl "vendor:raylib"

FONT_FILE_NAME :: "LiberationMono.ttf"

main :: proc() 
{
	rl.InitWindow(1280, 720, "Freetype Demo"); 

	rl.SetTargetFPS(165); 

	ftlib : ft.Library; 

	ok := ft.InitFreeType(&ftlib); 

	face: ft.Face;

	ft.NewFace(ftlib, FONT_FILE_NAME, 0, &face);

	ft.SetPixelSizes(face, 0, 48);  

	ft.LoadChar(face, 'J', {.Render}); 

	pixelBuffer := make([]u8, (4 * face.Glyph.Bitmap.Width * face.Glyph.Bitmap.Rows));

	for i:= 0; i < int(face.Glyph.Bitmap.Width * face.Glyph.Bitmap.Rows); i += 1
	{
		j := i * 4; 
		pixelBuffer[j]     = 1;
		pixelBuffer[j + 1] = 1;
		pixelBuffer[j + 2] = 1;
		pixelBuffer[j + 3] = face.Glyph.Bitmap.Buffer[i]; 
	}

	fontImage: rl.Image; 

	fontImage.width = cast(i32)face.Glyph.Bitmap.Width; 
	fontImage.height = cast(i32)face.Glyph.Bitmap.Rows;
	fontImage.data = raw_data(pixelBuffer);  
	fontImage.mipmaps = 1; 
	fontImage.format = .UNCOMPRESSED_R8G8B8A8; 

	fontTexture := rl.LoadTextureFromImage(fontImage); 

	for !rl.WindowShouldClose()
	{
		rl.BeginDrawing();

		rl.ClearBackground(rl.WHITE);
		rl.DrawTexture(fontTexture, 200, 200, rl.WHITE); 
		rl.EndDrawing(); 
	}

	rl.CloseWindow(); 
}

