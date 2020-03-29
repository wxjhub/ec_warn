package com.vprisk.etl.util;

import sun.audio.*;  
import java.io.*;  
public class Sound   
{  
    public static void main(String[] args)  
    {  
        try {  
            FileInputStream fileau=new  FileInputStream("music/1.au");  
            AudioStream as=new AudioStream(fileau);  
            AudioPlayer.player.start(as);  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
    }  
}  