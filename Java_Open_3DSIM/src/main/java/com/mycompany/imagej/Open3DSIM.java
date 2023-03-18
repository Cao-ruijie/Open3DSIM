/*
 * To the extent possible under law, the ImageJ developers have waived
 * all copyright and related or neighboring rights to this tutorial code.
 *
 * See the CC0 1.0 Universal license for details:
 *     http://creativecommons.org/publicdomain/zero/1.0/
 */

package com.mycompany.imagej;

import net.imagej.Dataset;
import net.imagej.ImageJ;
import net.imagej.ops.OpService;
import net.imglib2.RandomAccessibleInterval;
import net.imglib2.img.Img;
import net.imglib2.type.numeric.RealType;
import org.scijava.command.Command;
import org.scijava.plugin.Parameter;
import org.scijava.plugin.Plugin;
import org.scijava.ui.UIService;

import ij.IJ;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
/**
 * This file is created by CaoRuijie and Xipeng in Peking University
 * We claim an Aphache Liscence.
 */
@Plugin(type = Command.class, menuPath = "Plugins>Open-3DSIM")
public class Open3DSIM<T extends RealType<T>> implements Command {
//  @Parameter
//  private Dataset currentData;
    @Parameter
    private UIService uiService;
    @Parameter
    private OpService opService;
    static{
    	System.out.println(System.getProperty("java.library.path"));
    	//System.loadLibrary("DIP");
    }
    
    @Override
    public void run() {
		try {
			//IJ.error("You are right");
	        final ImageJ ij = new ImageJ();
	        ij.ui().showUI();
	        //IJ.error("You are right");
			test3 frame = new test3();
			frame.setVisible(true);
			frame.setDefaultCloseOperation(frame.DISPOSE_ON_CLOSE);
			//ij.ui().showUI();
		}catch(Exception e) {
			e.printStackTrace();
		}


    }

    /**
     * This main function serves for development purposes.
     * It allows you to run the plugin immediately out of
     * your integrated development environment (IDE).
     */
    public static void main(final String... args) throws Exception {
        // create the ImageJ application
        final ImageJ ij = new ImageJ();
        //ij.ui().showUI();
        //ij.command().run(Open3DSIM.class, true);
        
       // final ImageJ ij = new ImageJ(); 
       // ij.launch(args); // Launch our "Hello World" command right away. 
        ij.command().run(Open3DSIM.class, true);

        }
        

}
