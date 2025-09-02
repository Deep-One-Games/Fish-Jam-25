extends TextureRect

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            OS.shell_open("https://github.com/Deep-One-Games/Fish-Jam-25")
