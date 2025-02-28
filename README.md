Godot Tabs
==========

What is this ?
---------------

Godot Tabs is a very simple plugin that allows you to organize your scenes into tabs inside the editor.
Its purpose is to overcome the slowness of the workflow when using the file system directly.
Basically, you create shortcuts to your scenes which you classify into tabs using a simple drag and drop from the file system (a bit like Unity prefabs)
You can then very quickly access your scenes and incorporate them into other scenes.




https://github.com/Cevantime/godot_tabs/assets/5015561/103a663a-d5da-4e8d-8f08-dbd237b0056f





How does it work ?
-------------------

Just download or clone it. Activate it like any Godot plugin (Project -> Project Settings -> Plugins) and you will see a "My tabs" tab appear in the bottom panel:

![Capture d’écran du 2023-12-26 13-09-13](https://github.com/Cevantime/godot_tabs/assets/5015561/05b46149-c0da-4708-bb6c-2ba6a2bae685)

![Capture d’écran du 2023-12-26 13-11-10](https://github.com/Cevantime/godot_tabs/assets/5015561/0c021a54-f498-452f-8baf-65006c5dc184)



You can then create as many tabs as you wish and fill them with your scene shortcuts.
![Capture d’écran du 2023-12-26 13-12-01](https://github.com/Cevantime/godot_tabs/assets/5015561/9349d033-4bb7-45f4-afa0-4bb7ef75a9f5)

![Capture d’écran du 2023-12-26 13-13-01](https://github.com/Cevantime/godot_tabs/assets/5015561/c16ae82c-121e-4ea4-9f19-b98f9000aadd)



Then you will be able to access your scenes and incorporate them in other scenes using a simple drag and drop.



https://github.com/Cevantime/godot_tabs/assets/5015561/e7e59e36-b1b4-4b6e-b067-5fed46506be1


Features
---------

 - Creation of tabs of scenes in the bottom panel
 - Drag and drop scenes from file system to make shortcuts in tabs
 - Generate or refresh thumbnails in one click
 - Edit your shortcuts (you can give them custom names)
 - Supports refactoring : shortcuts are still valid when scenes are moved in the filesystem

Warning and recommendations
---------------------------

 - Data are stored in a `addons/godot_tabs/data.json` file that is created and updated on the fly. If you work with a team and don't want to share your tabs, just gitignore it.
