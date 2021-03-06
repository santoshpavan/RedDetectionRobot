clc;
clear;
redth = 0.25;
vid = imaq.VideoDevice('winvideo',1,'YUY2_640x480','ReturnedColorSpace','rgb');
vidinfo = imaqhwinfo(vid);
hblob = vision.BlobAnalysis('AreaOutputPort',true,'CentroidOutputPort',true,'BoundingBoxOutputPort',true,'MinimumBlobArea',600,'MaximumBlobArea',28000);
htext  = vision.TextInserter('Text','stopped','Color',[255 0 0],'Location',[150 60],'FontSize',14);
htext0 = vision.TextInserter('Text','Object detected : ','Color',[255 0 0],'Location',[10 40],'FontSize',14);
htext8 = vision.TextInserter('Text','Bot Direction : ','Color',[255 0 0],'Location',[10 60],'FontSize',14);
htext1 = vision.TextInserter('Text','RED balls : %d','Color',[255 0 0],'Location',[1 1],'FontSize',14);
htext2 = vision.TextInserter('Text','no response','Color',[255 0 0],'Location',[150 40],'FontSize',14);
htext3 = vision.TextInserter('Text','center','Color',[255 0 0],'Location',[150 40],'FontSize',14);
htext4 = vision.TextInserter('Text','X : %d , Y : %d','LocationSource','Input port','Color',[255 255 0]);
htext5 = vision.TextInserter('Text','right','Color',[255 0 0],'LocationSource','Input port','FontSize',14);
htext6 = vision.TextInserter('Text','left','Color',[255 0 0],'LocationSource','Input port','FontSize',14);
htext7 = vision.TextInserter('Text','forward','Color',[255 0 0],'Location',[150 60],'FontSize',14);
hshapered = vision.ShapeInserter('Fill',true,'FillColor','Custom','CustomFillColor',[255 0 0],'Opacity',1);
hvideoln = vision.VideoPlayer('Name','My_Video','Position',[100 100 vidinfo.MaxWidth vidinfo.MaxHeight]);
nframe = 0;
L=0;

arduinoSerial = serial('COM3','Baudrate',9600);
fopen(arduinoSerial);

while(nframe < 500)
    frame = step(vid);
    [m n p]=size(frame);
    frame = flipdim(frame,2);
    diff  = imsubtract(frame(:,:,1) , rgb2gray(frame));
    binframe = medfilt2(diff, [3 3]);
    binframe = im2bw(binframe,redth);
    [area centroid bbox] = step(hblob,binframe);
    centroid = uint16(centroid);
    p=uint16(n/3);
    q=uint16(n/2);
    h=q-20;
    k=q+20;
    frame(1:20, 1:205 , :) = 0;
    frame(40:60,1:205,:)=0;
    frame(60:80,1:205,:)=0;
    frame(1:m,p,:)=0;
    frame(1:m,2*p,:)=0;
    frame(1:m,q+20,:)=0;
    frame(1:m,q-20,:)=0;
    vidln = step(hshapered,frame,bbox);
    
    for object = 1:length(bbox(:,1))
      centx = centroid(object,1);
      centy = centroid(object,2);
      vidln = step(htext4,vidln,[centx centy],[centx-6 centy-6]);
    end
    vidln = step(htext1,vidln,uint8(length(bbox(:,1))));
    n = length(bbox(:,1));
    vidln=step(htext0,vidln);
    vidln=step(htext8,vidln);
    
   if(n==0)
       vidln=step(htext,vidln);          
   end
    if(n==1)
        if(centroid(1,1)<p)
            vidln=step(htext6,vidln,[150 40]);
            vidln=step(htext6,vidln,[150 60]);
            L=1;
        end
        if(centroid(1,1)>2*p)
          vidln=step(htext5,vidln,[150 40]);
          vidln=step(htext5,vidln,[150 60]);
          L=2;
        end
        if(centroid(1,1)<q+20)&&(centroid(1,1)>q-20)
            vidln=step(htext3,vidln);
            vidln=step(htext7,vidln);
            L=0;
        end
        if((centroid(1,1)<q-20)||(centroid(1,1)>q+20))
            if((centroid(1,1)<2*p)&&(centroid(1,1)>p))
               if(L==1)
                vidln=step(htext3,vidln);
                vidln=step(htext6,vidln,[150 60]);
                fprintf('f');
               end
               if(L==2)
                    vidln=step(htext3,vidln);
                    vidln=step(htext5,vidln,[150 60]);
               end
               if(L==0)
                vidln=step(htext3,vidln);
                vidln=step(htext7,vidln);
                fprintf('b'); 
               end
            end
        end
    end
    if(n>1)
        vidln=step(htext2,vidln);
    end
    step(hvideoln,vidln);
   
 nframe = nframe + 1;
end
release(hvideoln);
release(vid);


