/* KWIRK - (c) 2001 Rémi Peyronnet */

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import java.net.*;
import java.applet.*;
import java.io.*;
import java.util.*;

/** 
 * A good game.<p>
 *
 
 * @version 	0.01, 19/10/2001
 * @author Rémi Peyronnet
 */

public class kwirk extends Applet implements MouseListener, KeyListener, WindowListener, AppletStub, AppletContext, ImageObserver {

    // This exception is no longer used
    //public class WinKWException extends Exception {};

    // This Frame is used when running in standalone mode.
    static Frame f;
    // This var reveals either or not we are in Applet or Standalone mode
    static boolean isApplet=true;

    // These vars describe the size of the panel.
    final static short xmax = 20;
    final static short ymax = 18;
    // This array gives the directions :
    // - [dir][0] : x increment
    // - [dir][1] : y increment
    // - [dir][2] : mask 0xF0 corresponding to the direction
    final static short dirs[][]={{-1,0,0x80},{0,-1,0x40},{1,0,0x20},{0,1,0x10}};
    // REMOVE final static short dirs_tourn_direct[][]={{1,1},{-1,1},{-1,-1},{1,-1}};
    // REMOVE final static short dirs_tourn_indirect[][]={{1,-1},{1,1},{-1,1},{-1,-1}};

    // These vars tell which blocs need to be updated
    int bloc_updt_xmin=xmax, bloc_updt_xmax=0, bloc_updt_ymin=ymax, bloc_updt_ymax=0;

    // Images are stored there
    Image imgFond;
    Image imgBlocs[];
    Image imgAnim;

    boolean paint_all=true;
 
    // Information (x,y) about the players, the current player, and the number of players
    int playerCur = 0, playerNum = 1;
    int playerPos[][] = {{0,0},{0,0},{0,0},{0,0}};

    // Informations about the levels 
    // - the name of the current level (to display)
    // - the max number of levels
    // - the current number of the level in the vector list
    // - the filenames of the levels, as described in the levels/levels.txt
    String levelName="";
    int levelsMax=0;
    int levelsCur=0;
    Vector levelsFilename;
  
    // This array contains information about the blocs
    // * Mask of encadrement (0xF0)
    //   - bit 7 : left 
    //   - bit 6 : up
    //   - bit 5 : right
    //   - bit 4 : down
    // * Type of the block
    //    0 = vide        5 = joueur 2    A = pivot tourniquet
    //    1 = mur         6 = joueur 3    B = tourniquet ext. sur sol
    //    2 = sortie      7 = joueur 4    C = tourniquet ext. sur trou
    //    3 = trou        8 = bloc sur sol
    //    4 = joueur 1    9 = bloc sur trou
    // WARNING : Be _very_ carefull when coding the mask 0xF0. It is 
    //     very very often used...
    short blocs[][];
  
    // This method is used when he application is run in standalone mode
    // It just tries to emulate an applet, by opening a form
    public static void main (String[] args)
    {
     isApplet = false;              // We are running in standalone mode
     f = new Frame("Kwirk !");      // Create the frame
     kwirk k = new kwirk();
     k.setSize(k.getPreferredSize().width,k.getPreferredSize().height); // resize deprecated
     f.add(k);                      // Add kwirk to the Frame
     k.init_kwirk();
     f.addWindowListener(k);        // This is to close the app.
     f.setSize(k.getPreferredSize().width,k.getPreferredSize().height); // resize deprecated
     f.show();
     f.setVisible(true);
     k.start();
    }

    // APPLET EMULATION =================================================
    
    public Dimension getPreferredSize()
    {
     return new Dimension(800,666);
    }

    public Dimension getMinimumSize()
    {
     return new Dimension(800,640);
    }

    // AppletStub
    public boolean isActive() { if (isApplet) { return(super.isActive()); } else  {return true; } }
    // We return an URL file:/// 
    public URL getDocumentBase() 
    {
     if (isApplet) return(super.getDocumentBase());
     URL gcb;
     try 
     { 
      //gcb = new URL(""+System.getProperty("user.dir")+"/"); 
      gcb = new URL("file:///"+System.getProperty("user.dir")+"/"); 
      //System.out.print(System.getProperty("user.dir"));
      return(gcb);
     }
     catch (MalformedURLException e) { System.out.print("Malformed URL\n"); System.exit(1);}
     return (null);
    }
    public URL getCodeBase() { if (isApplet) { return(super.getCodeBase()); } else { return getDocumentBase(); } }
    public String getParameter(String name) { if (isApplet) { return(super.getParameter(name)); } else { return(null);  } }
    public AppletContext getAppletContext() { if (isApplet) { return(super.getAppletContext()); } else { return(this); }};
    public void appletResize(int width, int height) { f.setSize(width, height); }
    // AppletContext
    // Here are some problems with some sdk 
    public AudioClip getAudioClip(URL url) { if (isApplet) { return(super.getAudioClip(url));} else { return(null/*Applet.newAudioClip(url)*/); }}
    // I did not found another mean than reading the image myself...
    public Image getImage(URL url) 
    {
     if (isApplet) return(super.getImage(url));
     String l;
     // This is to remove the file:/// inserted...
     String ffile = url.toString().substring( (System.getProperty("file.separator").equals("\\"))?8:6,url.toString().length());
     try { 
      int len = (int)(new File(ffile)).length();
      BufferedInputStream reader = new BufferedInputStream(new FileInputStream(ffile));
      byte buf[] = new byte[len+12];
      reader.read(buf,0,len);
      Image tmpImg = f.getToolkit().createImage(buf);
      return tmpImg;
     }
     catch (IOException e) { System.out.print("Impossible de lire le fichier - "+e.getMessage()+"\n"); } 
     return(null); 
    }
    // Here are some problems with certains jdk.
    public Applet getApplet(String name) {/* if (isApplet) {return(super.getAppletContext().getApplet(name)); } else {*/ return(null);/* }*/}
    public Enumeration getApplets() { /*if (isApplet) { return(super.getAppletContext().getApplets()); } else {*/ return(null);/* }*/}
    public void showDocument(URL url) { /*if (isApplet) super.getAppletContext().showDocument(url);*/ }
    public void showDocument(URL url, String target) { /*if (isApplet) super.getAppletContext().showDocument(url, target);*/ }
    public void showStatus(String status) { /*if (isApplet) { super.showStatus(status); } else {*/ System.out.print(status);/* }*/}
     
    // To handle the closing of the window
    // WindowListener
    public void windowClosing(WindowEvent e)
    {
     e.getWindow().setVisible(false);
     e.getWindow().dispose();
     System.exit(0);
    }
    public void windowOpened(WindowEvent e) { }
    public void windowActivated(WindowEvent e) { }
    public void windowClosed(WindowEvent e) { }
    public void windowDeactivated(WindowEvent e) { }
    public void windowDeiconified(WindowEvent e) { }
    public void windowIconified(WindowEvent e) { }
  
    // END OF APPLET EMULATION ==========================================

   
    // INITIALISATION ===================================================
   
    // This method is called when it is an applet
    public void init()
    {
     init_kwirk();
    }

    // All the init job is done there.
    public void init_kwirk() 
    {
     System.out.print("Kwirk - 2001 RP.\n");
     System.out.print("isApplet = "+isApplet+"\n");
     Image imgMur;

     // Load images
	 imgFond = getImage(getCodeBase(), "imgs/k_fond.jpg");
	 imgMur = getImage(getCodeBase(), "imgs/k_mur.gif");
     imgBlocs = new Image [16];
     for(int i=0; i<16; i++)
       imgBlocs[i]=imgMur;
     imgBlocs[0]=getImage(getCodeBase(), "imgs/k_blanc.gif");
     imgBlocs[1]=getImage(getCodeBase(), "imgs/k_mur.gif");
     imgBlocs[2]=getImage(getCodeBase(), "imgs/k_sortie.gif");
     imgBlocs[3]=getImage(getCodeBase(), "imgs/k_trou.gif");
     imgBlocs[4]=getImage(getCodeBase(), "imgs/k_joueur1.gif");
     imgBlocs[5]=getImage(getCodeBase(), "imgs/k_joueur2.gif");
     imgBlocs[6]=getImage(getCodeBase(), "imgs/k_joueur3.gif");
     imgBlocs[7]=getImage(getCodeBase(), "imgs/k_joueur4.gif");
     imgBlocs[8]=getImage(getCodeBase(), "imgs/k_bloc_sol.gif");
     imgBlocs[9]=getImage(getCodeBase(), "imgs/k_bloc_trou.gif");
     imgBlocs[10]=getImage(getCodeBase(), "imgs/k_tourn_centre.gif");
     imgBlocs[11]=getImage(getCodeBase(), "imgs/k_tourn_ext_sol.gif");
     imgBlocs[12]=getImage(getCodeBase(), "imgs/k_tourn_ext_trou.gif");
     //imgAnim=getImage(getCodeBase(), "imgs/anim.gif");
     
     // Wait for the images to be loaded
     try {
      MediaTracker mt = new MediaTracker(this);
      mt.addImage(imgFond,17);
      for(int i=0; i<16; i++) mt.addImage(imgBlocs[i],i);
      mt.waitForAll();
     } catch (Exception e) {}

     // Read the level list file (levels/levels.txt)
     //  this file containes the name of the level files.
     URL levelPath=getCodeBase();
     URLConnection levelConn;
     String l;
     try { 
      System.out.print("Loading levels list\n");
      BufferedReader reader;
      String levellistName = "levels/levels.txt";
      // We have a different reader whether we are an applet or not
      if (isApplet)
      {
       levelPath =new URL(getCodeBase(),levellistName); 
       levelConn = levelPath.openConnection();
       levelConn.connect();
       reader = new BufferedReader(new InputStreamReader(levelConn.getInputStream()));
      }
      else
      {
        reader = new BufferedReader(new InputStreamReader(new FileInputStream(levellistName)));
      }
      levelsFilename = new Vector ();
      levelsMax = 0;
      while ((l = reader.readLine())!=null)
      {
       levelsFilename.addElement(l);
       levelsMax++;
      }
      
      // Perfom other initialisation stuff
      addMouseListener(this);
      addKeyListener(this);
      init_level(0);   // 0
     }
     catch (MalformedURLException e) { System.out.print("Mauvaise URL - "+e.getMessage()); } 
     catch (IOException e) { System.out.print("Impossible de lire le fichier - "+e.getMessage()); } 
    }

    // This very simple function is used to convert Hex values.
    static short translateHex(char hex) {
      if (hex >= 'A')
        if (hex >= 'a')
         {
          return (short)((hex & 0xdf) - 'a' + 10);
         } else {
          return (short)((hex & 0xdf) - 'A' + 10);
         } 
      else
        return (short)(hex - '0');
     }

    // This function loads a level.
    //   the level filename is registered in the vector created from levels/levels.txt in the init func.
    public void init_level(int l) 
    {
     levelsCur = l;
     URL levelPath=getCodeBase();
     URLConnection levelConn;
     blocs = new short[18][20];
     /* DEPRECATED : Load the test level (see at the end of the file)
     // Copie les blocs du niveau en RAM
     for (int i=0;i<xmax;i++)
      for (int j=0;j<ymax;j++)
        blocs[j][i]=level_blocs[j][i];
     for (int i = 0; i < 4; i++)
     {
      playerPos[i][0]=level_player_pos[i] % xmax;
      playerPos[i][1]=level_player_pos[i] / xmax;
     }
     */
     
     // Parse the level file
     // Note: this parsing stage is very "tricky". it relies on some triggers.
     //    the format of the file is because of compatibility with the same
     //    game in assembly on TI89/92
     try { 
      Reader reader;
      String levelFileName = "levels/"+levelsFilename.elementAt(l);
      if (isApplet)
      {
       levelPath =new URL(getCodeBase(),levelFileName); 
       System.out.print("Loading level " + levelPath+"\n");
       levelConn = levelPath.openConnection();
       levelConn.connect();
       reader = new InputStreamReader(levelConn.getInputStream());
      }
      else
      {
       reader = new InputStreamReader(new FileInputStream(levelFileName));
      }
      int c;
      // Lecture du tableau bloc.
      for (int j=0;j<ymax;j++)
       for (int i=0;i<xmax;i++)
       {
         // On se cale sur le prochain $
         while ((c=reader.read())!='$');
         blocs[j][i]=(short)(16*translateHex((char)reader.read())+translateHex((char)reader.read()));
       }
      // Lecture des informations complémentaires 
      // Lecture de nombre de joueurs et du joueur courant
      while (reader.read()!='b');  // Calage sur b.
      while (!Character.isDigit((char)(c=reader.read())));
      playerNum = Integer.parseInt("0"+(char)c);
      while (!Character.isDigit((char)(c=reader.read())));
      playerCur = Integer.parseInt("0"+(char)c);
      System.out.print(" * Players - Num="+playerNum+" Cur="+playerCur+"\n");
      // Lecture des positions des joueurs
      while (reader.read()!='w');  // Calage sur w.
      int pos = 0;
      for (int i=0;i<4;i++)
      {
       while (!Character.isDigit((char)(c=reader.read()))); // Calage sur prochain chiffre.
       pos = Integer.parseInt("0"+(char)c);
       while (Character.isDigit((char)(c=reader.read())))
       {  // Lecture chiffre
        pos = pos * 10 + Integer.parseInt("0"+(char)c);
       }
       playerPos[i][0]=pos % xmax;
       playerPos[i][1]=pos / xmax;
       System.out.print(" * Player "+i+" pos="+pos+"\n");
      }
      // Lecture du nom du niveau
      while (reader.read()!='"');  // Calage sur ".
      levelName = "";
      while ((c=reader.read())!='"') 
        { levelName += (char)c; }
      System.out.print(" * Level name : "+levelName+"\n");
      System.out.print("Level successfully loaded !\n");
     }
     catch (MalformedURLException e) { System.out.print("Mauvaise URL - "+e.getMessage()); } 
     catch (IOException e) { System.out.print("Impossible de lire le fichier - "+e.getMessage()); } 
     
    }
    
    // Destroy the application
    public void destroy() 
    {
        removeMouseListener(this);
    }
    
    // DISPLAY SECTION ==================================================
    
    // This function displays a block.
    public void affBloc(Graphics g, Dimension d, Image img, int x, int y)
    {
     g.drawImage(img, 32*x + 28, 32*y + 35, this);
    }

    // This function adds the border lines according to the mask.
    public void affBlocLine(Graphics g, Dimension d, int l, int x, int y)
    {
     if ((l & 0x80) != 0) g.drawLine(32*x+28 + 0, 32*y+35 + 0, 32*x+28 + 0, 32*y+35 + 31);
     if ((l & 0x40) != 0) g.drawLine(32*x+28 + 0, 32*y+35 + 0, 32*x+28 + 31, 32*y+35 + 0);
     if ((l & 0x20) != 0) g.drawLine(32*x+28 + 31, 32*y+35 + 0, 32*x+28 + 31, 32*y+35 + 31);
     if ((l & 0x10) != 0) g.drawLine(32*x+28 + 0, 32*y+35 + 31, 32*x+28 + 31, 32*y+35 + 31);
    }

    // This paint method redraws all from nothing.
    // an offscreen rendering Graphics object is used.
    // it displays the background, and calls paint_blocs
    public void paint(Graphics g) 
    {
     Image offscreen;
     Graphics og;
     System.out.print("PA ");
     //if (paint_all)
     {
      System.out.print("YY ");
 	  Dimension d = getSize();
  	  offscreen = createImage(d.width, d.height);
	  og = offscreen.getGraphics();
	  og.setColor(Color.black);
      og.drawImage(imgFond, 0, 0, this);
      og.setFont(new Font(og.getFont().getName(),Font.BOLD,24));
      og.drawString(levelName,727,160);
      paint_blocs(og, 0, 0, xmax, ymax);
      g.drawImage(offscreen, 0, 0, this);
      paint_all = false;
     }
     //g.setClip(10,10,400,60);
     //g.drawImage(imgAnim,10,10,this);
    }

    public void update(Graphics g)
    {
     System.out.print("UD ");
     paint_all = true;
     paint(g);
    }

    public void repaint()
    {
     System.out.print("RE ");
     paint_all = true;
     paint(this.getGraphics());
    }

    public boolean imageUpdate(Image img, int infoflags, int x, int y, int w, int h)
    {
     System.out.print("IU ");
     //System.out.print("imageUpdate\n");
     if (img == imgBlocs[playerCur+4]) this.getGraphics().drawImage(img, 32*playerPos[playerCur][0] + 28, 32*playerPos[playerCur][1] + 35, this);
     //return isShowing();
     return true;
    }


    // Paints blocs in the rect xmin,ymin,xmax,ymax.
    public void paint_blocs(Graphics g, int xmin, int ymin, int xmax, int ymax)
    {
	 Dimension d = getSize();
     for (int i=xmin; i<xmax; i++)
      for (int j=ymin; j<ymax; j++)
       { 
        affBloc(g, d, imgBlocs[blocs[j][i] & 0x0F],i,j);
        affBlocLine(g, d, blocs[j][i] & 0xF0,i,j);
       }
    }

    // Paints the blocs that need to be updated
    public void update_blocs()
    {
     Graphics g = this.getGraphics();
     paint_blocs(g,bloc_updt_xmin,bloc_updt_ymin,bloc_updt_xmax+1,bloc_updt_ymax+1);
     bloc_updt_xmin = xmax;
     bloc_updt_xmax = 0;
     bloc_updt_ymin = ymax;
     bloc_updt_ymax = 0;
    }

    // This function is used to mark that this block need to be updated
    public void update_bloc(int x, int y)
    {
     if (x<bloc_updt_xmin) { bloc_updt_xmin = x; }
     if (x>bloc_updt_xmax) { bloc_updt_xmax = x; }
     if (y<bloc_updt_ymin) { bloc_updt_ymin = y; }
     if (y>bloc_updt_ymax) { bloc_updt_ymax = y; }
    }

    // Sets the bloc to the provided value, and marks it as to be updated.
    public void setBloc(int x, int y, int v)
    {
     blocs[y][x]=(short)v;
     update_bloc(x,y);
    }

    // GAME ENGINE ===================================================

    // returns the orthogonal direction
    public int getOrtho(int dir, int sens)
    {
     if (sens > 0) { return ((dir < 3)?dir+1:0);} 
     if (sens < 0) { return ((dir > 0)?dir-1:3);}
     return dir;
    }

    // return the opposite direction
    public int getOpposite(int dir)
    {
     switch(dir)
     {
      case 0: return 2;
      case 1: return 3;
      case 2: return 0;
      case 3: return 1;
     }
     return 0;
    }
     
    // All the game lies there...
    // This function
    // - check if the move is possible
    // - perform the move
    public void try_move(int dir)
    {
      boolean can = true, disp = false;
      int dirx = dirs[dir][0], diry=dirs[dir][1], dirm=dirs[dir][2];
      int bdest = blocs[playerPos[playerCur][1]+diry][playerPos[playerCur][0]+dirx];
      int curx=playerPos[playerCur][0], cury=playerPos[playerCur][1];
      int cur2x=playerPos[playerCur][0], cur2y=playerPos[playerCur][1];
      int cur3x = 0, cur3y = 0;
      int dir2 = dir, dir3=dir, dird = -1;
      int bcur,bcur2,bint;
      // Si c'est autre chose que du vide, a priori on peut pas y aller
      if ((bdest & 0x0F) != 0x00) { can = false; }
      // Test des blocs -------------------------------------------------------
      if ((bdest & 0x0F) == 0x08)
      {
       System.out.print("Bloc\n");
       // On va faire ce test uniquement pour des blocs rectangulaires
       // De mémoire c'est toujours le cas.
       curx += dirx; cury += diry;
       // - on va jusqu'a l'extremite du bloc dans la direction
       System.out.print(" * 1/ x="+curx+", y="+cury+", bloc="+blocs[cury][curx]+"\n");
       cur2x = curx; cur2y = cury;
       while ((blocs[cur2y][cur2x] & dirm) == 0) 
       { 
        cur2x+=dirx; cur2y+=diry; 
       }
       // - on part dans les directions ortho <- et -> dir+1 et dir-1
       can = true;
       // This code is fairly gruiiik, but it is to avoid duplicated code.
       // - go to the extreme left, then go to the right
       dir2 = getOrtho(dir,-1);
       while ((blocs[cur2y][cur2x] & dirs[dir2][2]) == 0) 
         {  cur2x+=dirs[dir2][0]; cur2y+=dirs[dir2][1];  }
       System.out.print(" * 1-/ x="+cur2x+", y="+cur2y+", bloc="+blocs[cur2y][cur2x]+"\n");
       dir2 = getOrtho(dir,1);
       cur2x-=dirs[dir2][0]; cur2y-=dirs[dir2][1];
       do {
        cur2x+=dirs[dir2][0]; cur2y+=dirs[dir2][1];
        if ( ((blocs[cur2y+diry][cur2x+dirx] & 0x0F) != 0) &&
             ((blocs[cur2y+diry][cur2x+dirx] & 0x0F) != 3) )
             { can = false;  }
       } while ( ((blocs[cur2y][cur2x] & dirs[dir2][2]) == 0) );
      }
      // Test des tourniquets ------------------------------------------------
      if ((bdest & 0x0F) == 0x0B)
      {
       System.out.print("Tourniquet.\n");
       // Detection du centre.
       // Detection du centre.
       for(dir2=0; (dir2<4)&&((bdest&dirs[dir2][2])!=0) ;dir2++);
       curx=playerPos[playerCur][0]+dirx+dirs[dir2][0];
       cury=playerPos[playerCur][1]+diry+dirs[dir2][1];
       // On vérifie qu'on est pas dans l'alignement
       if (dir2!=dir)
       {
        can = true;
        // Detection direct_indirect
        dird=(0-diry*(dirx+dirs[dir2][0])+dirx*(diry+dirs[dir2][1]));
        System.out.print(" * Sens "+dird+"\n");
        for (dir3=0;dir3<4;dir3++)
        {
         if ((blocs[cury][curx] & dirs[dir3][2]) == 0)
         { // il y a ici un bloc a pour lequel il faut checker le mouvement
          cur2x = curx + dirs[dir3][0];
          cur2y = cury + dirs[dir3][1];
          cur3x = curx + dirs[getOrtho(dir3,dird)][0];
          cur3y = cury + dirs[getOrtho(dir3,dird)][1];
          bint = blocs[cur2y+cur3y-cury][cur2x+cur3x-curx] & 0x0F;
          if ( (bint != 0x03) && (bint != 0x00) && (bint != (0x04+playerCur)) ) 
          { 
           can = false; 
           System.out.print(" * "+(cur3x+cur2x-curx)+","+(cur2y+cur3y-cury)+":"+bint+" - Jeté par bloc intermédiaire pour ("+cur2x+","+cur2y+")\n");
          }
          bint = blocs[cur3y][cur3x] & 0x0F;
          if ( (bint != 0x00) && (bint != 0x03) )
          {
           if ( ((bint == 0x0B) || (bint == 0x0C)) && 
                ((blocs[cury][curx] & dirs[getOrtho(dir3,dird)][2]) == 0) )
           {} else {
            can = false;
            System.out.print(" * "+cur3x+","+cur3y+":"+blocs[cur3y][cur3x]+" - Jeté par bloc angle pour ("+cur2x+","+cur2y+"\n");
           }
          }
              

         }
        }
       }
      }
      
      // Test de la sortie ---------------------------------------------------
      if ((bdest & 0x0F) == 0x02)
      {
       System.out.print("Sortie !\n");
       can = true;
       disp = true;
       //throw new WinKWException(); throws SUXX !! becauseof KeyListener
       for (int i=0; i < playerNum; i++)
       {
        if (i != playerCur)
        {
         if ( (playerPos[i][0] != (playerPos[playerCur][0]+dirx)) ||
              (playerPos[i][1] != (playerPos[playerCur][1]+diry)) )
           {
            setBloc(playerPos[playerCur][0],playerPos[playerCur][1],0x00);
            playerPos[playerCur][0]+=dirx;
            playerPos[playerCur][1]+=diry;
            playerCur = i;
            System.out.print ("Player "+playerCur+"\n");
            update_blocs();
            return;
           }
        }
       }
       if (levelsCur < levelsMax)
       {
        System.out.print("You won : Next level.\n");
        levelsCur += (levelsCur < levelsMax)?1:0;
        init_level(levelsCur);
        repaint();
       }
       else 
       {
        // Really won
        System.out.print("You really won : No more levels.\n");
        init_level(levelsCur);
        repaint();
       }
       return;
      }

      if (can)
      {
       System.out.print("Move OK.\n");
       // Deplacement des éléments
       // Deplacement des blocs ---------------------------------------------
       if ((bdest & 0x0F) == 0x08)
       {
        // Test de la flotte ==========
        boolean flood = true;
        curx=playerPos[playerCur][0]+dirs[dir][0];
        cury=playerPos[playerCur][1]+dirs[dir][1];
        // Go to the extreme left
        dir2 = getOrtho(dir,-1);
        while ((blocs[cury][curx] & dirs[dir2][2]) == 0) 
          {  curx+=dirs[dir2][0]; cury+=dirs[dir2][1];  }
        // Go to the right and up  
        dir2=getOrtho(dir,1);
        curx-=dirs[dir][0]; cury-=dirs[dir][1];
        do { 
         curx+=dirs[dir][0]; cury+=dirs[dir][1];
         cur2x=curx; cur2y=cury;
         cur2x-=dirs[dir2][0]; cur2y-=dirs[dir2][1];
         do { 
          cur2x+=dirs[dir2][0]; cur2y+=dirs[dir2][1];
          if ( ((blocs[cur2y+diry][cur2x+dirx] & 0x0F) != 9) && 
               ((blocs[cur2y+diry][cur2x+dirx] & 0x0F) != 3) )
               { flood=false; }
         } while ((blocs[cur2y][cur2x] & dirs[dir2][2]) == 0);
        } while ((blocs[cury][curx] & dirm) == 0);
        // Deplacement effectif
        System.out.print(" * BlocFlood : "+flood+"\n");
        // go to the right and down
        dir3=getOpposite(dir);
        dir2=getOrtho(dir,1);
        curx-=dirs[dir3][0]; cury-=dirs[dir3][1];
        do { 
         curx+=dirs[dir3][0]; cury+=dirs[dir3][1];
         cur2x=curx; cur2y=cury;
         cur2x-=dirs[dir2][0]; cur2y-=dirs[dir2][1];
         bcur2=blocs[cury][curx];
         do { 
          cur2x+=dirs[dir2][0]; cur2y+=dirs[dir2][1];
          bcur=blocs[cur2y][cur2x];
          setBloc(cur2x,cur2y,/*(bcur&0xF0) |*/ (((bcur & 0x0F)==9)?3:0));
          setBloc(cur2x+dirx,cur2y+diry,((flood)?0:((bcur&0xF0)|(((blocs[cur2y+diry][cur2x+dirx] & 0x0F)==3)?9:8))));
         } while ((bcur & dirs[dir2][2]) == 0);
        } while ((bcur2 & dirs[dir3][2]) == 0);
        
       }
       // Deplacement du tourniquet ---------------------------------------
       if ((bdest & 0x0F) == 0x0B)
       {
        //short dirs_tourn[][], dird=1;
        // Detection du centre.
        for(dir2=0; (dir2<4)&&((bdest&dirs[dir2][2])!=0) ;dir2++);
        curx=playerPos[playerCur][0]+dirx+dirs[dir2][0];
        cury=playerPos[playerCur][1]+diry+dirs[dir2][1];
        // Detection direct_indirect
        dird=-(0-diry*(dirx+dirs[dir2][0])+dirx*(diry+dirs[dir2][1]));
        // Rotation effective
        // - on commence par gicler tous les tourniquets exterieurs
        for (dir3=0;dir3<4;dir3++)
        {
         if ((blocs[cury][curx] & dirs[dir3][2]) == 0)
         { // il y a ici un bloc a virer
          cur2x = curx + dirs[dir3][0];
          cur2y = cury + dirs[dir3][1];
          setBloc(cur2x,cur2y,((blocs[cur2y][cur2x] & 0x0F) == 0x0C)?3:0);
         }
        }
        // On tourne les flags du centre*
        int temp = blocs[cury][curx] & 0xF0;
        if (dird==1)
        {
         temp <<= 1;
         if ((temp & 0x100) != 0) { temp |= 0x10; }
        }
        else
        {
         temp >>= 1;
         if ((temp & 0x08) != 0) { temp |= 0x80; }
        }
        setBloc(curx,cury, (temp & 0xF0) | 0x0A);
        // On remet les tourniquets exterieurs
        for (dir3=0;dir3<4;dir3++)
        {
         if ((blocs[cury][curx] & dirs[dir3][2]) == 0)
         { // il y a ici un bloc a virer
          cur2x = curx + dirs[dir3][0];
          cur2y = cury + dirs[dir3][1];
          setBloc(cur2x,cur2y,((~(dirs[getOpposite(dir3)][2]))&0xF0) | (((blocs[cur2y][cur2x] & 0x0F) == 0x03)?0x0C:0x0B));
         }
        }
       }
       // Deplacement du joueur -------------------------------------------
        setBloc(playerPos[playerCur][0],playerPos[playerCur][1],0x00);
        playerPos[playerCur][0]+=dirx;
        playerPos[playerCur][1]+=diry;
        if ((blocs[playerPos[playerCur][1]][playerPos[playerCur][0]] & 0x0F) == 0x0B)
        { // S'il y a encore un tourniquet ca veut dire qu'il faut avancer encore
         playerPos[playerCur][0]+=dirx;
         playerPos[playerCur][1]+=diry;
        }
        setBloc(playerPos[playerCur][0],playerPos[playerCur][1],0x04+playerCur);
        update_blocs();
       
      } 
      else
      {
       // Some problems here with jdk not supporting newAudioClip...
     /*  if (isApplet) 
       {*/
        play(getCodeBase(), "audio/beep.au"); 
    /*   }
       else
       {
        try 
        {
         AudioClip ac = Applet.newAudioClip (new URL(getCodeBase(), "audio/beep.au"));
         ac.play();
        } catch (Exception e) { System.out.print(e.getMessage()); }
       }*/
      }
    }

    // INTERFACE GESTION ==================================================

    // Redisplay all after a mouse clic. (TESTING purpose)
    public void mouseReleased(MouseEvent e) 
    {
	 int x = e.getX();
	 int y = e.getY();
 	 Dimension d = getSize();
     paint_all=true;
     repaint();
    }

    public void mousePressed(MouseEvent e) { 
     // Bouton +
     if ( (e.getX() > 720 ) && (e.getX() < 764) &&
          (e.getY() > 75 ) && (e.getY() < 110) )
          { keyPressed(new KeyEvent(this, 0, 0, 0, KeyEvent.VK_ADD)); }
     // Bouton -
     if ( (e.getX() > 720 ) && (e.getX() < 764) &&
          (e.getY() > 200 ) && (e.getY() < 235) )
          { keyPressed(new KeyEvent(this, 0, 0, 0, KeyEvent.VK_SUBTRACT)); }
     // Bouton SUPPR
     if ( (e.getX() > 720 ) && (e.getX() < 764) &&
          (e.getY() > 117 ) && (e.getY() < 190) )
          { keyPressed(new KeyEvent(this, 0, 0, 0, KeyEvent.VK_DELETE)); }
     // Bouton RP
     if ( (e.getX() > 695 ) && (e.getX() < 795) &&
          (e.getY() > 595 ) && (e.getY() < 640) )
          { System.out.print("(c) 2001 RP-Soft. http://www.via.ecp.fr/~remi/\n");  }
    }
    public void mouseClicked(MouseEvent e) {    }
    public void mouseEntered(MouseEvent e) {    }
    public void mouseExited(MouseEvent e) {    }
    public void keyTyped(KeyEvent e) {      }
    
    public void keyPressed(KeyEvent e)
    {
     switch (e.getKeyCode())
     {
      case KeyEvent.VK_LEFT : 
            try_move(0);
            break;
      case KeyEvent.VK_RIGHT : 
            try_move(2);
            break;
      case KeyEvent.VK_UP :
            try_move(1);
            break;
      case KeyEvent.VK_DOWN :
            try_move(3);
            break;
      case KeyEvent.VK_ADD : 
            levelsCur += (levelsCur < levelsMax)?1:0;
            init_level(levelsCur);
            repaint();
            break;
      case KeyEvent.VK_SUBTRACT :
            levelsCur += (levelsCur > 0)?-1:0;
            init_level(levelsCur);
            repaint();
            break;
      case KeyEvent.VK_DELETE :
            init_level(levelsCur);
            repaint();
            break;
      case KeyEvent.VK_PAGE_UP :
            int i = playerCur;
            i = (i<playerNum-1)?i+1:0;
            while (blocs[playerPos[i][1]][playerPos[i][0]]==0x02)
             {
              i = (i<playerNum-1)?i+1:0;
             }
            playerCur=i;
            System.out.print("Player "+i+"\n");
            break;
      case KeyEvent.VK_PAGE_DOWN : 
            i = playerCur;
            i = (i>0)?i-1:playerNum-1;
            while (blocs[playerPos[i][1]][playerPos[i][0]]==0x02)
             {
              i = (i>0)?i-1:playerNum-1;
             }
            playerCur=i;
            System.out.print("Player "+i+"\n");
            break;
      default: break;
     }
    }
    
    public void keyReleased(KeyEvent e) {    }

    public String getAppletInfo() {
	    return "Kwirk";
    }

   // Level Data ---------------------------------------------------------
    // NB Ceci est pour garder la compatibilité avec la version TI ...
    /*      le niveau est construit selon un tableau : 1 case = 1 octet.
      les 4 bits de poids forts sont reserves pour les encadrements des pieces
        bit 7 : gauche
        bit 6 : haut
        bit 5 : droite
        bit 4 : bas
      les 4 bits de poids faible sont pour le type de case
        0 = vide        5 = joueur 2    A = pivot tourniquet
        1 = mur         6 = joueur 3    B = tourniquet ext. sur sol
        2 = sortie      7 = joueur 4    C = tourniquet ext. sur trou
        3 = trou        8 = bloc sur sol
        4 = joueur 1    9 = bloc sur trou
      ATTENTION : bien coder les 4 bits d'encardement, sinon le programme
      ne marchera pas : en effet, ils sont tres tres tres utilises
    
    final static String level_name = new String("05");
    final static short level_nbplayers = 1;
    final static short level_player_pos[] = {194,106,108,110};
    final static short level_blocs[][] = {  
        { 0xC1,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x41,0x61},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x11,0x11,0x11,0x11,0x11,0x11,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x11,0x11,0x11,0x21,0x00,0x00,0x00,0x00,0x00,0x00,0x81,0x11,0x11,0x11,0x01,0x01,0x01,0x21},
        { 0x81,0x21,0x00,0x00,0x00,0xB1,0x00,0x00,0xEB,0x00,0x00,0x00,0xB1,0x00,0x00,0x00,0x81,0x01,0x01,0x21},
        { 0x81,0x21,0x00,0x02,0x00,0x03,0x00,0x00,0xAA,0xF8,0x00,0x00,0x00,0x00,0x04,0x00,0x81,0x01,0x01,0x21},
        { 0x81,0x21,0x00,0x00,0x00,0xE1,0x00,0x00,0xBB,0x00,0x00,0x00,0xE1,0x00,0x00,0x00,0x81,0x01,0x01,0x21},
        { 0x81,0x01,0x41,0x41,0x41,0x21,0x00,0x00,0x00,0x00,0x00,0x00,0x81,0x41,0x41,0x41,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x41,0x41,0x41,0x41,0x41,0x41,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x81,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x21},
        { 0x91,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x31}
     };
    //    ( 1,0                ; Nombre de joueurs et joueur courant),
    //    dc.w 194,106,108,110    ; Position des joueurs),
    //    ( "05",0             ; Numero du Niveau),
   */


}

/* Changelog
 - 23/11/2001 v0.20 : Added Player animation (animated gifs courtesy of Krys)
 - 23/10/2001 v0.15 : Bugs fix & applet/standalone application
 - 22/10/2001 v0.10 : Display and Movements 
 - 19/10/2001 v0.00 : First Line of code
*/
