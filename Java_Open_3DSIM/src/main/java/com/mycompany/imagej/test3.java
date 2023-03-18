package com.mycompany.imagej;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.JTextField;
import java.awt.Component;
import java.awt.Dimension;

import javax.swing.Box;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.io.File;
import java.math.BigDecimal;
import java.net.URL;
import java.text.DecimalFormat;
import java.awt.event.ActionEvent;
import javax.swing.JMenu;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.border.TitledBorder;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;

import org.fairsim.fiji.DisplayWrapper;
import org.fairsim.linalg.Vec2d;
import org.fairsim.linalg.Vec2d.Real;
import org.fairsim.linalg.Vec3d;
import org.fairsim.utils.ImageDisplay;
import org.fairsim.utils.RGBStackMerge;
import com.mathworks.toolbox.javabuilder.MWException;
import com.mathworks.toolbox.javabuilder.MWNumericArray;

import FILTER.filter2;
import PROCESS_DATA.process_data2;
import READ_DATA.read_data2;
import ij.IJ;
import ij.ImagePlus;
import ij.ImageStack;
import ij.Macro;
import ij.WindowManager;
import ij.gui.GenericDialog;
import ij.io.FileInfo;
import ij.io.Opener;
import ij.process.ColorProcessor;
import ij.process.ImageProcessor;
import loci.plugins.in.ImporterOptions;
import loci.plugins.out.Exporter;
import pSIM.pSIM2;
import net.imagej.ImageJ;

import javax.swing.border.EtchedBorder;
import java.awt.Color;
import java.awt.Toolkit;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.SwingConstants;
import javax.swing.SwingWorker;
import java.awt.Choice;

import com.sun.management.OperatingSystemMXBean;

import java.io.File;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.text.DecimalFormat;


//测试类
public class test3 extends JFrame {
	private static final String NULL = null;
	private JPanel contentPane;
	private JTextField textField;
	private JTextField textField_1;
	private JTextField textField_2;
	private JTextField textField_3;
	private JTextField textField_4;
	private JTextField textField_8;
	private JTextField textField_9;
	private JTextField textField_10;
	private JTextField textField_11;
	private JTextField textField_12;
	private JTextField txtDjavaprjopendsimweisidv;
	private JTextField textField_7;
	private JTextField textField_15;
	private JTextField textField_16;
	private JTextField textField_17;
	private JTextField textField_13;
	private JTextField textField_14;
	private int w;
	private int h;
	private int t;
	private String datasets = "0";
	private String output = "0";
	private double NA;
	private double emwavelength;
	private double exwavelength;
	private double refcov;
	private double refmed;
	private double refimm;
	private int numframes;
	private int numchannels;
	private double edge_pixel;
	private double fwd;
	private double depth;
	private int jframe;
	private int jchannel;
	private double notchwidth1;
	private double notchdepth1;
	private double notchwidth2;
	private double notchdepth2;
	private double Attenuation;
	private static Object[] a1;
	private static Object[] a2;
	private static Object[] a3;
	private static Object[] a4;
	private static boolean[] flag = {false,false,false,false};
	private static boolean calib_type = false;
	private static boolean experimental_OTF = false;
	private static boolean simulated_OTF = false;
	private JButton btnProcess = new JButton("Process");
	private JButton btnFilter = new JButton("Filter");
	JButton btnNewButton_2_1 = new JButton("...");
	JButton btnNewButton_2 = new JButton("...");
	JButton btnPdsim = new JButton("pSIM");
	JButton btnNewButton_2_2 = new JButton("...");
	JRadioButton rdbtnNewRadioButton = new JRadioButton("");
	JRadioButton rdbtnNewRadioButton_1_1 = new JRadioButton("");
	JRadioButton rdbtnNewRadioButton_1 = new JRadioButton("");
	JRadioButton rdbtnNewRadioButton_1_2 = new JRadioButton("");
	JRadioButton rdbtnNewRadioButton_1_2_1 = new JRadioButton("");
	JRadioButton rdbtnNewRadioButton_1_2_1_1 = new JRadioButton("");
	private static String none = "*None*";
	private int read_type = 1;
	private boolean runtime_flag = false;
	private boolean ram_flag = false;
	private boolean flag_ram_may = false;
	private static int[] d0_raw_data;



	private String[] columnNames = { "Freq(pixel)","Angle" ,"Phase","Module1","Module2","Evaluation"}; // 定义表格列名数组
	private String[][] tableValues = { { "0", "0", "0", "0","0","no" }, { "0", "0", "0", "0","0","no" },
			{ "0", "0", "0", "0","0","no" } };
	JTable table = new JTable(tableValues, columnNames);
	private String calib1_file="0";
	private String calib2_file="0";
	private String otf_dir="0";
	private JTextField textField_6;
	private JTextField textField_18;
	private JTextField textField_19;
	private JTextField textField_20;
	private JTextField textField_21;
	private JTextField textField_22;
	private JTextField textField_23;
	public static void modifyComponentSize(JFrame frame,float proportionW,float proportionH){
		try 
		{
			Component[] components = frame.getRootPane().getContentPane().getComponents();
			for(Component co:components)
			{
//				String a = co.getClass().getName();//获取类型名称
//				if(a.equals("javax.swing.JLabel"))
//				{
//				}
				float locX = co.getX() * proportionW;
				float locY = co.getY() * proportionH;
				float width = co.getWidth() * proportionW;
				float height = co.getHeight() * proportionH;
				co.setLocation((int)locX, (int)locY);
				co.setSize((int)width, (int)height);
				int size = (int)(co.getFont().getSize() * proportionH);
				Font font = new Font(co.getFont().getFontName(), co.getFont().getStyle(), size);
				co.setFont(font);
			}
		} 
		catch (Exception e) 
		{
			// TODO: handle exception
		}
	}
	
	private String[] getInitialNames(int wList_length,String[] titles) {
	 	String[] names = new String[wList_length];
	 	for (int i=0; i<wList_length; i++)
	 		names[i] = titles[i];
	 	return names;
	 }
	
	String getDirectory(ImagePlus imp) {
		FileInfo fi = imp.getOriginalFileInfo();
		if (fi==null) return null;
		String dir = fi.openNextDir;
		if (dir==null) dir = fi.directory;
		return dir;
	}
	
    private static String showFileOpenDialog (Component parent) {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setCurrentDirectory(new File("."));
        fileChooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
        fileChooser.setMultiSelectionEnabled(false);
        fileChooser.setFileFilter(new FileNameExtensionFilter("image(*.dv, *.tiff, *.tif, *.nd2)", "dv", "tiff", "tif", "nd2"));
        // 打开文件选择框（线程将被阻塞, 直到选择框被关闭）
        int result = fileChooser.showOpenDialog(parent);
        File file = null;
        if (result == JFileChooser.APPROVE_OPTION) {
            file = fileChooser.getSelectedFile();
            return file.getPath();
        }
        else {
        	String temp = "0";
        	return temp;
        }
    }
    
    private static String showFileOpenDialog2 (Component parent) {
        JFileChooser fileChooser = new JFileChooser();
        fileChooser.setCurrentDirectory(new File("."));
        fileChooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
        fileChooser.setMultiSelectionEnabled(false);
        fileChooser.setFileFilter(new FileNameExtensionFilter("Folder", "dv"));
        // 打开文件选择框（线程将被阻塞, 直到选择框被关闭）
        int result = fileChooser.showOpenDialog(parent);
        File file = null;
        if (result == JFileChooser.APPROVE_OPTION) {
            file = fileChooser.getSelectedFile();
            return file.getPath();
        }
        else {
        	String temp = "0";
        	return temp;
        }
    }
    
    public static String transformation(long size){
        return size / 1024 / 1024 / 1024 + "GB"+"   ";
    }

	
	public static Object[] read(String datasets, String output,int numchannels,int numframes,int jchannel,int jframe,int read_type,boolean runtime_flag) {
		//read dv
		if (read_type == 2)
		{
			if ( (d0_raw_data[0]%5!=0) | (d0_raw_data[1]%3!=0) | (d0_raw_data[0]/5!=d0_raw_data[1]/3) )
			{
				IJ.error("Input data is not correct");
				return a1;
			}
		}
		
		
		if (read_type == 1 | read_type == 3)
		{
			if ( (d0_raw_data[0]!=d0_raw_data[1]) | (d0_raw_data[3]%15!=0) )
			{
				IJ.error("Input data is not correct");
				return a1;
			}
		}
		
		if (flag[0] == true)
		{
			try {
				read_data2 sim1 = new read_data2();
				a1 = sim1.read_data(6,datasets,output,numchannels,numframes,jchannel,jframe,read_type);
				runtime_flag = true;
			} catch (MWException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} finally {
				if (runtime_flag == false)
					IJ.error("MATLAB runtime is not installed or correct");
			}

		}
		return a1;
	}
	
	
	public static Object[] process(Object a1_temp,double [] rawpixelsize,double NA,double refmed,double refcov,double refimm,double exwavelength,double emwavelength,double fwd,double depth,double notchwidth1,double notchdepth1,double notchwidth2,double notchdepth2,boolean experimental_OTF,boolean simulated_OTF,double edge_pixel,String otf_dir,double Attenuation ,boolean ram_flag, boolean flag_ram_may) {
		//read dv		
		if (flag[1] == true)
		{   int OTF_flag=0;
			if (experimental_OTF == true)
			{OTF_flag = 0;}
			else
			{OTF_flag = 1;}
			try {
				process_data2 sim2 = new process_data2(); //实例化方法 Object[] a2 =
			    a2 = sim2.process_data(8,a1_temp,rawpixelsize,NA,refmed,refcov,refimm,exwavelength,emwavelength,fwd,depth,notchwidth1,notchdepth1,notchwidth2,notchdepth2,OTF_flag,otf_dir,edge_pixel,Attenuation);
			    ram_flag = true;
			} catch (MWException e1) {
				// TODO Auto-generated catch block
				IJ.error("The RAM is not enough");
				e1.printStackTrace();
				
			} finally {
				if (ram_flag == false && flag_ram_may == true)
				IJ.error("The RAM is not enough");
			}

		}
		return a2;
	}
	
	public static Object[] filt(Object a2_0_temp,Object a2_5_temp,Object a1_2_temp,Object a1_3_temp,Object a1_4_temp,double lambdaregul1,double lambdaregul2,String output,int w,int h,int t) {

		if (flag[2] == true)
		{
			try {
				filter2 sim3 = new filter2(); 
			    a3 = sim3.filter_3D(1,a2_0_temp,a2_5_temp,a1_2_temp,a1_3_temp,a1_4_temp,lambdaregul1,lambdaregul2,output); 
			} catch (MWException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
		}
		return a3;
	}
	
	public static Object[] psim(Object raw_image, Object final_image,Object ang,String calib1_file,String calib2_file,int Nz,int Nx,int Ny,String output,boolean calib_type) {
		//read dv		
		if(calib1_file!="0"&calib2_file!="0")
			calib_type = true;
		if (flag[0] == true)
		{
			try {
				pSIM2 sim4 = new pSIM2();
				a4 = sim4.pSIM(2,raw_image,final_image,ang,calib1_file,calib2_file,Nz,Nx,Ny,output,calib_type);
			} catch (MWException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 

		}
		return a4;
	}
	
	
	

	public class TextFieldFrame extends JFrame implements DocumentListener {
		int fraWidth = this.getWidth();//frame的宽
		int fraHeight = this.getHeight();//frame的高
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		int screenWidth = screenSize.width;
		int screenHeight = screenSize.height;{
		this.setSize(screenWidth, screenHeight);
		this.setLocation(0, 0);
		float proportionW = screenWidth/fraWidth;
		float proportionH = screenHeight/fraHeight;
		modifyComponentSize(this, proportionW,proportionH);
		this.toFront();}
		private JTextField textField;

		public TextFieldFrame() {
			super("动态实时监听TextField");
			init();
		}
		public void init() {
			textField = new JTextField();
			Document doc = textField.getDocument();
			doc.addDocumentListener(this);
		}
		public void insertUpdate(DocumentEvent e) {
			Document doc = e.getDocument();
			try {
				if (doc.getLength()!=0)
				{String s = doc.getText(0, doc.getLength());}
			} catch (BadLocationException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
		}	
		public void removeUpdate(DocumentEvent e) {
			Document doc = e.getDocument();
			try {
				if (doc.getLength()!=0)
				{String s = doc.getText(0, doc.getLength());}
			} catch (BadLocationException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
		}
		
		public void changedUpdate(DocumentEvent e) {
			Document doc = e.getDocument();
			try {
				if (doc.getLength()!=0)
				{String s = doc.getText(0, doc.getLength());}
			} catch (BadLocationException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} 
		}
	 
	}

	
	
	
	/**
	 * Create the frame.
	 * @return 
	 * @throws MWException 
	 */
	//public test3() {
	public test3() throws MWException {

		setTitle("Open-3DSIM");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 488, 714);
		contentPane = new JPanel();
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		//simObj.notifyAll();
		JLabel lblNewLabel = new JLabel("Lamda_ex(nm)");
		lblNewLabel.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel.setBounds(214, 22, 94, 15);
		contentPane.add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("Lamda_em(nm)");
		lblNewLabel_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_1.setBounds(211, 48, 94, 15);
		contentPane.add(lblNewLabel_1);
		
		JLabel lblNewLabel_2 = new JLabel("PXsize_xy(nm)");
		lblNewLabel_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_2.setBounds(214, 72, 105, 15);
		contentPane.add(lblNewLabel_2);
		
		JLabel lblNewLabel_3 = new JLabel("PXsize_z(nm)");
		lblNewLabel_3.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3.setBounds(216, 97, 98, 15);
		contentPane.add(lblNewLabel_3);
		
		JLabel lblNewLabel_4 = new JLabel("NA");
		lblNewLabel_4.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_4.setBounds(238, 121, 53, 15);
		contentPane.add(lblNewLabel_4);
		
		textField = new JTextField();
		textField.setFont(new Font("Arial", Font.PLAIN, 12));
		textField.setHorizontalAlignment(SwingConstants.CENTER);
		textField.setText("488");
		exwavelength = Double.parseDouble(textField.getText());//exwavelength
		textField.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					exwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					exwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					exwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField.setBounds(302, 19, 66, 21);
		contentPane.add(textField);
		textField.setColumns(10);
		
		textField_1 = new JTextField();
		textField_1.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_1.setHorizontalAlignment(SwingConstants.CENTER);
		textField_1.setText("528");
		emwavelength = Double.parseDouble(textField_1.getText());//emwavelength
		textField_1.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					emwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					emwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					emwavelength = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_1.setBounds(302, 44, 66, 21);
		contentPane.add(textField_1);
		textField_1.setColumns(10);
		
		double [] rawpixelsize = {0,0,0};
		textField_2 = new JTextField();
		textField_2.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_2.setHorizontalAlignment(SwingConstants.CENTER);
		textField_2.setText("80");
		rawpixelsize[0] = Double.parseDouble(textField_2.getText());//pixelsize_x
		rawpixelsize[1] = Double.parseDouble(textField_2.getText());//pixelsize_y
		textField_2.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[0] = Double.parseDouble(s);//pixelsize_x
					rawpixelsize[1] = Double.parseDouble(s);//pixelsize_y
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[0] = Double.parseDouble(s);//pixelsize_x
					rawpixelsize[1] = Double.parseDouble(s);//pixelsize_y
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[0] = Double.parseDouble(s);//pixelsize_x
					rawpixelsize[1] = Double.parseDouble(s);//pixelsize_y
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_2.setBounds(302, 69, 66, 21);
		contentPane.add(textField_2);
		textField_2.setColumns(10);
		
		textField_3 = new JTextField();
		textField_3.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_3.setHorizontalAlignment(SwingConstants.CENTER);
		textField_3.setText("125");
		rawpixelsize[2] = Double.parseDouble(textField_3.getText());//pixelsize_z
		textField_3.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[2] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[2] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					rawpixelsize[2] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_3.setBounds(302, 94, 66, 21);
		contentPane.add(textField_3);
		textField_3.setColumns(10);
		
		textField_4 = new JTextField();
		textField_4.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_4.setHorizontalAlignment(SwingConstants.CENTER);
		textField_4.setText("1.4");
		NA = Double.parseDouble(textField_4.getText());//pixelsize_x
		textField_4.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					NA = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					NA = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					NA = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_4.setBounds(302, 119, 66, 21);
		contentPane.add(textField_4);
		textField_4.setColumns(10);
		
		JPanel panel = new JPanel();
		panel.setBorder(new TitledBorder(new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)), "1. Main parameters", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel.setBounds(13, 0, 446, 150);
		contentPane.add(panel);
		panel.setLayout(null);
		
		JLabel lblNewLabel_5 = new JLabel("Input image");
		lblNewLabel_5.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_5.setBounds(12, 22, 84, 15);
		panel.add(lblNewLabel_5);
		
		JLabel lblNewLabel_3_2 = new JLabel("Channel / total");
		lblNewLabel_3_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_2.setBounds(11, 86, 98, 15);
		panel.add(lblNewLabel_3_2);
		
		JLabel lblNewLabel_4_1 = new JLabel("Frame / total");
		lblNewLabel_4_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_4_1.setBounds(18, 119, 84, 15);
		panel.add(lblNewLabel_4_1);
		
		txtDjavaprjopendsimweisidv = new JTextField();
		txtDjavaprjopendsimweisidv.setFont(new Font("Arial", Font.PLAIN, 12));
		txtDjavaprjopendsimweisidv.setHorizontalAlignment(SwingConstants.CENTER);
		txtDjavaprjopendsimweisidv.setText("0");
		txtDjavaprjopendsimweisidv.setColumns(10);
		datasets = txtDjavaprjopendsimweisidv.getText();//
		txtDjavaprjopendsimweisidv.setBounds(81, 19, 84, 21);
		panel.add(txtDjavaprjopendsimweisidv);
		
		textField_7 = new JTextField();
		textField_7.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_7.setHorizontalAlignment(SwingConstants.CENTER);
		textField_7.setText("1");
		jchannel = Integer.parseInt(textField_7.getText());//
		textField_7.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jchannel = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jchannel = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jchannel = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_7.setColumns(10);
		textField_7.setBounds(102, 83, 24, 21);
		panel.add(textField_7);
		
		textField_15 = new JTextField();
		textField_15.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_15.setHorizontalAlignment(SwingConstants.CENTER);
		textField_15.setText("1");
		jframe = Integer.parseInt(textField_15.getText());//
		textField_15.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jframe = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jframe = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					jframe = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_15.setColumns(10);
		textField_15.setBounds(102, 116, 24, 21);
		panel.add(textField_15);
		
		textField_16 = new JTextField();
		textField_16.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_16.setHorizontalAlignment(SwingConstants.CENTER);
		textField_16.setText("1");
		numchannels = Integer.parseInt(textField_16.getText());//
		textField_16.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numchannels = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numchannels = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numchannels = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_16.setColumns(10);
		textField_16.setBounds(140, 83, 24, 21);
		panel.add(textField_16);
		
		textField_17 = new JTextField();
		textField_17.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_17.setHorizontalAlignment(SwingConstants.CENTER);
		textField_17.setText("1");
		numframes = Integer.parseInt(textField_17.getText());//
		textField_17.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numframes = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numframes = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					numframes = Integer.parseInt(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_17.setColumns(10);
		textField_17.setBounds(140, 116, 24, 21);
		panel.add(textField_17);
		
		JButton btnRead = new JButton("Read");
		btnRead.setFont(new Font("Arial", Font.PLAIN, 12));
		btnRead.setEnabled(false);
		btnRead.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {	
				System.out.println("Pressed");
				if(e.getSource()==btnRead)
				{flag[0] = true;System.out.println("Pressed");}
				if (output!="0"&&datasets!="0")
				{  	btnRead.setEnabled(false);
				    textField_6.setText("Reading...");

					a1 = read(datasets,output,numchannels,numframes,jchannel,jframe,read_type,runtime_flag);

					int[] w_temp =((MWNumericArray) a1[2]).getIntData();
					w = w_temp[0];
					int[] h_temp =((MWNumericArray) a1[3]).getIntData();
					h = h_temp[0];
					int[] t_temp =((MWNumericArray) a1[4]).getIntData();
					t = t_temp[0];   
					// Fiji中显示WF
					ImageDisplay pwSt1 = new DisplayWrapper(w/2,h/2,"Wide-field image");
					Vec2d.Real wf = Vec2d.createReal(w/2, h/2);				
					int[] wf_temp = ((MWNumericArray) a1[1]).getIntData();
					for (int i = 0; i < t; i++) {
						wf.zero();
						for (int y=0; y<h/2; y++)
							for (int x=0; x<w/2; x++)
								wf.set(x, y, wf_temp[i*w*h/4 + x*w/2 + y] );
					    pwSt1.addImage( wf, String.format("Slice: %1d",i+1));
					}
					pwSt1.display();

					textField_6.setText("Please choose OTF and click Process");
					textField_18.setText(String.valueOf(0.4*w/1024));
					textField_20.setText(String.valueOf(0.5*w/1024));
					rdbtnNewRadioButton_1_1.setEnabled(true);
					rdbtnNewRadioButton_1.setEnabled(true);
					btnProcess.setEnabled(true);
					
			        OperatingSystemMXBean mem = (OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
			        // 获取内存总容量
			        long totalMemorySize = mem.getTotalPhysicalMemorySize();
			        // 获取可用内存容量
			        long freeMemorySize = mem.getFreePhysicalMemorySize();
			        String temp = transformation(totalMemorySize);
			        String temp1 = temp.substring(0,temp.lastIndexOf("G"));
			        int memory = Integer.valueOf(temp1);
			        int size_image = w*h*t/512/512/4;
			        if (size_image>memory*memory/64*3+3)
			        	{flag_ram_may = true;
			        	IJ.error("The RAM is: " + transformation(totalMemorySize) + ", it may be out of memory");}				
		        } 
			}
		});
		System.out.println("Pressed");
		btnRead.setBounds(365, 68, 69, 23);
		panel.add(btnRead);
		
		JLabel lblNewLabel_4_1_1 = new JLabel("/");
		lblNewLabel_4_1_1.setBounds(131, 119, 38, 15);
		panel.add(lblNewLabel_4_1_1);
		
		JLabel lblNewLabel_4_1_1_1 = new JLabel("/");
		lblNewLabel_4_1_1_1.setBounds(130, 86, 38, 15);
		panel.add(lblNewLabel_4_1_1_1);
		
		
		JButton btnNewButton = new JButton("...");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				/*ImagePlus imp1 = IJ.openImage("D:\\java\\Prj09_Open3DSIM\\input\\20221019_Actin_488_1518_006-1.tif");
				imp1 = Opener.openUsingBioFormats("D:\\java\\Prj09_Open3DSIM\\input\\\\20221019_Actin_488_1518_006-1.tif");
				if (imp1==null) {
					IJ.log("openImage() and openUsingBioFormats() returned null: "+output + "pSIM.tif");}
				imp1.show();
				
				ImagePlus imp2 = IJ.openImage("D:\\java\\Prj09_Open3DSIM\\input\\mpImage(00255)-2.tif");
				imp2 = Opener.openUsingBioFormats("D:\\java\\Prj09_Open3DSIM\\input\\mpImage(00255)-2.tif");
				if (imp2==null) {
					IJ.log("openImage() and openUsingBioFormats() returned null: "+output + "pSIM.tif");}
				imp2.show();	
				
				ImagePlus imp3 = IJ.openImage("D:\\java\\Prj09_Open3DSIM\\input\\NSIM_Actin_ex488_oil1512.tif");
				imp3 = Opener.openUsingBioFormats("D:\\java\\Prj09_Open3DSIM\\input\\NSIM_Actin_ex488_oil1512.tif");
				if (imp3==null) {
					IJ.log("openImage() and openUsingBioFormats() returned null: "+output + "pSIM.tif");}
				imp3.show();
				
				ImagePlus imp4 = IJ.openImage("D:\\java\\Prj09_Open3DSIM\\input\\calib488_2.tif");
				imp4 = Opener.openUsingBioFormats("D:\\java\\Prj09_Open3DSIM\\input\\calib488_2.tif");
				if (imp4==null) {
					IJ.log("There is no image in the directory");}
				imp4.show();
		
				*/
				int[] wList = WindowManager.getIDList();
				if (wList==null) {
					IJ.error("No images are open.");
					return;
				}
				String[] titles = new String[wList.length+1];
				String[] all_input = new String[wList.length+1];
				for (int i=0; i<wList.length; i++) {
					ImagePlus imp = WindowManager.getImage(wList[i]);
					all_input[i] = getDirectory(imp);
					titles[i] = imp!=null?imp.getTitle():"";
				}
				titles[wList.length] = none;
				all_input[wList.length] = none;
				String[] names = getInitialNames(wList.length,titles);
				String[] all_dir = getInitialNames(wList.length,all_input);
				
				String options = Macro.getOptions();
				boolean macro = IJ.macroRunning() && options!=null;
				
				GenericDialog gd = new GenericDialog("Input image");
				gd.addChoice("Input image:", titles, macro?none:names[0]);				
				gd.showDialog();
				
				if (gd.wasCanceled())
					return;
				else
				{
					int index = gd.getNextChoiceIndex();
					datasets = all_dir[index] + titles[index];
					ImagePlus imp = WindowManager.getImage(wList[index]);
					d0_raw_data = imp.getDimensions();
					output = datasets.substring(0,datasets.lastIndexOf("\\"));
				    output = output+ "\\";
				}
				
		        txtDjavaprjopendsimweisidv.setText(datasets);
		        if (datasets!="0")
		        {
		        	btnRead.setEnabled(true);
		        	rdbtnNewRadioButton_1_2.setEnabled(true);
		        	rdbtnNewRadioButton_1_2_1.setEnabled(true);
		        	rdbtnNewRadioButton_1_2_1_1.setEnabled(true);
		        }
				
				
//		        final JFrame jf = new JFrame("测试窗口");
//		        datasets = showFileOpenDialog(jf); 
//		        output = datasets.substring(0,datasets.lastIndexOf("\\"));
//		        output = output+ "\\";
//		        txtDjavaprjopendsimweisidv.setText(datasets);
//		        if (datasets!="0")
//		        {btnRead.setEnabled(true);}
			}
		});
		btnNewButton.setBounds(164, 18, 24, 23);
		panel.add(btnNewButton);
		rdbtnNewRadioButton_1_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton_1_2.isSelected())
				{
					read_type = 1;
					textField_2.setText("80");
					textField_3.setText("125");
					textField_4.setText("1.4");
					textField_8.setText("1.47");
					textField_9.setText("1.512");
					textField_10.setText("1.518");
					textField.setText("488");
					textField_1.setText("528");
					textField_11.setText("140");
					textField_12.setText("0");	
					btnRead.setEnabled(true);
				}
				rdbtnNewRadioButton_1_2_1.setSelected(false);
				rdbtnNewRadioButton_1_2_1_1.setSelected(false);			
			}
		});
		

		rdbtnNewRadioButton_1_2.setEnabled(false);
		rdbtnNewRadioButton_1_2.setSelected(true);
		rdbtnNewRadioButton_1_2.setBounds(44, 50, 21, 23);
		panel.add(rdbtnNewRadioButton_1_2);
		
		JLabel lblNewLabel_5_1 = new JLabel("OMX");
		lblNewLabel_5_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_5_1.setBounds(17, 55, 33, 15);
		panel.add(lblNewLabel_5_1);
		rdbtnNewRadioButton_1_2_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton_1_2_1.isSelected())
				{
					read_type = 2;
					textField_2.setText("65");
					textField_3.setText("120");
					textField_4.setText("1.49");
					textField_8.setText("1.52");
					textField_9.setText("1.512");
					textField_10.setText("1.512");
					textField.setText("488");
					textField_1.setText("525");
					textField_11.setText("120");
					textField_12.setText("0");
					btnRead.setEnabled(true);
				}
				rdbtnNewRadioButton_1_2.setSelected(false);
				rdbtnNewRadioButton_1_2_1_1.setSelected(false);	
			}
		});
		
		rdbtnNewRadioButton_1_2_1.setEnabled(false);
		rdbtnNewRadioButton_1_2_1.setBounds(103, 50, 21, 23);
		panel.add(rdbtnNewRadioButton_1_2_1);
		
		JLabel lblNewLabel_5_1_1 = new JLabel("NSIM");
		lblNewLabel_5_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_5_1_1.setBounds(73, 55, 34, 15);
		panel.add(lblNewLabel_5_1_1);
		
		JLabel lblNewLabel_5_1_1_1 = new JLabel("Home");
		lblNewLabel_5_1_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_5_1_1_1.setBounds(130, 54, 38, 15);
		panel.add(lblNewLabel_5_1_1_1);
		rdbtnNewRadioButton_1_2_1_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton_1_2_1_1.isSelected())
				{
					read_type = 3;
					textField_2.setText("65");
					textField_3.setText("125");
					textField_4.setText("1.49");
					textField_8.setText("1.47");
					textField_9.setText("1.512");
					textField_10.setText("1.515");
					textField.setText("561");
					textField_1.setText("610");
					textField_11.setText("120");
					textField_12.setText("0");
					btnRead.setEnabled(true);
				}
				rdbtnNewRadioButton_1_2_1.setSelected(false);
				rdbtnNewRadioButton_1_2.setSelected(false);	
			}
		});
		
		rdbtnNewRadioButton_1_2_1_1.setEnabled(false);
		rdbtnNewRadioButton_1_2_1_1.setBounds(164, 49, 21, 23);
		panel.add(rdbtnNewRadioButton_1_2_1_1);
		
		JPanel panel_1 = new JPanel();
		panel_1.setBorder(new TitledBorder(new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)), "2. Process data", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_1.setBounds(14, 157, 445, 141);
		contentPane.add(panel_1);
		btnProcess.setFont(new Font("Arial", Font.PLAIN, 12));
		btnProcess.setBounds(54, 101, 82, 23);
		
		btnProcess.setEnabled(false);
		btnProcess.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("Pressed");
				if(e.getSource()==btnProcess)
				{flag[1] = true;System.out.println("Pressed");}
				btnProcess.setEnabled(false);
				textField_6.setText("Processing...");
				a2 = process(a1[0],rawpixelsize,NA,refmed,refcov,refimm,exwavelength,emwavelength,fwd,depth,notchwidth1,notchdepth1,notchwidth2,notchdepth2,experimental_OTF,simulated_OTF,edge_pixel,otf_dir,Attenuation,ram_flag,flag_ram_may);
				double[] freq =((MWNumericArray) a2[1]).getDoubleData();
				double[] ang =((MWNumericArray) a2[2]).getDoubleData();
				double[] pha =((MWNumericArray) a2[3]).getDoubleData();
				double[] module =((MWNumericArray) a2[4]).getDoubleData();
				
			    DecimalFormat format = new DecimalFormat("0.00");

				String freq1 = format.format(new BigDecimal(String.valueOf(Math.sqrt(freq[0]*freq[0]+freq[1]*freq[1]))));
				String freq2 = format.format(new BigDecimal(String.valueOf(Math.sqrt(freq[2]*freq[2]+freq[3]*freq[3]))));
				String freq3 = format.format(new BigDecimal(String.valueOf(Math.sqrt(freq[4]*freq[4]+freq[5]*freq[5]))));
				String ang1 = format.format(new BigDecimal(String.valueOf(ang[0])));
				String ang2 = format.format(new BigDecimal(String.valueOf(ang[1])));
				String ang3 = format.format(new BigDecimal(String.valueOf(ang[2])));
				String pha1 = format.format(new BigDecimal(String.valueOf(pha[0])));
				String pha2 = format.format(new BigDecimal(String.valueOf(pha[5])));
				String pha3 = format.format(new BigDecimal(String.valueOf(pha[10])));
				
				DecimalFormat format2 = new DecimalFormat("0.000");
				String module11 =format2.format(new BigDecimal(String.valueOf(module[0])));
				String module12 =format2.format(new BigDecimal(String.valueOf(module[1])));
				String module21 =format2.format(new BigDecimal(String.valueOf(module[2])));
				String module22 =format2.format(new BigDecimal(String.valueOf(module[3])));
				String module31 =format2.format(new BigDecimal(String.valueOf(module[4])));
				String module32 =format2.format(new BigDecimal(String.valueOf(module[5])));

		        table.setValueAt(freq1,0,0);//修改第3行，第4列为666
		        table.setValueAt(freq2,1,0);
		        table.setValueAt(freq3,2,0);
		        table.setValueAt(ang1,0,1);
		        table.setValueAt(ang2,1,1);
		        table.setValueAt(ang3,2,1);
		        table.setValueAt(pha1,0,2);
		        table.setValueAt(pha2,1,2);
		        table.setValueAt(pha3,2,2);
		        table.setValueAt(module11,0,3);
		        table.setValueAt(module21,1,3);
		        table.setValueAt(module31,2,3);
		        table.setValueAt(module12,0,4);
		        table.setValueAt(module22,1,4);
		        table.setValueAt(module32,2,4);
		        
		        if (module[0]>0.1 && module[1] >0.1)
		        {table.setValueAt("Good",0,5);}
		        else if(module[0]>0.05 && module[1] >0.05)
		        {table.setValueAt("Feasible",0,5);}
		        else
		        {table.setValueAt("Bad",0,5);}
		        
		        if (module[2]>0.1 && module[3] >0.1)
		        {table.setValueAt("Good",1,5);}
		        else if(module[2]>0.05 && module[3] >0.05)
		        {table.setValueAt("Feasible",1,5);}
		        else
		        {table.setValueAt("Bad",1,5);}
		        
		        if (module[4]>0.1 && module[5] >0.1)
		        {table.setValueAt("Good",2,5);}
		        else if(module[4]>0.05 && module[5] >0.05)
		        {table.setValueAt("Feasible",2,5);}
		        else
		        {table.setValueAt("Bad",2,5);} 
		        
		        
				ImageDisplay pwSt1 = new DisplayWrapper(w/2,h/2,"FFT of raw image");
				Vec2d.Real wf = Vec2d.createReal(w/2, h/2);				
				int[] wf_temp = ((MWNumericArray) a2[6]).getIntData();
				for (int i = 0; i < 15; i++) {
					wf.zero();
					for (int y=0; y<h/2; y++)
						for (int x=0; x<w/2; x++)
							wf.set(x, y, wf_temp[i*w*h/4 + x*w/2 + y] );
				    pwSt1.addImage( wf, String.format("Angle: %1d, Phase: %1d",(i)/5+1,(i)%5+1));
				}
				pwSt1.display();
				
				ImageDisplay pwSt2 = new DisplayWrapper(w,h,"Seperated FFT");
				Vec2d.Real wf0 = Vec2d.createReal(w, h);				
				int[] wf0_temp = ((MWNumericArray) a2[7]).getIntData();
				for (int i = 0; i < 6; i++) {
					wf0.zero();
					for (int y=0; y<h; y++)
						for (int x=0; x<w; x++)
							wf0.set(x, y, wf0_temp[i*w*h + x*w + y] );
				    pwSt2.addImage( wf0, String.format("Angle: %1d, Freq: %1d",(i)/2+1,(i)%2+1));
				}
				pwSt2.display();
				
		        
				textField_6.setText("Please click Filter");
		        table.repaint();
				btnFilter.setEnabled(true);
			}
		});
		panel_1.setLayout(null);
		panel_1.add(btnProcess);
		
		JPanel panel_4_1 = new JPanel();
		panel_4_1.setBorder(new TitledBorder(new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)), "Experimental OTF", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_4_1.setBounds(10, 44, 164, 50);
		panel_1.add(panel_4_1);
		panel_4_1.setLayout(null);
		
		JLabel lblNewLabel_3_1_2_3_1_2 = new JLabel("OTF Dir");
		lblNewLabel_3_1_2_3_1_2.setBounds(74, 22, 52, 14);
		lblNewLabel_3_1_2_3_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		panel_4_1.add(lblNewLabel_3_1_2_3_1_2);
		
		btnNewButton_2_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
//		        final JFrame jf = new JFrame("测试窗口");
//				otf_dir = showFileOpenDialog(jf);
//				btnProcess.setEnabled(true);
				
				
				
				int[] wList = WindowManager.getIDList();
				if (wList==null) {
					IJ.error("No images are open.");
					return;
				}
				String[] titles = new String[wList.length+1];
				String[] all_input = new String[wList.length+1];
				for (int i=0; i<wList.length; i++) {
					ImagePlus imp = WindowManager.getImage(wList[i]);
					all_input[i] = getDirectory(imp);
					titles[i] = imp!=null?imp.getTitle():"";
				}
				titles[wList.length] = none;
				all_input[wList.length] = none;
				String[] names = getInitialNames(wList.length,titles);
				String[] all_dir = getInitialNames(wList.length,all_input);
				
				String options = Macro.getOptions();
				boolean macro = IJ.macroRunning() && options!=null;
				
				GenericDialog gd = new GenericDialog("Merge Channels");
				gd.addChoice("Experimental OTF:", titles, macro?none:names[0]);				
				gd.showDialog();
				
				if (gd.wasCanceled())
					return;
				else
				{
					int index = gd.getNextChoiceIndex();
					otf_dir = all_dir[index] + titles[index];
				}
				
		        if (otf_dir!="0")
		        {btnProcess.setEnabled(true);}
			}
		});
		btnNewButton_2_2.setBounds(126, 18, 27, 23);
		btnNewButton_2_2.setEnabled(false);
		panel_4_1.add(btnNewButton_2_2);
		
		
		rdbtnNewRadioButton_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton_1.isSelected())
				{   experimental_OTF = true;
				    rdbtnNewRadioButton_1_1.setEnabled(false);
				    textField_8.setEnabled(false);
					textField_9.setEnabled(false);
					textField_10.setEnabled(false);
					textField_11.setEnabled(false);
					textField_12.setEnabled(false);
					btnNewButton_2_2.setEnabled(true);
				 }
				else
				{   experimental_OTF = false;
				    rdbtnNewRadioButton_1_1.setEnabled(true);
				    textField_8.setEnabled(true);
					textField_9.setEnabled(true);
					textField_10.setEnabled(true);
					textField_11.setEnabled(true);
					textField_12.setEnabled(true);
					btnNewButton_2_2.setEnabled(true);
				 }
			}
		});
		rdbtnNewRadioButton_1.setBounds(34, 18, 21, 23);
		panel_4_1.add(rdbtnNewRadioButton_1);
		rdbtnNewRadioButton_1.setEnabled(false);
		
		JLabel lblNewLabel_3_1_5_1 = new JLabel("If");
		lblNewLabel_3_1_5_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_5_1.setBounds(17, 22, 57, 15);
		panel_4_1.add(lblNewLabel_3_1_5_1);
		
		JPanel panel_4_1_1 = new JPanel();
		panel_4_1_1.setBounds(176, 38, 260, 94);
		panel_1.add(panel_4_1_1);
		panel_4_1_1.setBorder(new TitledBorder(new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)), "Simulated OTF", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_4_1_1.setLayout(null);
		
		JLabel lblNewLabel_3_1_2 = new JLabel("Redimm");
		lblNewLabel_3_1_2.setBounds(10, 69, 72, 15);
		panel_4_1_1.add(lblNewLabel_3_1_2);
		lblNewLabel_3_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		
		textField_10 = new JTextField();
		textField_10.setBounds(62, 66, 52, 21);
		panel_4_1_1.add(textField_10);
		textField_10.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_10.setHorizontalAlignment(SwingConstants.CENTER);
		textField_10.setText("1.518");
		refimm = Double.parseDouble(textField_10.getText());//redimm
		textField_10.getDocument().addDocumentListener (new DocumentListener() {
				@Override
				public void insertUpdate(DocumentEvent e) {
					Document doc = e.getDocument();
					try {
						String s ;
						if (doc.getLength()==0)  {s = "0";}
						else                     
						{
							s = doc.getText(0, doc.getLength());
							if( s.substring(0,s.length()-1) == ".")
							{s="0";}
						}
						refimm = Double.parseDouble(s);//pixelsize_x
					} catch (BadLocationException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}		
				}
				@Override
				public void removeUpdate(DocumentEvent e) {
					Document doc = e.getDocument();
					try {
						String s ;
						if (doc.getLength()==0)  {s = "0";}
						else                     
						{
							s = doc.getText(0, doc.getLength());
							if( s.substring(0,s.length()-1) == ".")
							{s="0";}
						}
						refimm = Double.parseDouble(s);//pixelsize_x
					} catch (BadLocationException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}			
				}
				@Override
				public void changedUpdate(DocumentEvent e) {
					Document doc = e.getDocument();
					try {
						String s ;
						if (doc.getLength()==0)  {s = "0";}
						else                     
						{
							s = doc.getText(0, doc.getLength());
							if( s.substring(0,s.length()-1) == ".")
							{s="0";}
						}
						refimm = Double.parseDouble(s);//pixelsize_x
					} catch (BadLocationException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}		
				}							
			});
		textField_10.setColumns(10);
		
		rdbtnNewRadioButton_1_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton_1_1.isSelected()) {
				simulated_OTF = true;
				rdbtnNewRadioButton_1.setEnabled(false);
				btnNewButton_2_2.setEnabled(false);
				textField_9.setEnabled(true);
				textField_10.setEnabled(true);
				textField_8.setEnabled(true);
				textField_11.setEnabled(true);
				textField_12.setEnabled(true);
				btnProcess.setEnabled(true);
				textField_6.setText("Please click Process");}
				else
				{simulated_OTF = false;
				rdbtnNewRadioButton_1.setEnabled(true);
				btnNewButton_2_2.setEnabled(true);
				textField_8.setEnabled(false);
				textField_9.setEnabled(false);
				textField_10.setEnabled(false);
				textField_11.setEnabled(false);
				textField_12.setEnabled(false);
				btnProcess.setEnabled(true);
				textField_6.setText("Please click Process");}
			}
		});
		rdbtnNewRadioButton_1_1.setEnabled(false);
		rdbtnNewRadioButton_1_1.setSelected(true);
		
		rdbtnNewRadioButton_1_1.setBounds(64, 13, 21, 23);
		panel_4_1_1.add(rdbtnNewRadioButton_1_1);
		
		JLabel lblNewLabel_3_1_5 = new JLabel("If");
		lblNewLabel_3_1_5.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_5.setBounds(38, 17, 57, 15);
		panel_4_1_1.add(lblNewLabel_3_1_5);
		
		textField_22 = new JTextField();
		textField_22.setText("0");
		edge_pixel = Double.parseDouble(textField_22.getText());//redimm
		textField_22.setHorizontalAlignment(SwingConstants.CENTER);
		textField_22.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_22.setColumns(10);
		textField_22.setBounds(78, 15, 43, 21);
		textField_22.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					edge_pixel = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					edge_pixel = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					edge_pixel = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		panel_1.add(textField_22);
		
		JLabel lblNewLabel_3_1_4 = new JLabel("Edgetaper");
		lblNewLabel_3_1_4.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_4.setBounds(13, 19, 72, 15);
		panel_1.add(lblNewLabel_3_1_4);
		
		JLabel lblNewLabel_3_1_4_1 = new JLabel("Defalut 0");
		lblNewLabel_3_1_4_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_4_1.setBounds(128, 19, 72, 15);
		panel_1.add(lblNewLabel_3_1_4_1);

		double []lambdaregul = {0,0};
		JPanel panel_2 = new JPanel();
		panel_2.setBorder(new TitledBorder(new EtchedBorder(EtchedBorder.LOWERED, new Color(255, 255, 255), new Color(160, 160, 160)), "3. Filter and reconstruction", TitledBorder.LEADING, TitledBorder.TOP, null, new Color(0, 0, 0)));
		panel_2.setBounds(13, 301, 446, 134);
		contentPane.add(panel_2);
		panel_2.setLayout(null);
		textField_13 = new JTextField();
		textField_13.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_13.setHorizontalAlignment(SwingConstants.CENTER);
		textField_13.setText("0.5");
		lambdaregul[0] = Double.parseDouble(textField_13.getText());//lamda1
		textField_13.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[0] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[0] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[0] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_13.setColumns(10);
		textField_13.setBounds(57, 23, 66, 21);
		panel_2.add(textField_13);
		
		JLabel lblNewLabel_3_1_3 = new JLabel("λ1");
		lblNewLabel_3_1_3.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3.setBounds(18, 25, 72, 15);
		panel_2.add(lblNewLabel_3_1_3);
		
		JLabel lblNewLabel_3_1_3_1 = new JLabel("λ2");
		lblNewLabel_3_1_3_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_1.setBounds(18, 71, 72, 15);
		panel_2.add(lblNewLabel_3_1_3_1);
		
		textField_14 = new JTextField();
		textField_14.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_14.setHorizontalAlignment(SwingConstants.CENTER);
		textField_14.setText("0.1");
		lambdaregul[1] = Double.parseDouble(textField_14.getText());//lamda1
		textField_14.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[1] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[1] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					lambdaregul[1] = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_14.setColumns(10);
		textField_14.setBounds(57, 68, 66, 21);
		panel_2.add(textField_14);
		btnFilter.setFont(new Font("Arial", Font.PLAIN, 12));
		
		btnFilter.setEnabled(false);
		btnFilter.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("Pressed");
				if(e.getSource()==btnFilter)
				{flag[2] = true;System.out.println("Pressed");}
				btnFilter.setEnabled(false);
				textField_6.setText("Filtering...");
				new Thread(new Runnable() {
					public void run() {
					textField_6.setText("Filtering...");
					a3 = filt(a2[0],a2[5],a1[2],a1[3],a1[4],lambdaregul[0],lambdaregul[1],output,w,h,t);
					
					ImageDisplay pwSt2 = new DisplayWrapper(w,h,"Open-3DSIM image");
					Vec2d.Real sim = Vec2d.createReal(w, h);				
					int[] sim_temp = ((MWNumericArray) a3[0]).getIntData();
					for (int i = 0; i < t; i++) {
						sim.zero();
						for (int y = 0; y < h; y++)
							for (int x=0; x<w; x++)
								sim.set(x, y, sim_temp[i*w*h + x*w + y] );
					    pwSt2.addImage( sim, String.format("Slice: %1d",i+1));
					}
					pwSt2.display();

					btnPdsim.setEnabled(true);
					rdbtnNewRadioButton.setEnabled(true);
					btnFilter.setEnabled(true);
					}
					}).start();
				textField_6.setText("please choose pSIM or exit");
			}
		});
		btnFilter.setBounds(361, 54, 66, 23);
		panel_2.add(btnFilter);

		
		JLabel lblNewLabel_3_1_3_2 = new JLabel("Suggest value: 0.4-2");
		lblNewLabel_3_1_3_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2.setBounds(13, 48, 121, 15);
		panel_2.add(lblNewLabel_3_1_3_2);
		
		JLabel lblNewLabel_3_1_3_2_1 = new JLabel("Suggest value: 0.01-0.4");
		lblNewLabel_3_1_3_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2_1.setBounds(7, 94, 138, 15);
		panel_2.add(lblNewLabel_3_1_3_2_1);
		
		textField_18 = new JTextField();
		textField_18.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_18.setText("0.4");
		textField_18.setHorizontalAlignment(SwingConstants.CENTER);
		textField_18.setColumns(10);
		textField_18.setBounds(227, 17, 66, 21);
		textField_18.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		panel_2.add(textField_18);
		
		textField_19 = new JTextField();
		textField_19.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_19.setText("0.92");
		notchdepth1 = Double.parseDouble(textField_19.getText());
		textField_19.setHorizontalAlignment(SwingConstants.CENTER);
		textField_19.setColumns(10);
		textField_19.setBounds(227, 46, 66, 21);
		textField_19.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth1 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		panel_2.add(textField_19);
		
		textField_20 = new JTextField();
		textField_20.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_20.setText("0.5");
		textField_20.setHorizontalAlignment(SwingConstants.CENTER);
		textField_20.setColumns(10);
		textField_20.setBounds(227, 75, 66, 21);
		notchwidth2 = Double.parseDouble(textField_20.getText());
		textField_20.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchwidth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		panel_2.add(textField_20);
		
		textField_21 = new JTextField();
		textField_21.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_21.setText("0.98");
		notchdepth2 = Double.parseDouble(textField_21.getText());
		textField_21.setHorizontalAlignment(SwingConstants.CENTER);
		textField_21.setColumns(10);
		textField_21.setBounds(227, 103, 66, 21);
		textField_21.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					notchdepth2 = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		panel_2.add(textField_21);
		
		JLabel lblNewLabel_3_1_2_2_2 = new JLabel("Notchwidth1");
		lblNewLabel_3_1_2_2_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_2.setBounds(148, 21, 72, 15);
		panel_2.add(lblNewLabel_3_1_2_2_2);
		
		JLabel lblNewLabel_3_1_2_2_2_1 = new JLabel("Notchdepth1");
		lblNewLabel_3_1_2_2_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_2_1.setBounds(148, 49, 72, 15);
		panel_2.add(lblNewLabel_3_1_2_2_2_1);
		
		JLabel lblNewLabel_3_1_2_2_2_2 = new JLabel("Notchwidth2");
		lblNewLabel_3_1_2_2_2_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_2_2.setBounds(148, 79, 72, 15);
		panel_2.add(lblNewLabel_3_1_2_2_2_2);
		
		JLabel lblNewLabel_3_1_2_2_2_2_1 = new JLabel("Notchdepth2");
		lblNewLabel_3_1_2_2_2_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_2_2_1.setBounds(148, 106, 72, 15);
		panel_2.add(lblNewLabel_3_1_2_2_2_2_1);
		
		JLabel lblNewLabel_3_1_3_2_1_1 = new JLabel("0.2-0.6");
		lblNewLabel_3_1_3_2_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2_1_1.setBounds(303, 20, 43, 15);
		panel_2.add(lblNewLabel_3_1_3_2_1_1);
		
		JLabel lblNewLabel_3_1_3_2_1_1_1 = new JLabel("0.2-0.6");
		lblNewLabel_3_1_3_2_1_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2_1_1_1.setBounds(304, 79, 43, 15);
		panel_2.add(lblNewLabel_3_1_3_2_1_1_1);
		
		JLabel lblNewLabel_3_1_3_2_1_1_2 = new JLabel("0.8-0.99");
		lblNewLabel_3_1_3_2_1_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2_1_1_2.setBounds(300, 49, 61, 15);
		panel_2.add(lblNewLabel_3_1_3_2_1_1_2);
		
		JLabel lblNewLabel_3_1_3_2_1_1_2_1 = new JLabel("0.8-0.99");
		lblNewLabel_3_1_3_2_1_1_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_3_2_1_1_2_1.setBounds(300, 106, 61, 15);
		panel_2.add(lblNewLabel_3_1_3_2_1_1_2_1);
		
		JLabel lblNewLabel_3_1_2_2_1 = new JLabel("Angle1");
		lblNewLabel_3_1_2_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_1.setBounds(24, 553, 72, 15);
		contentPane.add(lblNewLabel_3_1_2_2_1);
		
		JLabel lblNewLabel_3_1_2_2_1_1 = new JLabel("Angle2");
		lblNewLabel_3_1_2_2_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_1_1.setBounds(24, 572, 72, 15);
		contentPane.add(lblNewLabel_3_1_2_2_1_1);
		
		JLabel lblNewLabel_3_1_2_2_1_2 = new JLabel("Angle3");
		lblNewLabel_3_1_2_2_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_2_1_2.setBounds(24, 592, 72, 15);
		contentPane.add(lblNewLabel_3_1_2_2_1_2);
		
		JLabel lblNewLabel_8 = new JLabel("Freq(pixel)");
		lblNewLabel_8.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8.setBounds(68, 529, 66, 15);
		contentPane.add(lblNewLabel_8);
		
		JLabel lblNewLabel_8_1 = new JLabel("Phase");
		lblNewLabel_8_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8_1.setBounds(211, 529, 38, 15);
		contentPane.add(lblNewLabel_8_1);
		
		JLabel lblNewLabel_8_1_1 = new JLabel("Module1");
		lblNewLabel_8_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8_1_1.setBounds(268, 529, 72, 15);
		contentPane.add(lblNewLabel_8_1_1);
		
		JLabel lblNewLabel_8_1_1_1 = new JLabel("Evaluation");
		lblNewLabel_8_1_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8_1_1_1.setBounds(387, 529, 72, 15);
		contentPane.add(lblNewLabel_8_1_1_1);
		

		JLabel lblNewLabel_8_1_1_2 = new JLabel("Module2");
		lblNewLabel_8_1_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8_1_1_2.setBounds(330, 529, 72, 15);
		contentPane.add(lblNewLabel_8_1_1_2);

        // 设置表格中的数据居中显示
        DefaultTableCellRenderer r=new DefaultTableCellRenderer();
        r.setHorizontalAlignment(JLabel.CENTER);
        table.setFont(new Font("Arial", Font.PLAIN, 12));
        table.setDefaultRenderer(Object.class,r);	
		table.setBounds(70, 550, 380, 60);
		table.setRowHeight(20);
		contentPane.add(table);
		
		JLabel lblNewLabel_8_1_2 = new JLabel("Angle");
		lblNewLabel_8_1_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_8_1_2.setBounds(150, 529, 38, 15);
		contentPane.add(lblNewLabel_8_1_2);
		
		JPanel panel_3 = new JPanel();
		panel_3.setBorder(new TitledBorder(null, "4. Polarization 3D-SIM", TitledBorder.LEADING, TitledBorder.TOP, null, null));
		panel_3.setBounds(13, 440, 445, 79);
		contentPane.add(panel_3);
		panel_3.setLayout(null);
		btnPdsim.setFont(new Font("Arial", Font.PLAIN, 12));
		
		btnPdsim.setEnabled(false);
		btnPdsim.setBounds(354, 30, 72, 23);
		panel_3.add(btnPdsim);
		btnPdsim.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("Pressed");
				if(e.getSource()==btnPdsim)
				{flag[3] = true;System.out.println("Pressed");}
				btnPdsim.setEnabled(false);
				textField_6.setText("pSIMing...");
				new Thread(new Runnable() {
					public void run() {
					a4 = psim(a1[5], a3[0],a2[2],calib1_file,calib2_file,t,w,h,output,calib_type);
					IJ.openImage(output + "pSIM.tif");
					IJ.openImage(output + "cm.tif");
					ImagePlus imp = IJ.openImage(output + "pSIM.tif");
					imp = Opener.openUsingBioFormats(output + "pSIM.tif");
					if (imp==null) {
					IJ.error("The pSIM is deleted");}
					imp.show();
					
					ImagePlus imp2 = IJ.openImage(output + "cm.png");
					imp2 = Opener.openUsingBioFormats(output + "cm.png");
					if (imp2==null) {
					IJ.error("The cm is deleted");}
					imp2.show();					
					btnPdsim.setEnabled(false);
					textField_6.setText("Finished");
					}
					}).start();
				btnPdsim.setEnabled(false);
				
				
			}
		});


		
		btnNewButton_2.setEnabled(false);
		btnNewButton_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
//		        final JFrame jf = new JFrame("测试窗口");
//		        calib1_file = showFileOpenDialog(jf); 
//		        if (calib1_file!="0")
//				{btnNewButton_2_1.setEnabled(true);}
		        
				int[] wList = WindowManager.getIDList();
				if (wList==null) {
					IJ.error("No images are open.");
					return;
				}
				String[] titles = new String[wList.length+1];
				String[] all_input = new String[wList.length+1];
				for (int i=0; i<wList.length; i++) {
					ImagePlus imp = WindowManager.getImage(wList[i]);
					all_input[i] = getDirectory(imp);
					titles[i] = imp!=null?imp.getTitle():"";
				}
				titles[wList.length] = none;
				all_input[wList.length] = none;
				String[] names = getInitialNames(wList.length,titles);
				String[] all_dir = getInitialNames(wList.length,all_input);
				
				String options = Macro.getOptions();
				boolean macro = IJ.macroRunning() && options!=null;
				
				GenericDialog gd = new GenericDialog("Calib_1");
				gd.addChoice("Calib_1:", titles, macro?none:names[0]);				
				gd.showDialog();
				
				if (gd.wasCanceled())
					return;
				else
				{
					int index = gd.getNextChoiceIndex();
					calib1_file = all_dir[index] + titles[index];
				}
				
		        if (calib1_file!="0")
		        {btnNewButton_2_1.setEnabled(true);}
		        
		        
			}
		});
		btnNewButton_2.setBounds(172, 33, 24, 23);
		panel_3.add(btnNewButton_2);
		

		btnNewButton_2_1.setEnabled(false);
		btnNewButton_2_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
//		        final JFrame jf = new JFrame("测试窗口");
//		        calib2_file = showFileOpenDialog(jf); 
//		        if (calib2_file!="0")
//		        {btnPdsim.setEnabled(true);}
		        
				int[] wList = WindowManager.getIDList();
				if (wList==null) {
					IJ.error("No images are open.");
					return;
				}
				String[] titles = new String[wList.length+1];
				String[] all_input = new String[wList.length+1];
				for (int i=0; i<wList.length; i++) {
					ImagePlus imp = WindowManager.getImage(wList[i]);
					all_input[i] = getDirectory(imp);
					titles[i] = imp!=null?imp.getTitle():"";
				}
				titles[wList.length] = none;
				all_input[wList.length] = none;
				String[] names = getInitialNames(wList.length,titles);
				String[] all_dir = getInitialNames(wList.length,all_input);
				
				String options = Macro.getOptions();
				boolean macro = IJ.macroRunning() && options!=null;
				
				GenericDialog gd = new GenericDialog("Calib_2");
				gd.addChoice("Calib_2:", titles, macro?none:names[0]);				
				gd.showDialog();
				
				if (gd.wasCanceled())
					return;
				else
				{
					int index = gd.getNextChoiceIndex();
					calib2_file = all_dir[index] + titles[index];
				}
				
		        if (calib2_file!="0")
		        {btnPdsim.setEnabled(true);}
		        
			}
		});
		btnNewButton_2_1.setBounds(273, 33, 24, 23);
		panel_3.add(btnNewButton_2_1);
		
		rdbtnNewRadioButton.setEnabled(false);
		rdbtnNewRadioButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(rdbtnNewRadioButton.isSelected())
				{
				btnNewButton_2.setEnabled(true);
				btnPdsim.setEnabled(false);}
				else 
				{btnPdsim.setEnabled(true);	
				 btnNewButton_2_1.setEnabled(false);
				 btnNewButton_2.setEnabled(false);}
			}
		});
		rdbtnNewRadioButton.setBounds(74, 33, 21, 23);
		panel_3.add(rdbtnNewRadioButton);
		
		JLabel lblNewLabel_3_1_2_3 = new JLabel("Calib");
		lblNewLabel_3_1_2_3.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_3.setBounds(40, 37, 72, 15);
		panel_3.add(lblNewLabel_3_1_2_3);
		
		JLabel lblNewLabel_3_1_2_3_1 = new JLabel("Calib1");
		lblNewLabel_3_1_2_3_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_3_1.setBounds(128, 37, 58, 15);
		panel_3.add(lblNewLabel_3_1_2_3_1);
		
		JLabel lblNewLabel_3_1_2_3_1_1 = new JLabel("Calib2");
		lblNewLabel_3_1_2_3_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_2_3_1_1.setBounds(232, 37, 58, 15);
		panel_3.add(lblNewLabel_3_1_2_3_1_1);
		
		JPanel panel_4 = new JPanel();
		panel_4.setBorder(new TitledBorder(null, "Calibration", TitledBorder.LEADING, TitledBorder.TOP, null, null));
		panel_4.setBounds(21, 17, 298, 52);
		panel_3.add(panel_4);
		
		textField_6 = new JTextField();
		textField_6.setBackground(new Color(250, 240, 230));
		textField_6.setFont(new Font("宋体", Font.PLAIN, 16));
		textField_6.setText("Please choose input image and output dir");
		textField_6.setHorizontalAlignment(SwingConstants.CENTER);
		textField_6.setColumns(10);
		textField_6.setBounds(68, 633, 334, 34);
		contentPane.add(textField_6);
		
		JLabel lblNewLabel_3_1_1 = new JLabel("Refov");
		lblNewLabel_3_1_1.setBounds(15, 42, 72, 15);
		panel_4_1_1.add(lblNewLabel_3_1_1);
		lblNewLabel_3_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		
		textField_9 = new JTextField();
		textField_9.setBounds(62, 39, 51, 21);
		panel_4_1_1.add(textField_9);
		textField_9.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_9.setHorizontalAlignment(SwingConstants.CENTER);
		textField_9.setText("1.512");
		refcov = Double.parseDouble(textField_9.getText());//refov
		textField_9.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refcov = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refcov = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refcov = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_9.setColumns(10);	
		
		textField_12 = new JTextField();
		textField_12.setBounds(190, 66, 56, 21);
		panel_4_1_1.add(textField_12);
		textField_12.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_12.setHorizontalAlignment(SwingConstants.CENTER);
		textField_12.setText("0");
		depth = 1000*Double.parseDouble(textField_12.getText());//depth
		textField_12.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					depth = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					depth = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					depth = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_12.setColumns(10);
		
		JLabel lblNewLabel_3_1_2_2 = new JLabel("Depth(um)");
		lblNewLabel_3_1_2_2.setBounds(126, 69, 72, 15);
		panel_4_1_1.add(lblNewLabel_3_1_2_2);
		lblNewLabel_3_1_2_2.setFont(new Font("Arial", Font.PLAIN, 12));
		
		JLabel lblNewLabel_3_1_2_1 = new JLabel("Fwd(um)");
		lblNewLabel_3_1_2_1.setBounds(131, 42, 72, 15);
		panel_4_1_1.add(lblNewLabel_3_1_2_1);
		lblNewLabel_3_1_2_1.setFont(new Font("Arial", Font.PLAIN, 12));
		
		textField_11 = new JTextField();
		textField_11.setBounds(190, 39, 56, 21);
		panel_4_1_1.add(textField_11);
		textField_11.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_11.setHorizontalAlignment(SwingConstants.CENTER);
		textField_11.setText("140");
		fwd = 1000*Double.parseDouble(textField_11.getText());//fwd
		textField_11.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					fwd = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					fwd = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					fwd = 1000*Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		textField_11.setColumns(10);
		
		JLabel lblNewLabel_3_1 = new JLabel("Refmed");
		lblNewLabel_3_1.setBounds(131, 16, 72, 15);
		panel_4_1_1.add(lblNewLabel_3_1);
		lblNewLabel_3_1.setFont(new Font("Arial", Font.PLAIN, 12));
		
		textField_8 = new JTextField();
		textField_8.setBounds(190, 13, 56, 21);
		panel_4_1_1.add(textField_8);
		textField_8.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_8.setHorizontalAlignment(SwingConstants.CENTER);
		textField_8.setText("1.47");
		refmed = Double.parseDouble(textField_8.getText());//refmed
		textField_8.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refmed  = Double.parseDouble(s);
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refmed  = Double.parseDouble(s);
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";;}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					refmed  = Double.parseDouble(s);
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		}); 
		textField_8.setColumns(10);
		
		JLabel lblNewLabel_3_1_4_2 = new JLabel("Attenuation");
		lblNewLabel_3_1_4_2.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_4_2.setBounds(230, 19, 72, 15);
		panel_1.add(lblNewLabel_3_1_4_2);
		
		textField_23 = new JTextField();
		textField_23.setText("0");
		Attenuation = Double.parseDouble(textField_23.getText());//fwd
		textField_23.setHorizontalAlignment(SwingConstants.CENTER);
		textField_23.setFont(new Font("Arial", Font.PLAIN, 12));
		textField_23.setColumns(10);
		textField_23.setBounds(310, 16, 43, 21);
		textField_23.getDocument().addDocumentListener (new DocumentListener() {
			@Override
			public void insertUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					Attenuation = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}
			@Override
			public void removeUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					Attenuation = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}			
			}
			@Override
			public void changedUpdate(DocumentEvent e) {
				Document doc = e.getDocument();
				try {
					String s ;
					if (doc.getLength()==0)  {s = "0";}
					else                     
					{
						s = doc.getText(0, doc.getLength());
						if( s.substring(0,s.length()-1) == ".")
						{s="0";}
					}
					Attenuation = Double.parseDouble(s);//pixelsize_x
				} catch (BadLocationException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}		
			}							
		});
		panel_1.add(textField_23);
		
		JLabel lblNewLabel_3_1_4_1_1 = new JLabel("0~1");
		lblNewLabel_3_1_4_1_1.setFont(new Font("Arial", Font.PLAIN, 12));
		lblNewLabel_3_1_4_1_1.setBounds(363, 17, 72, 15);
		panel_1.add(lblNewLabel_3_1_4_1_1);


	}
}
