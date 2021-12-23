--this is the config file for the HDMI launcher
-- TO CHANGE THE APP TABLE THAT IS CALLED GO INTO THE CALLBACKS SCRIPT. IT IS AT THE TOP THERE

MAINTOGGLE_AUTOMATED = 0


--Main images mush be 640x640, these will be in the middle
--BG blurred images must be 1280x720 and run through a blur and clean up

--Supports 3 apps
--Below are the 3 that are automotive related
auto_apps = {
  {
    name = "Infotainment",
    tagline = "Car Multimedia",
    desc = "Explore a multimedia system that is easy to use",
    gapp_file = "/../../InfotainmentStack/800x480.gapp",
    
    image01 = "images/bgImages/Infotainment01.png",
    image02 = "images/bgImages/Infotainment02.png",
    image03 = "images/bgImages/Infotainment03.png",

    blur01 = "images/bgImages/Infotainment01Blurred.png",
    blur02 = "images/bgImages/Infotainment02Blurred.png",
    blur03 = "images/bgImages/Infotainment03Blurred.png"
  },
    {
    name = "2D Cluster",
    tagline = "Circles and Fills",
    desc = "Clean and clear cluster utilizing a flat 2D Design.",
    gapp_file = "/../../TexasInstrumentsCluster/1280x720.gapp",

    image01 = "images/bgImages/2DCluster01.png",
    image02 = "images/bgImages/2DCluster02.png",
    image03 = "images/bgImages/2DCluster03.png",
    
    blur01 = "images/bgImages/2DCluster01Blurred.png",
    blur02 = "images/bgImages/2DCluster02Blurred.png",
    blur03 = "images/bgImages/2DCluster03Blurred.png"
  },
    {
    name = "3D Cluster",
    tagline = "Multi-mesh Models",
    desc = "Explore new 3D possibilities inside this cluster",
    gapp_file = "/../../3DCluster_Customizable/1280x720.gapp",

    image01 = "images/bgImages/3DCluster1.png",
    image02 = "images/bgImages/3DCluster2.png",
    image03 = "images/bgImages/3DCluster3.png",
    
    blur01 = "images/bgImages/3DCluster1Blurred.png",
    blur02 = "images/bgImages/3DCluster2Blurred.png",
    blur03 = "images/bgImages/3DCluster3Blurred.png"
  }
}

--below are the 3 that are for white goods
whiteGood_apps = {
  {
    name = "Oven Interface",
    tagline = "Voice Controlled Oven",
    desc = "Exlpore new ways to communicate with interfaces",
    gapp_file = "/../../CrankOven/1280x720.gapp",

    image01 = "images/bgImages/Oven1.png",
    image02 = "images/bgImages/Oven2.png",
    image03 = "images/bgImages/Oven3.png",
    
    blur01 = "images/bgImages/Oven1Blurred.png",
    blur02 = "images/bgImages/Oven2Blurred.png",
    blur03 = "images/bgImages/Oven3Blurred.png"
  },
    {
    name = "Movie Kiosk",
    tagline = "3D and Effects",
    desc = "Explore video playback and 3D effects in this movie ticket kiosk.",
    gapp_file = "/../../TheaterKiosk/1280x720_HighPoly.gapp",
    
    image01 = "images/bgImages/Movie1.png",
    image02 = "images/bgImages/Movie2.png",
    image03 = "images/bgImages/Movie3.png",
    
    blur01 = "images/bgImages/Movie1Blurred.png",
    blur02 = "images/bgImages/Movie2Blurred.png",
    blur03 = "images/bgImages/Movie3Blurred.png"
  },
    {
    name = "IoT House",
    tagline = "Connected Devices",
    desc = "Explore a smart house all connected",
    gapp_file = "/../../3DHouse/1280x720.gapp",

    image01 = "images/bgImages/3DHouse1.png",
    image02 = "images/bgImages/3DHouse2.png",
    image03 = "images/bgImages/3DHouse3.png",
    
    blur01 = "images/bgImages/3DHouse1Blurred.png",
    blur02 = "images/bgImages/3DHouse2Blurred.png",
    blur03 = "images/bgImages/3DHouse3Blurred.png"
  }
}

--below are the 3 that are universal
standard_apps = {
  {
    name = "3D Cluster",
    tagline = "Multi-mesh Models",
    desc = "Explore new 3D possibilities inside this cluster",
    gapp_file = "/../../3DClusterCustomizable/1280x720.gapp",

    image01 = "images/bgImages/3DCluster1.png",
    image02 = "images/bgImages/3DCluster2.png",
    image03 = "images/bgImages/3DCluster3.png",
    
    blur01 = "images/bgImages/3DCluster1Blurred.png",
    blur02 = "images/bgImages/3DCluster2Blurred.png",
    blur03 = "images/bgImages/3DCluster3Blurred.png"
  },
    {
    name = "Movie Kiosk",
    tagline = "3D and Effects",
    desc = "Explore video playback and 3D effects in this movie ticket kiosk.",
    gapp_file = "/../../TheaterKiosk/1280x720_HighPoly.gapp",
    
    image01 = "images/bgImages/Movie1.png",
    image02 = "images/bgImages/Movie2.png",
    image03 = "images/bgImages/Movie3.png",
    
    blur01 = "images/bgImages/Movie1Blurred.png",
    blur02 = "images/bgImages/Movie2Blurred.png",
    blur03 = "images/bgImages/Movie3Blurred.png"
  },
    {
    name = "IoT House",
    tagline = "Connected Devices",
    desc = "Explore a smart house all connected",
    gapp_file = "/../../3DHouse/1280x720.gapp",

    image01 = "images/bgImages/3DHouse1.png",
    image02 = "images/bgImages/3DHouse2.png",
    image03 = "images/bgImages/3DHouse3.png",
    
    blur01 = "images/bgImages/3DHouse1Blurred.png",
    blur02 = "images/bgImages/3DHouse2Blurred.png",
    blur03 = "images/bgImages/3DHouse3Blurred.png"
  },
    {
    name = "Oven Interface",
    tagline = "Voice Controlled Oven",
    desc = "Exlpore new ways to communicate with interfaces",
    gapp_file = "/../../CrankOven/1280x720.gapp",

    image01 = "images/bgImages/Oven1.png",
    image02 = "images/bgImages/Oven2.png",
    image03 = "images/bgImages/Oven3.png",
    
    blur01 = "images/bgImages/Oven1Blurred.png",
    blur02 = "images/bgImages/Oven2Blurred.png",
    blur03 = "images/bgImages/Oven3Blurred.png"
  },
}