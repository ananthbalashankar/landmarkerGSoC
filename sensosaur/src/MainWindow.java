import java.awt.EventQueue;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.BoxLayout;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.SwingConstants;
import javax.swing.JList;
import javax.swing.JFileChooser;
import javax.swing.JMenuBar;
import javax.swing.JComboBox;
import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.filechooser.FileFilter;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.SensoSaur.*;
import com.mathworks.toolbox.javabuilder.*;


public class MainWindow {

	private JFrame frame;
	private String foldername;
	private List<File> features;
	private JComboBox<String> comboBox;
	private JLabel lblPicture;
	private visualize v;
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					MainWindow window = new MainWindow();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public MainWindow() {
		initialize();
	}

	private void loadProject()
	{
		File folder = new File(foldername);
	    File[] listOfFiles = folder.listFiles();
	    comboBox.addItem("Select");
	    //features -- images of paths with landmarks overlay
	    features = new ArrayList<File>();
	    for (int i = 0; i < listOfFiles.length; i++) 
	    {
	     if (listOfFiles[i].isFile()) 
	     {
	    	 if(listOfFiles[i].getName().contains(".png"))
	    	 {
	    		 features.add(listOfFiles[i]);
	    		 comboBox.addItem(listOfFiles[i].getName());
	    	 }
	    	 System.out.println(listOfFiles[i].getName());
	     }
	    }
	    
	    comboBox.addActionListener(new ActionListener(){

			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				int i = comboBox.getSelectedIndex() - 1;
				if(i<0)
					return;
				try {
					String image = features.get(i).getAbsolutePath();
					BufferedImage img;
					img = ImageIO.read(new File(image));
					ImageIcon icon = new ImageIcon(img);
					lblPicture.setIcon(icon);
					lblPicture.setBounds(10, 104, 875, 656);
					frame.getContentPane().add(lblPicture);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		         
			}
	    
	    });
	}
	
	private void getAnalytics(File[] files)
	{
	try {
		v = new visualize();
		String[] filenames = new String[files.length];
		 for(int i=0;i<files.length;i++)
			 filenames[i] = files[i].getAbsolutePath();
		 
		 Object[] result = null;
		 result = v.makeSqr(1, 5);
		 for (int i=0;i<filenames.length;i++)
			 v.stabilize(0,filenames[i],1,1);
		 v.heatMap();
		 
		 String image = "D:/Documents/GSoC/landmarkerGSoC/Matlab/heatMap.png";
		 BufferedImage img;
		img = ImageIO.read(new File(image));
		ImageIcon icon = new ImageIcon(img);
		lblPicture.setIcon(icon);
		lblPicture.setBounds(10, 104, 875, 656);
		frame.getContentPane().add(lblPicture);
		
		
	} catch (MWException | IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	 
	 
	}
	
	
	private void readComments()
	{
		try {
			v = new visualize();
			String[] columns = { "Comment Id","Comment Text","X Axis","Y Axis"};
			Object[][] data = null;
			
			Object[] result = v.readComments(1);
			
			String image = "stable/comments.png";
			 BufferedImage img;
			try {
				img = ImageIO.read(new File(image));
				ImageIcon icon = new ImageIcon(img);
				lblPicture.setIcon(icon);
				lblPicture.setBounds(10, 104, 1200, 900);
				frame.getContentPane().add(lblPicture);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			MWCellArray x = (MWCellArray)result[0];
			data = new Object[x.getDimensions()[1]][4];
			
			for (int i=1;i<=x.getDimensions()[1];i++)
			{
			MWCellArray arr = (MWCellArray)x.getCell(new int[]{1,i});
			
			MWArray r = arr.getCell(new int[]{1,2});
			String comment = r.toString();
			
			MWArray pos = arr.getCell(new int[]{1,6});
			double xval = (double)pos.get(1);
			double yval = (double)pos.get(2);
			System.out.println(xval);
			System.out.println(yval);
			System.out.println(pos);
			
			System.out.println(comment);
			System.out.println(arr);
			int index = i-1;
			data[index][0] = new Integer(i);
			data[index][1] = comment;
			data[index][2] = new Double(xval);
			data[index][3] = new Double(yval);
			}
			JTable table = new JTable(data,columns);
			table.setBounds(1000, 0, 300, 200);
			frame.getContentPane().add(table);
			
		} catch (MWException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
		//frame.setBounds(100, 100, 480, 367);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		JLabel lblFolder = new JLabel("Feature");
		lblFolder.setBounds(45, 32, 46, 14);
		frame.getContentPane().add(lblFolder);
		
		JMenuBar menuBar = new JMenuBar();
		menuBar.setBounds(0, 0, 97, 21);
		frame.getContentPane().add(menuBar);
		
		lblPicture = new JLabel("Picture");
		
		JMenu mnFile = new JMenu("File");
		menuBar.add(mnFile);
		
		JMenuItem mntmOpen = new JMenuItem("Open Trace");
		mntmOpen.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				JFileChooser chooser = new JFileChooser();
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			    int returnVal = chooser.showOpenDialog(null);
			    if(returnVal == JFileChooser.APPROVE_OPTION) {
			       System.out.println("You chose to open this file: " +
			            chooser.getSelectedFile().getAbsolutePath());
			       foldername = chooser.getSelectedFile().getAbsolutePath();
			       loadProject();
			    }
			}
		});
		
		JMenuItem mntmChooseTraces = new JMenuItem("Choose Traces");
		mntmChooseTraces.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				JFileChooser chooser = new JFileChooser();
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				chooser.setMultiSelectionEnabled(true);
			    int returnVal = chooser.showOpenDialog(null);
			    if(returnVal == JFileChooser.APPROVE_OPTION) {
			       
			       File[] selected =  chooser.getSelectedFiles();
			       getAnalytics(selected);
			       //loadProject();
			    }
				
			}
		});
		mnFile.add(mntmChooseTraces);
		
		JMenuItem mntmViewComments = new JMenuItem("View Comments");
		mntmViewComments.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				readComments();
			}
		});
		mnFile.add(mntmViewComments);
		mnFile.add(mntmOpen);
		
		comboBox = new JComboBox<String>();
		comboBox.setBounds(125, 29, 117, 21);
		frame.getContentPane().add(comboBox);
		
		
	}
}
