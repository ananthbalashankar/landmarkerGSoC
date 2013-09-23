import java.awt.BorderLayout;
import java.awt.EventQueue;
import java.awt.Graphics2D;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.RenderingHints;

import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.BoxLayout;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.ScrollPaneConstants;
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
import com.Sensosaur.*;
import com.mathworks.toolbox.javabuilder.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;


public class MainWindow {

	private JFrame frame;
	private String foldername;
	private List<File> features;
	private JComboBox comboBox;
	private Connection connect;
	private Statement statement;
	
	private visualize v;
	JTabbedPane tab;
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

	private void setCloseButton(int index)
	{
		String title = tab.getTitleAt(index);
		JPanel pnlTab = new JPanel(new GridBagLayout());
		pnlTab.setOpaque(false);
		JLabel lblTitle = new JLabel(title);
		JButton btnClose = new JButton("x");

		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.weightx = 1;

		pnlTab.add(lblTitle, gbc);

		gbc.gridx++;
		gbc.weightx = 0;
		pnlTab.add(btnClose, gbc);

		tab.setTabComponentAt(index, pnlTab);
		MyCloseActionHandler myCloseActionHandler = new MyCloseActionHandler(title);
		btnClose.addActionListener(myCloseActionHandler);
	}
	
	

	public class MyCloseActionHandler implements ActionListener {

	    private String tabName;

	    public MyCloseActionHandler(String tabName) {
	        this.tabName = tabName;
	    }

	    public String getTabName() {
	        return tabName;
	    }

	    public void actionPerformed(ActionEvent evt) {

	    	
	        int index = tab.indexOfTab(getTabName());
	        if (index >= 0) {

	            tab.removeTabAt(index);
	            // It would probably be worthwhile getting the source
	            // casting it back to a JButton and removing
	            // the action handler reference ;)

	        }

	    }

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
					img = scaleImage(600,600,image);
					ImageIcon icon = new ImageIcon(img);
					JLabel lblPicture = new JLabel();
					lblPicture.setIcon(icon);
					lblPicture.setBounds(10, 104, 600, 600);
					JPanel picturePane = new JPanel();
					picturePane.add(lblPicture);
					int index = tab.getTabCount();
					tab.addTab(features.get(i).getName(), picturePane);
					setCloseButton(index);
				} catch (Exception e) {
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
		 
		 //for (int i=0;i<filenames.length;i++)
			// v.stabilize(0,filenames[i],1,1);
		 MWCellArray file = null;
		 file = new MWCellArray(filenames.length,1);
		 for(int j=0;j<filenames.length;j++)
			 file.set(j+1,filenames[j]);
		
		 result = v.heatMap(1,file);
		 
		 //String image = "/home/swadhin/Landmark/landmarkerGSoC/sensosaur/stable/heatMap.png";
		MWArray im = (MWArray)result[0];
		String image = im.toString();
		 BufferedImage img;
		img = scaleImage(600,600,image);
		ImageIcon icon = new ImageIcon(img);
		JLabel lblPicture = new JLabel();
		lblPicture.setIcon(icon);
		lblPicture.setBounds(10, 104, 600, 600);
		JPanel heatMapPane = new JPanel();
		heatMapPane.add(lblPicture);
		int index = tab.getTabCount();
		tab.addTab("Heat Map", heatMapPane);
		setCloseButton(index);
		
		
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	 
	 
	}
	
	public BufferedImage scaleImage(int WIDTH, int HEIGHT, String filename) {
	    BufferedImage bi = null;
	    try {
	        ImageIcon ii = new ImageIcon(filename);//path to image
	        bi = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
	        Graphics2D g2d = (Graphics2D) bi.createGraphics();
	        g2d.addRenderingHints(new RenderingHints(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_QUALITY));
	        g2d.drawImage(ii.getImage(), 0, 0, WIDTH, HEIGHT, null);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	    return bi;
	}
	
	private void readComments()
	{
		try {
			v = new visualize();
			String[] columns = { "Comment Id","Comment Text","X Axis","Y Axis","Ratings"};
			Object[][] data = null;
			
			Object[] result = v.readComments(1);
			
			MWCellArray y = (MWCellArray)result[0];
			//String image = "stable/comments.png";
			MWArray im = (MWArray)y.getCell(new int[]{1,2});
			String image = im.toString();
			//String rating = "stable/ratings.png";
			MWArray ra = (MWArray)y.getCell(new int[]{1,3});
			String rating = ra.toString();
			
			MWCellArray x = (MWCellArray)y.getCell(new int[]{1,1});
			 BufferedImage img,img1;
			try {
				
				JPanel commentPane = new JPanel();
				
				img = scaleImage(600,600,image);
				ImageIcon icon = new ImageIcon(img);
				JLabel lblComment = new JLabel();
				lblComment.setIcon(icon);
				lblComment.setBounds(10, 100, 600, 600);
				commentPane.add(lblComment);
				
				
				JPanel ratingPane = new JPanel();
				img1 = scaleImage(600,600,rating);
				ImageIcon icon1 = new ImageIcon(img1);
				JLabel lblRating = new JLabel();
				lblRating.setIcon(icon1);
				lblRating.setBounds(10,100,600,600);
				ratingPane.add(lblRating);
				
				int index = tab.getTabCount();
				tab.addTab("Comment Cloud",commentPane);
				setCloseButton(index);
				
				index = tab.getTabCount();
				tab.addTab("Ratings Map",ratingPane);
				setCloseButton(index);
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			
			
			data = new Object[x.getDimensions()[1]][5];
			
			for (int i=1;i<=x.getDimensions()[1];i++)
			{
			MWCellArray arr = (MWCellArray)x.getCell(new int[]{1,i});
			
			MWArray r = arr.getCell(new int[]{1,2});
			String comment = r.toString();
			MWArray r1 = arr.getCell(new int[]{1,1});
			String ratings = r1.toString();
			
			MWArray pos = arr.getCell(new int[]{1,6});
			Double xval = (Double)pos.get(1);
			Double yval = (Double)pos.get(2);
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
			data[index][4] = ratings;
			}
			
			JTable table = new JTable(data,columns);
			table.setFocusable(false);
			
			//table.setBounds(900, 100, 300, 200);
			//frame.getContentPane().add(table);
			
			JScrollPane pane = new JScrollPane(table);
			pane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS); 
			table.setFillsViewportHeight(true);
			pane.setBounds(900,100,300,200);
			frame.getContentPane().add(pane,BorderLayout.EAST);
	        
			
			
		} catch (MWException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	void getTrend(File[] files)
	{
		visualize v;
		try {
			v = new visualize();
			MWCellArray file = null;
			file = new MWCellArray(files.length,1);
			for(int j=0;j<files.length;j++)
				file.set(j+1,files[j].getAbsolutePath());
			Object[] result = v.getTrend(1,file);
			
			//String image = "/home/swadhin/Landmark/landmarkerGSoC/sensosaur/stable/Trend.png";
			MWArray im= (MWArray)result[0];
			String image = im.toString();
			BufferedImage img;
			img = scaleImage(600,600,image);
			ImageIcon icon = new ImageIcon(img);
			JLabel lblPicture = new JLabel();
			lblPicture.setIcon(icon);
			lblPicture.setBounds(10, 104, 600, 600);
			JPanel heatMapPane = new JPanel();
			heatMapPane.add(lblPicture);
			int index = tab.getTabCount();
			tab.addTab("Trend", heatMapPane);
			setCloseButton(index);
			
		} catch (Exception e) {
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
		
		tab = new JTabbedPane();
		tab.setBounds(10, 100, 800, 800);
		frame.getContentPane().add(tab);
		
		JLabel lblFolder = new JLabel("Feature");
		lblFolder.setBounds(45, 32, 70, 14);
		frame.getContentPane().add(lblFolder);
		
		JMenuBar menuBar = new JMenuBar();
		menuBar.setBounds(0, 0, 97, 21);
		frame.getContentPane().add(menuBar);
		
		
		JMenu mnFile = new JMenu("File");
		menuBar.add(mnFile);
		
		
	     /* // Setup the connection with the DB
	      try {
	    	Class.forName("com.mysql.jdbc.Driver");
			connect = DriverManager
			      .getConnection("jdbc:mysql://localhost/landmark?"
			          + "user=root&password=swadhin");
			 statement = connect.createStatement();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/

	      // Statements allow to issue SQL queries to the database
	     
		
		JMenuItem mntmOpen = new JMenuItem("Open Trace");
		mntmOpen.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				JFileChooser chooser = new JFileChooser();
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				chooser.setCurrentDirectory(new File("/home/ananthbalashankar/landmarkerGSoC/Server/www/data/"));
			    int returnVal = chooser.showOpenDialog(null);
			    if(returnVal == JFileChooser.APPROVE_OPTION) {
			       System.out.println("You chose to open this file: " +
			            chooser.getSelectedFile().getAbsolutePath());
			       foldername = chooser.getSelectedFile().getAbsolutePath();
			       loadProject();
			    }
			}
		});
		
		JMenuItem mntmChooseTraces = new JMenuItem("View Heatmap");
		mntmChooseTraces.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				JFileChooser chooser = new JFileChooser();
				chooser.setCurrentDirectory(new File("/home/ananthbalashankar/landmarkerGSoC/Server/www/data/"));
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
		
		JMenuItem mntmViewTrend = new JMenuItem("View Trend");
		mntmViewTrend.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				JFileChooser chooser = new JFileChooser();
				chooser.setCurrentDirectory(new File("/home/ananthbalashankar/landmarkerGSoC/Server/www/data/"));
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				chooser.setMultiSelectionEnabled(true);
			    int returnVal = chooser.showOpenDialog(null);
			    if(returnVal == JFileChooser.APPROVE_OPTION) {
			       
			       File[] selected =  chooser.getSelectedFiles();
			       getTrend(selected);
			       //loadProject();
			    }
			}
		});
		mnFile.add(mntmViewTrend);
		
		comboBox = new JComboBox();
		comboBox.setBounds(125, 29, 117, 21);
		frame.getContentPane().add(comboBox);
		
		
	}
}
