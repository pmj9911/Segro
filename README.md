## SEGRO - say grow to our environment

Considering the current scenario in our country, we see that waste disposal, segregation and collection, collectively is one of the biggest challenges faced by the authorities.
This application provides for an end to end solution for waste classification,collection and disposal.

### Technologies Used
1) Django Rest Framework (API for backend)
2) Flutter (Mobile Application)
3) Image Classification with CNN and YOLOv3

### Waste Classification
For the purpose of waste classification we have used Image Classification which classifies waste into 6 different categories:
1)metal
2)paper
3)cardboard
4)trash
5)plastic
6)glass

#### Results Using CNN with ResNet Architecture

<img src = "https://github.com/pmj9911/Segro/tree/master/docs/1.png">

#### Results Using YOLOv3

<img src = "https://github.com/pmj9911/Segro/tree/master/docs/3.png">
<img src = "https://github.com/pmj9911/Segro/tree/master/docs/2.png">
<img src = "https://github.com/pmj9911/Segro/tree/master/docs/4.png">
<img src = "https://github.com/pmj9911/Segro/tree/master/docs/7.png">

### Waste Segregation
For the purpose of waste segregation we have simulated the working the working of Smart Bins.

#### Screenshots of the simulation of Bins

<img src = "https://github.com/pmj9911/Segro/tree/master/docs/5.png" height="600" width="800">

### Route Optimization
For route optimization of the truck for waste collection we use the TSP algorithm.

#### Screenshots of optimized route generated
<img src = "https://github.com/pmj9911/Segro/tree/master/docs/6.png">

## Code Structure

1) Master branch consists of the backend api.
2) Flutter branch consists of the mobile application.
3) Classifier branch consists of CNN classifier.
4) Yolo branch consists of classifier with YOLOv3.
5) Simulator branch consists of simulation of classifier over webcam.

#### References and credits
1) https://github.com/AntonMu/TrainYourOwnYOLO
2) https://github.com/Cartucho/mAP

