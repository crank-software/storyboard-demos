-- ------------------MAIN TOGGLES ----------------------------
--this is the location of main toggles, animations on and off, cool things etc etc. Turn most off for better performance
--1 turns on animations and bgs, 0 turns them all off
MAINTOGGLE_bgAnimationOn = 1
MAINTOGGLE_automatedSelection = 0








-- --------------MAIN THINGS TO KEEP IN MIND AND EXAMPLES --------------------
--The name should be kept under 15 characters as not to crowd the boxes
--The description should be kept under 50 characters for readablilty sake
--icon file should be as square as you can get it. Make sure your icon is transparent around the outside (this is important to allow the colour to show through)
--We only support 3 apps

-- -----EXAMPLE ENTRY
--    name = "White Goods",
--    desc = "Select your load and wash your clothes in this demo",
--    thumb = "images/ThumbImages_270/homeThumb.png",
--    icon = "images/ThumbImages_270/homeIcon.png",
--    gapp_file = "/../../",
    
--    image01 = "images/ThumbImages_270/automation1.png",
--    image02 = "images/ThumbImages_270/automation2.png",
--    image03 = "images/ThumbImages_270/automation3.png"



-- -----------480x272 IMAGE SIZES AND DIRECTORY---------------------
--Put all of your images into the images/ThumbImages_270/ directory
--make sure that your image sizes are as follows

--main image 445x194
--icon image between 80x80 and 85x85
--thumb image 310x93 (Keep your main focus in the middle as this will be cut off on the sides as the animation pulls around)
apps_480x272 = {
  {
    name = "Home Automation",
    desc = "Temperature control and more",
    thumb = "images/ThumbImages_270/homeThumb.png",
    icon = "images/ThumbImages_270/homeIcon.png",
    gapp_file = "/../../HomeControls_Small/480x272.gapp",
    
    image01 = "images/ThumbImages_270/home1.png",
    image02 = "images/ThumbImages_270/home2.png",
    image03 = "images/ThumbImages_270/home3.png"
  },
  {
    name = "Washing Machine",
    desc = "Wash your clothes",
    thumb = "images/ThumbImages_270/washingMachineThumb.png",
    icon = "images/ThumbImages_270/washIcon.png",
    gapp_file = "/../../WashingMachine_480UltraLow/480x272.gapp",
    
    image01 = "images/ThumbImages_270/washingMachine1.png",
    image02 = "images/ThumbImages_270/washingMachine2.png",
    image03 = "images/ThumbImages_270/washingMachine3.png"
  },
    {
    name = "Medical",
    desc = "Medical trend graphs",
    thumb = "images/ThumbImages_270/medicalThumb.png",
    icon = "images/ThumbImages_270/medicalIcon.png",
    gapp_file = "/../../VitalsMachine_Small/480x272.gapp",

    image01 = "images/ThumbImages_270/med1.png",
    image02 = "images/ThumbImages_270/med2.png",
    image03 = "images/ThumbImages_270/med3.png"
  },
}

apps_480x272_V2 = {
  {
    name = "Smart Watch",
    desc = "Everything on your Wrist",
    thumb = "images/ThumbImages_270/watchThumb.png",
    icon = "images/ThumbImages_270/watchIcon.png",
    gapp_file = "/../../watch/watch_480x272.gapp",
    
    image01 = "images/ThumbImages_270/watch1.png",
    image02 = "images/ThumbImages_270/watch2.png",
    image03 = "images/ThumbImages_270/watch3.png"
  },
  {
    name = "Facille Bake",
    desc = "Smart Oven for Every Home",
    thumb = "images/ThumbImages_270/ovenThumb.png",
    icon = "images/ThumbImages_270/ovenIcon.png",
    gapp_file = "/../../FacileBake_v2/FacileBake_v2.gapp",
    
    image01 = "images/ThumbImages_270/oven1.png",
    image02 = "images/ThumbImages_270/oven2.png",
    image03 = "images/ThumbImages_270/oven3.png"
  },
    {
    name = "Photo Viewer",
    desc = "Browse Your Photo Collection ",
    thumb = "images/ThumbImages_270/photoThumb.png",
    icon = "images/ThumbImages_270/photoIcon.png",
    gapp_file = "/../../photo_album/photo_album.gapp",
    
    image01 = "images/ThumbImages_270/photo1.png",
    image02 = "images/ThumbImages_270/photo2.png",
    image03 = "images/ThumbImages_270/photo3.png"
  },
}
-- -----------800x480 IMAGE SIZES AND DIRECTORY---------------------
--Put all of your images into the images/ThumbImages_270/ directory
--make sure that your image sizes are as follows

--main image 541*345
--icon image between 80x80 and 85x85
--thumb image 550*166 (Keep your main focus in the middle as this will be cut off on the sides as the animation pulls around)

apps_800x480 = {
  {
    name = "Home Automation",
    desc = "Home Automation Demo includes temperature and more",
    thumb = "images/ThumbImages/homeThumb.png",
    icon = "images/ThumbImages/homeIcon.png",
    gapp_file = "/../../HomeControls_Base/800x480.gapp",
    next = "playback/main_to_washing.txt",

    image01 = "images/ThumbImages/home1.png",
    image02 = "images/ThumbImages/home2.png",
    image03 = "images/ThumbImages/home3.png"
  },
  {
    name = "Washing Machine",
    desc = "Wash your laundry",
    thumb = "images/ThumbImages/washingMachineThumb.png",
    icon = "images/ThumbImages/washingMachineIcon.png",
    gapp_file = "/../../WashingMachine_800UltraLow/800x480.gapp",
    next = "playback/main_to_medical.txt",

    image01 = "images/ThumbImages/washingMachine1.png",
    image02 = "images/ThumbImages/washingMachine2.png",
    image03 = "images/ThumbImages/washingMachine3.png"
  },
    {
    name = "Medical",
    desc = "See trends as you browse through this medical demo",
    thumb = "images/ThumbImages/medThumb.png",
    icon = "images/ThumbImages/medicalIcon.png",
    gapp_file = "/../../VitalsMachine/800x480.gapp",
    next = "playback/main_to_home.txt",
    
    image01 = "images/ThumbImages/med1.png",
    image02 = "images/ThumbImages/med2.png",
    image03 = "images/ThumbImages/med3.png"
  }
}

apps_800x480_V2 = {
  {
    name = "Home Automation",
    desc = "Home Automation Demo includes temperature and more",
    thumb = "images/ThumbImages/homeThumb.png",
    icon = "images/ThumbImages/homeIcon.png",
    gapp_file = "/../../HomeControls_Base/800x480.gapp",
    
    image01 = "images/ThumbImages/home1.png",
    image02 = "images/ThumbImages/home2.png",
    image03 = "images/ThumbImages/home3.png"
  },
  {
    name = "Treadmill",
    desc = "Run along a Forest",
    thumb = "images/ThumbImages/treadmillThumb.png",
    icon = "images/ThumbImages/treadmillIcon.png",
    gapp_file = "/../../Treadmill_Base/800x480.gapp",
    
    image01 = "images/ThumbImages/treadmill1.png",
    image02 = "images/ThumbImages/treadmill2.png",
    image03 = "images/ThumbImages/treadmill3.png"
  },
  {
    name = "Washing Machine",
    desc = "Wash your laundry",
    thumb = "images/ThumbImages/washingMachineThumb.png",
    icon = "images/ThumbImages/washingMachineIcon.png",
    gapp_file = "/../../WashingMachine_Base/800x480.gapp",
    next = "playback/main_to_medical.txt",

    image01 = "images/ThumbImages/washingMachine1.png",
    image02 = "images/ThumbImages/washingMachine2.png",
    image03 = "images/ThumbImages/washingMachine3.png"
  },
}

apps_800x480_V3 = {
  {
    name = "Home Automation",
    desc = "Home Automation Demo includes temperature and more",
    thumb = "images/ThumbImages/homeThumb.png",
    icon = "images/ThumbImages/homeIcon.png",
    gapp_file = "/../../HomeControls_Base/800x480.gapp",
    
    image01 = "images/ThumbImages/home1.png",
    image02 = "images/ThumbImages/home2.png",
    image03 = "images/ThumbImages/home3.png"
  },
  {
    name = "Watch",
    desc = "Swipe a smart watch",
    thumb = "images/ThumbImages/watchThumb.png",
    icon = "images/ThumbImages/watchIcon.png",
    gapp_file = "/../../Watch/800x480.gapp",
    
    image01 = "images/ThumbImages/watch1.png",
    image02 = "images/ThumbImages/watch2.png",
    image03 = "images/ThumbImages/watch3.png"
  },
  {
    name = "Washing Machine",
    desc = "Wash your laundry",
    thumb = "images/ThumbImages/washingMachineThumb.png",
    icon = "images/ThumbImages/washingMachineIcon.png",
    gapp_file = "/../../WashingMachine_Base/800x480.gapp",
    next = "playback/main_to_medical.txt",

    image01 = "images/ThumbImages/washingMachine1.png",
    image02 = "images/ThumbImages/washingMachine2.png",
    image03 = "images/ThumbImages/washingMachine3.png"
  },
}

apps_800x600 = {
  {
    name = "Home Automation",
    desc = "Home Automation Demo includes temperature and more",
    thumb = "images/ThumbImages/homeThumb.png",
    icon = "images/ThumbImages/homeIcon.png",
    gapp_file = "/../../HomeControls_Base/800x480.gapp",
    
    image01 = "images/ThumbImages/home1.png",
    image02 = "images/ThumbImages/home2.png",
    image03 = "images/ThumbImages/home3.png"
  },
  {
    name = "Washing Machine",
    desc = "Wash your laundry",
    thumb = "images/ThumbImages/washingMachineThumb.png",
    icon = "images/ThumbImages/washingMachineIcon.png",
    gapp_file = "/../../WashingMachine_Base/800x480.gapp",
    
    image01 = "images/ThumbImages/washingMachine1.png",
    image02 = "images/ThumbImages/washingMachine2.png",
    image03 = "images/ThumbImages/washingMachine3.png"
  },
    {
    name = "Medical",
    desc = "See trends as you browse through this medical demo",
    thumb = "images/ThumbImages/medThumb.png",
    icon = "images/ThumbImages/medicalIcon.png",
    gapp_file = "/../../VitalsMachine/800x480.gapp",
    
    image01 = "images/ThumbImages/med1.png",
    image02 = "images/ThumbImages/med2.png",
    image03 = "images/ThumbImages/med3.png"
  },
}
