//
//  fetchPoints.cpp
//  MapFromCPP
//
//  Created by 孙培峰 on 4/2/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#include "fetchPoints.h"



void readFromFile()
{
    FILE *fp;
    if (fopen("china1.dat","r"))
    {
        fp = fopen("\china1.dat","r");
        int x1,y1,x2,y2,x,y;
        char str[20];
        fscanf(fp,"%d,%d",&x1,&y1);
        fscanf(fp,"%d,%d",&x2,&y2);
        
        
        
        
//        crRect.SetRect((x1+1000000)/10000,(y1+1000000)/10000,(x2+1000000)/10000,(y2+1000000)/10000);
//        int i,j,m,n,flag;
//        fscanf(fp,"%d",&n);
//        for (i=1;i<=n;i++)
//        {
//            fscanf(fp,"%d",&j);
//            fgets(str,j+1,fp);
//            CGeoLayer *layer=NULL;
//            layer=new CGeoLayer();
//            layer->setName(str);
//            fscanf(fp,"%d",&m);
//            for (i=1;i<=m;i++)
//            {
//                fscanf(fp,"%d",&flag);
//                CGeoObject *obj=NULL;
//                if (flag==1)
//                {
//                    obj=new CGeoPolyline();
//                }
//                if (flag==2)
//                {
//                    obj=new CGeoPolygon();
//                }
//                fscanf(fp,"%d,%d",&x,&y);
//                while (x!=-99999||y!=-99999)
//                {
//                    pt.x=(x+1000000)/10000;
//                    pt.y=(y+1000000)/10000;
//                    obj->addPoint(pt);
//                    fscanf(fp,"%d,%d",&x,&y);
//                }
//                layer->addObject(obj);		
//            }
//            this->addLayer(layer);
//        }
//        fclose(fp);	
    }
}

























