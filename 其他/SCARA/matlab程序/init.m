function init()

    global pluse ratio lead motorvel zerop pluseequ plusemax;

    pluse=[131072,131072,131072,131072];
    ratio=[50,50,2,50];
    lead=[360,360,20,360];
    motorvel=[1000,1000,1000,1000];
    zerop=[335658,-313942,395650,-56192];

    pluseequ=pluse.*ratio./lead;
    plusemax=pluse.*motorvel*1.5*0.008/60;
    
end
