package com.vprisk.etl.util;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import sun.audio.AudioPlayer;
import sun.audio.AudioStream;

public class Music {
	public void MySound() {
		// C:\Program Files\Java\jdk1.6.0\jre\lib\rt.jar这个jar包怎么加进工程，我放在那个工程中也没用
		try {
			InputStream in = new FileInputStream("music/1.au");// 找到这个音乐文件
			AudioStream as = new AudioStream(in);
			AudioPlayer.player.start(as);// 开始播放
			// AudioPlayer.player.stop(as);
		} catch (FileNotFoundException e) {
		} catch (IOException e) {
		}
		return;
	}

	public static void main(String[] args) {
		System.out.println(111);
		new Music();
		System.out.println(22);
	}
}