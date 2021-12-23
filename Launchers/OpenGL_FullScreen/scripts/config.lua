--This is a config file for the apps on the fullscreen board
--blurred images must be 1024x768 and run through the blurring action-cut out the middle as well
--regular images must be 700x600 to properly fit

--TItle must be 15 or under
--Desc must be 15 or under


standard_apps = {
  {
    name = "Movie Kiosk",
    desc_holder = "3D And Effects",
    gapp_file = "/../../TheaterKiosk/1280x720_LowPoly.gapp",

    image01 = "images/bgImages/Movie1.png",
    image02 = "images/bgImages/Movie2.png",
    image03 = "images/bgImages/Movie3.png",
    
    blur01 = "images/bgImages/Movie1Blurred.png",
    blur02 = "images/bgImages/Movie2Blurred.png",
    blur03 = "images/bgImages/Movie3Blurred.png"
  },
  {
    name = "IOT House",
    desc_holder = "Connected Devices",
    gapp_file = "/../../3DHouse/1024x768.gapp",

    image01 = "images/bgImages/3DHouse1.png",
    image02 = "images/bgImages/3DHouse2.png",
    image03 = "images/bgImages/3DHouse3.png",
    
    blur01 = "images/bgImages/3DHouse1Blurred.png",
    blur02 = "images/bgImages/3DHouse2Blurred.png",
    blur03 = "images/bgImages/3DHouse3Blurred.png"
  },
  {
    name = "Medical",
    desc_holder = "Trend Graphs",
    gapp_file = "/../../VitalsHD/1280x720.gapp",

    image01 = "images/bgImages/Medical1.png",
    image02 = "images/bgImages/Medical2.png",
    image03 = "images/bgImages/Medical3.png",
    
    blur01 = "images/bgImages/Medical1Blurred.png",
    blur02 = "images/bgImages/Medical2Blurred.png",
    blur03 = "images/bgImages/Medical3Blurred.png"
  }
}

house_apps = {
  {
    name = "Movie Kiosk",
    desc_holder = "3D And Effects",
    gapp_file = "/../../TheaterKiosk/1280x720_LowPoly.gapp",
    
    image01 = "images/RegularImages/movieOne.png",
    image02 = "images/RegularImages/movieTwo.png",
    image03 = "images/RegularImages/movieThree.png",
    
    blur01 = "images/BlurredImages/movieBlurredOne.png",
    blur02 = "images/BlurredImages/movieBlurredTwo.png",
    blur03 = "images/BlurredImages/movieBlurredThree.png"
  },
  {
    name = "IOT House",
    desc_holder = "Connected Devices",
    gapp_file = "/../../3DHouse/1024x768.gapp",
    
    image01 = "images/RegularImages/iotOne.png",
    image02 = "images/RegularImages/iotTwo.png",
    image03 = "images/RegularImages/iotThree.png",
    
    blur01 = "images/BlurredImages/blurredOne.png",
    blur02 = "images/BlurredImages/blurredTwo.png",
    blur03 = "images/BlurredImages/blurredThree.png"
  },
  {
    name = "Home Automation",
    desc_holder = "Smart House",
    gapp_file = "/../../HomeControls_Base/800x480.gapp",

    image01 = "images/RegularImages/homeOne.png",
    image02 = "images/RegularImages/homeTwo.png",
    image03 = "images/RegularImages/homeThree.png",
    
    blur01 = "images/BlurredImages/homeOneBlurred.png",
    blur02 = "images/BlurredImages/homeTwoBlurred.png",
    blur03 = "images/BlurredImages/homeThreeBlurred.png"
  }
}

appliance_apps = {
  {
    name = "Movie Kiosk",
    desc_holder = "3D And Effects",
    gapp_file = "/../../TheaterKiosk/1280x720_LowPoly.gapp",
    
    image01 = "images/RegularImages/movieOne.png",
    image02 = "images/RegularImages/movieTwo.png",
    image03 = "images/RegularImages/movieThree.png",
    
    blur01 = "images/BlurredImages/movieBlurredOne.png",
    blur02 = "images/BlurredImages/movieBlurredTwo.png",
    blur03 = "images/BlurredImages/movieBlurredThree.png"
  },
  {
    name = "IOT House",
    desc_holder = "Connected Devices",
    gapp_file = "/../../3DHouse/1024x768.gapp",
    
    image01 = "images/RegularImages/iotOne.png",
    image02 = "images/RegularImages/iotTwo.png",
    image03 = "images/RegularImages/iotThree.png",
    
    blur01 = "images/BlurredImages/blurredOne.png",
    blur02 = "images/BlurredImages/blurredTwo.png",
    blur03 = "images/BlurredImages/blurredThree.png"
  },
  {
    name = "Washing Machine",
    desc_holder = "White Goods",
    gapp_file = "/../../WashingMachine_Base/800x480.gapp",

    image01 = "images/RegularImages/washOne.png",
    image02 = "images/RegularImages/washTwo.png",
    image03 = "images/RegularImages/washThree.png",
    
    blur01 = "images/BlurredImages/washOneBlurred.png",
    blur02 = "images/BlurredImages/washTwoBlurred.png",
    blur03 = "images/BlurredImages/washThreeBlurred.png"
  }
}