import processing.pdf.*;
PShape background;
color bodytext = color(0, 0, 0), 
midOrange = color(249, 164, 26), 
midBlue = color(8, 131, 192), 
recessionBox = color(200, 226, 241, 180), 
gridLines = color(153), 
peakLine = color(200, 226, 241);
PFont location, data13, dataLT, scaleNums, sizingUpParFont, sizingUpData, industry, wage;
float lalign = 40, lsecond = 61, lthird = 177;
int counter = 2001;
int c = counter + 1;
Table counties;

void setup() {
  background = loadShape("blank.svg");
  size(792, 612/*, PDF, "derp.pdf"*/);
  counties = new Table("TrendsProfileData.tsv");
  location = createFont("Helvetica Neue Light", 26);
  data13 = createFont("AurulentSansMono-Regular", 22);
  dataLT = createFont("AurulentSansMono-Regular", 12);
  scaleNums = createFont("Helvetica Neue Light", 7);
  sizingUpParFont = createFont("Helvetica Neue Light", 10);
  sizingUpData = createFont("AurulentSansMono-Regular", 10);
  industry = createFont("AurulentSansMono-Regular", 7);
  wage = createFont("AurulentSansMono-Regular", 7);
  smooth();
}

void draw() {
  background(255);
  String filename = counties.getString(c, 2);
  beginRecord(PDF, "/Profiles/" + filename + ".pdf");
  shape(background, 0, 0);
  dataNotes();
  drawData();
  sizingUp();
  drawLineGraphs();
  drawBarChart();


  String countyname = counties.getString(c, 1).toUpperCase();
  String statename = counties.getString(c, 3).toUpperCase();
  textFont(location);
  fill(0, 0, 0);
  text(countyname + ", " + statename, 15, 102);
  endRecord();
  counter+=1;
  c = counter +1;
  println(counter);
  if (frameCount == 3112) {
    exit();
  }
}

void dataNotes() {
  //recovery period
  fill(recessionBox);
  stroke(255, 255, 255, 0);
  strokeWeight(0);
  rect(15, 279, 20, 10);
  textFont(scaleNums);
  fill(75, 75, 75);
  text("         = recovery period", 18, 287);
  strokeWeight(2);
  stroke(midOrange);
  line(15, 288, 24, 282);
  line(24, 282, 33, 280);
  //peak

  strokeWeight(1);
  textFont(scaleNums);
  fill(75, 75, 75);
  text(" = peak year", 34, 301);
  strokeWeight(2);
  stroke(midOrange);
  line(15, 303, 22, 295);
  line(22, 295, 33, 298);
  stroke(peakLine);
  strokeWeight(2);
  line(22, 293, 22, 303);
}

void drawData() {
  fill(0, 0, 0);
  //section for 2013 growth rates
  textFont(data13);
  textAlign(RIGHT);

  int xOrigin = 209;
  int yOrigin = 164;
  Float GDP13 = counties.getFloat1(c, 9)*100;
  Float unem13 = counties.getFloat1(c, 10);
  Float jobs13 = counties.getFloat1(c, 11)*100;
  Float HHprice13 = counties.getFloat1(c, 12)*100;

  text(nf(GDP13, 0, 1) + "%", xOrigin, yOrigin);
  text(nf(unem13, 0, 1) + "pps", xOrigin +196, yOrigin);
  text(nf(jobs13, 0, 1) + "%", xOrigin +346, yOrigin);
  text(nf(HHprice13, 0, 1) + "%", xOrigin + 522, yOrigin);

  //Begin sextion for long-term data numbers
  textFont(dataLT);

  xOrigin = 194;
  yOrigin = 187;
  Float GDPLT = counties.getFloat1(c, 13)*100;
  Float unemLT = counties.getFloat1(c, 14);
  Float jobsLT = counties.getFloat1(c, 15)*100;
  Float HHpriceLT = counties.getFloat1(c, 16)*100;

  text(nf(GDPLT, 0, 1) + "%", xOrigin, yOrigin);
  //Not including unemployment long-term data as it is misleading
  //text(nf(unemLT, 0, 1) + "%", xOrigin + 170, yOrigin);
  text(nf(jobsLT, 0, 1) + "%", xOrigin + 346, yOrigin);
  text(nf(HHpriceLT, 0, 1) + "%", xOrigin + 522, yOrigin);

  textAlign(LEFT);
}
//End drawData

void sizingUp() {
  String countyname = counties.getString(c, 1);
  String statename = counties.getString(c, 3);
  String countyGov = " has a county government. ";
  if (counties.getInt1(c, 5)==0) {
    countyGov = " does not have a county government. ";
  }
  String LgMdSm = "small";
  if (counties.getInt1(c, 4)>50000) {
    LgMdSm = "medium-sized";
  }
  if (counties.getInt1(c, 4)>500000) {
    LgMdSm = "large";
  }
  String metroMicro = "not in a metropolitan/micropolitan area.";
  String centralOutlying = "";
  if (counties.getInt1(c, 7)!=0) {
    if (counties.getInt1(c, 8)==1) {
      centralOutlying = ", central";
    }
    else {
      centralOutlying = ", outlying";
    }
    if (counties.getInt1(c, 7)==1) {
      metroMicro = "in the " + counties.getString(c, 6) + " micropolitan area.";
    }
    else {
      metroMicro = "in the " + counties.getString(c, 6) + " metropolitan area.";
    }
  }


  String sizingUpPar = countyname +", "+statename + countyGov;
  String sizingUpPar2 = countyname + " is a " + LgMdSm + centralOutlying + " county " + metroMicro;
  fill(0, 0, 0);
  textFont(sizingUpParFont);
  textLeading(12);
  text(sizingUpPar+"\n\n"+sizingUpPar2, 28, 350, 180, 100);

  textFont(sizingUpData);
  //right aligned data
  textAlign(RIGHT);
  Float pop12 = counties.getFloat1(c, 4);
  Float GDP13 = counties.getFloat1(c, 149);
  Float avgWage13 = counties.getFloat1(c, 150);
  Float unem13 = counties.getFloat1(c, 76);
  //POP data
  if (pop12 >=1000000) { 
    text(nf(pop12/1000000, 0, 1)+ " MILLION", 501, 363);
  }
  else {
    text(nfc(pop12, 0), 465, 363);
  }
  //GDP DAta
  if (GDP13 > 1000000000) {
    text("$"+ nf(GDP13/1000000000, 0, 1)+" BILLION", 501, 385);
  }
  else if (GDP13 > 1000000) {
    text("$" + nf(GDP13/1000000, 0, 1) + " MILLION", 501, 385);
  }
  else {
    text("$" + nfc(GDP13, 0), 465, 385);
  }
  //Average wage data
  text("$" + nfc(round(avgWage13/100)*100, -1), 465, 407);
  //unem data
  text(nf(unem13, 0, 1)+"%", 459, 429);
  //left aligned row names
  textAlign(LEFT);
  text("POPULATION, 2012", 267, 363);
  text("NOMINAL GDP", 267, 385);
  text("AVERAGE COUNTY WAGE", 267, 407);
  text("UNEMPLOYMENT RATE", 267, 429);
}

void drawLineGraphs() {
  fill(0, 0, 0);
  int graphWidth = 126;
  int graphHeight = 76;
  int beginYear = 2002;
  Float xStep = graphWidth/11.0;
  // Will want to loop over this for each graph
  for (int g=37; g<146; g+=28) {
    Float countyScaled = counties.getFloat1(c, g);
    Float stateScaled = counties.getFloat1(c, g+14);
    if (g==65) {
      countyScaled = 100.0;
      stateScaled= 100.0;
    }
    int xOrigin = 125 +(173*(g-37)/28);
    int yOrigin = 205;

    //data notes at the top of each graph
    fill(75, 75, 75);
    textFont(scaleNums);
    switch(g) {
    case 37:
      text("Inflation-adjusted GDP (2002=100)", xOrigin, yOrigin-3);
      break;
    case 65:
      text("Unemployment Rate", xOrigin, yOrigin-3);
      break;
    case 93:
      text("Total Jobs (2002=100)", xOrigin, yOrigin-3);
      break;
    case 121:
      text("Median Home Prices (2002=100)", xOrigin, yOrigin-3);
      break;
    }

    //get lowest and highest values for county and state data and compare them
    Float countyLowestValue = 1000000000000000.0;
    Float countyHighestValue = 0.0;
    Float stateLowestValue = 1000000000000000.0;
    Float stateHighestValue = 0.0;

    for (int b=g; b<(g+12); b++) {
      if (counties.getFloat1(c, b) < countyLowestValue) {
        countyLowestValue = counties.getFloat1(c, b);
      }
      if (counties.getFloat1(c, b) > countyHighestValue) {
        countyHighestValue = counties.getFloat1(c, b);
      }
    }
    for (int s=g+14; s<g+26; s++) {
      if (counties.getFloat1(c, s) < stateLowestValue) {
        stateLowestValue = counties.getFloat1(c, s);
      }
      if (counties.getFloat1(c, s) > stateHighestValue) {
        stateHighestValue = counties.getFloat1(c, s);
      }
    }
    Float LowestValueScaled = countyLowestValue*100/countyScaled;
    Float HighestValueScaled = countyHighestValue*100/countyScaled;
    if ((stateLowestValue*100/stateScaled) < LowestValueScaled) {
      LowestValueScaled = stateLowestValue*100/stateScaled;
    }
    if ((stateHighestValue*100/stateScaled) > HighestValueScaled) {
      HighestValueScaled = stateHighestValue*100/stateScaled;
    }
    //set highest and lowest values to 5s
    int HighestValue5Scaled = (int)ceil(HighestValueScaled);
    int LowestValue5Scaled = (int)floor(LowestValueScaled);
    Float range = 1.0*HighestValue5Scaled - LowestValue5Scaled;
    Float yInterval;
    Float yStep;
    Float rangeRatio;
    int stepCount = 5;
    Float translate;
    if (g==65) {
      range = 1.0*HighestValue5Scaled - LowestValue5Scaled;
      yStep = 1.0*graphHeight/4;
      rangeRatio = (graphHeight / range);
      yInterval = -1*(yStep)/rangeRatio;
      translate = rangeRatio*(LowestValue5Scaled);
    }
    else {
      while (HighestValue5Scaled %5 != 0) {
        HighestValue5Scaled +=1;
      }
      while (LowestValue5Scaled %5 != 0) {
        LowestValue5Scaled -=1;
      }
      //establish the graphs range of values, its ratio of pixels per index increment, and translate it up by 5%
      range = 1.0*HighestValue5Scaled - LowestValue5Scaled;
      //establish oldRange, range, yInterval, and StepCount
      yInterval = 5.0;

      int stepUp = (HighestValue5Scaled-100)/5;
      int stepDown = (100 - LowestValue5Scaled)/5;
      stepCount = stepUp + stepDown;
      int a = 0;
      int[] stepArray = {
        5, 10, 20, 30, 40, 50, 60, 70, 80, 100, 150, 200, 250, 300
      };
      while (stepCount > 6) {
        a++;

        while (HighestValue5Scaled % stepArray[a] != 0) {
          HighestValue5Scaled +=1;
        }
        while (LowestValue5Scaled % stepArray[a] != 0) {
          LowestValue5Scaled -=1;
        }
        stepUp = (HighestValue5Scaled-100)/stepArray[a];
        stepDown = (100 - LowestValue5Scaled)/stepArray[a];
        stepCount = stepUp + stepDown;
        yInterval = 1.0 * stepArray[a];
        range = 1.0*HighestValue5Scaled - LowestValue5Scaled;

        if (stepCount>6) {
          println("ALERT!" + counties.getString(c, 1) + " has a range of " + range);
        }
      }

      yStep = 1.0*graphHeight/(stepCount);
      rangeRatio = (graphHeight / range);
      translate = rangeRatio*(LowestValue5Scaled);
    }
    //test range is divisible by its interval and revalue depending

    /*//Some useful code for figuring out why a graph might be misbehaving
     textFont(location, 12);
     text(LowestValue5Scaled + " - " + HighestValue5Scaled + " : " + range, xOrigin, 150);
     text(yInterval + " : " + stepCount, xOrigin, 170);
     */

    int countyPeakYear = counties.getInt1(c, g+12) - 2000;
    int countyTroughYear = counties.getInt1(c, g+13) - 2000;
    //Axes and lines
    strokeWeight(1);
    stroke(gridLines);
    //x axis
    line(xOrigin, yOrigin +graphHeight, xOrigin +graphWidth, yOrigin + graphHeight);
    //y axis
    //line(xOrigin, yOrigin+graphHeight, xOrigin, yOrigin); 

    //Graph horizontal lines setup
    for (int z=1; z < stepCount+2; z++) {
      if (z==6 & g==63) {
        break;
      }
      Float currentyStep = yStep*(z-1) + yOrigin;
      if (z!=stepCount+1) {
        line(xOrigin, currentyStep, graphWidth + xOrigin, currentyStep);
      }
      //Code for creating automatic 5 step labels, evenly spaced
      Float stepText = HighestValue5Scaled - yInterval*(z-1);
      String stepTextRnd = nf(stepText, 0, 0 );
      if (g==65) {
        stepText = -1*(currentyStep-yOrigin-translate-graphHeight)/rangeRatio;
        stepTextRnd = nf(stepText, 0, 1) + "%";
      }
      textFont(scaleNums);
      fill(75, 75, 75);
      textAlign(RIGHT);
      text(stepTextRnd, xOrigin-3, currentyStep+2);
      textAlign(LEFT);
      //End evenly spaced labels
    } 
    /*//Different Method for creating graph lines based on 100 scale value and highest and lowest values
     int scale100Text = 100;
     Float scale100Position = -1*(rangeRatio*100)+yOrigin + translate + graphHeight ;
     Float scaleHighestText = (countyHighestValue*100)/scaled;
     Float scaleHighestPosition = -1*(rangeRatio*((countyHighestValue *100) / scaled))+yOrigin + translate + graphHeight;
     Float scaleLowestText = countyLowestValue*100/scaled;
     Float scaleLowestPosition = -1*(rangeRatio*((countyLowestValue *100) / scaled))+yOrigin + translate + graphHeight;
     
     textFont(location, 12);
     text(scale100Text, xOrigin-20, scale100Position);
     text(round(scaleHighestText), xOrigin-20, scaleHighestPosition);
     text(round(scaleLowestText), xOrigin-20, scaleLowestPosition);
     //text(yAxisText[i], xOrigin-20, currentyStep+5);
     */

    //looping over values to graph  
    for (int r = g+1; r < g+12; r++) {  
      //get county values
      Float countyPrevNumber = counties.getFloat1(c, r-1);
      Float countyNumber = counties.getFloat1(c, r);
      //get state values
      Float statePrevNumber = counties.getFloat1(c, r+13);
      Float stateNumber = counties.getFloat1(c, r+14);

      //scale the county values
      Float countyPrevNumberScaled = -1*(rangeRatio*((countyPrevNumber *100) / countyScaled))+yOrigin + translate + graphHeight ;
      Float countyNumberScaled =  -1*(rangeRatio*((countyNumber *100)/ countyScaled))+yOrigin + translate + graphHeight;
      //scale the state values
      Float statePrevNumberScaled = -1*(rangeRatio*((statePrevNumber *100) / stateScaled))+yOrigin + translate + graphHeight ;
      Float stateNumberScaled =  -1*(rangeRatio*((stateNumber *100)/ stateScaled))+yOrigin + translate + graphHeight;

      //establish which x position we are one depending on the year; (r-38)==2002
      Float prevStep = xStep * (r-(g+1)) + xOrigin;
      Float currentStep = xStep * (r-g) + xOrigin;

      stroke(gridLines);
      strokeWeight(1);
      //x-axis hashmarks
      if (r==(g+1)) {
        line(prevStep, yOrigin + graphHeight+2, prevStep, yOrigin+graphHeight);
      }
      line(currentStep, yOrigin + graphHeight+2, currentStep, yOrigin+graphHeight);
      // x-axis labels
      textFont(scaleNums);
      fill(75, 75, 75);
      int year = 2 + (r-(g+1));
      String yearString = "'0"+year;
      if (year < 10) {
        yearString = "'0"+year;
      }
      else {
        yearString = "'"+year;
      }
      text(yearString, prevStep-5, yOrigin+graphHeight+10);
      if (year ==12) {
        int year13 = 13;
        String year13String = "'" + year13;
        text(year13String, currentStep-5, yOrigin+graphHeight+10);
      }
      //x-axis label
      fill(gridLines);
      text("year", xOrigin+115, yOrigin+graphHeight + 18);
      if (countyPeakYear!=countyTroughYear) {
        //county peak value line

        if (year==countyPeakYear) {
          stroke(peakLine);
          strokeWeight(2);
          line(prevStep, yOrigin +graphHeight, prevStep, yOrigin);
          strokeWeight(1);
        }
        //county trough value rectange
        if (year==countyTroughYear) {
          fill(recessionBox);
          stroke(255, 255, 255, 0);
          strokeWeight(0);
          rect(xOrigin + xStep*(r-(g+1)), yOrigin, xStep*11 - xStep*(r-(g+1)), graphHeight);
          fill(0);
          strokeWeight(1);
        }
        //marking 2013 as trough (but we don't know that 2014 isnt trough)
        /* if(year==12 & countyTroughYear==13){
         strokeWeight(3);
         stroke(recessionBox);
         line(currentStep, yOrigin + graphHeight, currentStep, yOrigin);
         }*/
      }
      //draw the state, then county (on top) trend-line  
      strokeWeight(2);
      stroke(midBlue);
      line(prevStep, statePrevNumberScaled, currentStep, stateNumberScaled);
      stroke(midOrange);
      line(prevStep, countyPrevNumberScaled, currentStep, countyNumberScaled);
      strokeWeight(0);
    }
    //End for loop for individual graph
  }
  //End For loop for consecutive graphs
}
//End drawLineGraphs
void drawBarChart() {
  int xOrigin = 547;
  int yOrigin = 351;
  int barGraphWidth = 230;
  int barHeight = 12;
  stroke(255);
  strokeWeight(0);
  //bar 1
  String bar1Cat = counties.getString(c, 17).toUpperCase();
  Float bar1Amt = counties.getFloat1(c, 18);
  Float bar1Share = counties.getFloat1(c, 19)*100;
  int bar1Width = barGraphWidth;
  int bar1Wage = ceil(counties.getFloat1(c, 20));
  textFont(industry);
  fill(0, 0, 0);
  if (bar1Amt > 1000) {
    text(bar1Cat + " - $"+ nf(bar1Amt/1000, 0, 1) + " BILLION" + " - " + nf(bar1Share, 0, 1) + "%", xOrigin, yOrigin-2);
  }
  else {
    text(bar1Cat + " - $"+ nf(bar1Amt, 0, 1) + " MILLION" + " - " + nf(bar1Share, 0, 1) + "%", xOrigin, yOrigin-2);
  }
  fill(midBlue);
  if (bar1Wage < 100) {
    text("AVERAGE WAGE, 2013:  N/A", xOrigin, yOrigin + barHeight + 9);
  }
  else {
    text("AVERAGE WAGE, 2013:  $" + nfc(round(bar1Wage/100)*100), xOrigin, yOrigin + barHeight + 9);
  }
  rect(xOrigin, yOrigin+1, bar1Width, barHeight);
  fill(0, 0, 0);
  //set scale equal to the largest share divided by barMaxWidth
  Float scale = counties.getFloat1(c, 19)*100/barGraphWidth;
  //scale the rest of the bars as a proportion of the initial bar
  //distance between top of bar1 and top of bar2 
  int yStep = 39;

  //Loop over bars 2-5
  for (int i=21; i<36; i+=4) {
    //bar 2

    String bar2Cat = counties.getString(c, i).toUpperCase();
    Float bar2Amt = counties.getFloat1(c, i+1);
    Float bar2Share = counties.getFloat1(c, i+2)*100;
    Float bar2Width = bar2Share / scale;
    int bar2Wage = ceil(counties.getFloat1(c, i+3));

    textFont(industry);
    fill(0, 0, 0);
    if (bar2Amt > 1000) {
      text(bar2Cat + " - $"+ nf(bar2Amt/1000, 0, 1) + " BILLION" + " - " + nf(bar2Share, 0, 1) + "%", xOrigin, yOrigin+yStep-2);
    }
    else {
      text(bar2Cat + " - $"+ nf(bar2Amt, 0, 1) + " MILLION" + " - " + nf(bar2Share, 0, 1) + "%", xOrigin, yOrigin+yStep-2);
    }
    fill(midBlue);
    if (bar2Wage < 100) {
      text("AVERAGE WAGE, 2013:  N/A", xOrigin, yOrigin+yStep + barHeight + 9);
    }
    else {
      text("AVERAGE WAGE, 2013:  $" + nfc(round(bar2Wage/100)*100), xOrigin, yOrigin+yStep + barHeight + 9);
    }
    rect(xOrigin, yOrigin+yStep+1, bar2Width, barHeight);
    yStep += 39;
    //bar 3
    //bar 4
    //bar 5
  }
}
//End drawBarChart

void keyPressed() {
  if (keyCode == LEFT) {
    counter -= 1;
  } 
  else if (keyCode == RIGHT) {
    counter += 1;
  } 
  else {
    counter = counter;
  }

  if (counter < 0) {
    counter = 3112;
  }

  if (counter > 3112) {
    counter = 0;
  }
  c = counter + 1;
  println(counter);
}

